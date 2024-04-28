//
//  SoundEffect.swift
//  Pemalu
//
//  Created by Christian Aldrich Darrien on 29/04/24.
//

import Foundation
import AVFoundation

class Effect{
    var audioPlayerNode = AVAudioPlayerNode()
    var audioPitchtime = AVAudioUnitTimePitch()
    var audioFile : AVAudioFile
    var audioBuffer : AVAudioPCMBuffer
    var name : String
    var engine : AVAudioEngine
    var isPlaying = false
    
    init?(forSound sound : String, withEngine avEngine:AVAudioEngine){
        
        do{
            
            audioPlayerNode.stop()
            name = sound
            engine = avEngine
            let soundFile = NSURL(fileURLWithPath: Bundle.main.path(forResource: sound, ofType: "mp3")!) as URL
            
            try audioFile = AVAudioFile(forReading: soundFile)
            
            if let buffer = AVAudioPCMBuffer(pcmFormat: audioFile.processingFormat, frameCapacity: AVAudioFrameCount(audioFile.length)){
                audioBuffer = buffer
                try audioFile.read(into: audioBuffer)
                engine.attach(audioPlayerNode)
                engine.attach(audioPitchtime)
                engine.connect(audioPlayerNode, to: audioPitchtime, format: audioBuffer.format)
                engine.connect(audioPitchtime, to: engine.mainMixerNode, format: audioBuffer.format)
            }else{
                return nil
            }
            
        }catch{
            return nil
        }
    }
    
    func play(pitch: Float, speed :Float){
        if !engine.isRunning{
            engine.reset()
            try! engine.start()
        }
        audioPlayerNode.play()
        audioPitchtime.pitch = pitch
        audioPitchtime.rate = speed
        audioPlayerNode.scheduleBuffer(audioBuffer){
            self.isPlaying = false
        }
        isPlaying = true
    }
}

class Sounds{
    let engine = AVAudioEngine()
    var effects:[Effect] = []
    
    func getEffect(_ sound:String) -> Effect? {
        if let effect = effects.first(where: {return isReady($0, sound)}){
            return effect
        }else{
            if let newEffect = Effect(forSound: sound, withEngine: engine){
                effects.append(newEffect)
                return newEffect
            }else{
                return nil
            }
        }
    }
    
    func isReady(_ effect:Effect, _ sound:String)->Bool{
        return effect.name == sound && effect.isPlaying == false
    }
    
    func preload(_ name : String){
        let _ = getEffect(name)
    }
    
    func play(_ name : String, pitch : Float, speed : Float){
        if let effect = getEffect(name){
            effect.play(pitch: pitch, speed: speed)
        }
    }
    
    func play(_ name:String){
        play(name, pitch: 100.0, speed: 1.0)
    }
    
    func play(_ name:String, pitch : Float){
        play(name, pitch:pitch, speed: 1.0)
    }
    
    func play(_ name:String, speed : Float){
        play(name, pitch:0.0, speed: speed)
//        play(name, pitch:0.0, speed: speed)
    }
    
    func disposeSounds(){
        effects = []
    }
    
}
