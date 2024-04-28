//
//  GameScene.swift
//  Pemalu
//
//  Created by Christian Aldrich Darrien on 25/04/24.
//

import SpriteKit
import GameplayKit
import CoreMotion
import CoreHaptics
import AVFoundation


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let manager = CMMotionManager()
    var player = SKSpriteNode()
    var playerTexture = SKTexture(imageNamed: "hammer")
    var target = SKSpriteNode()
    var targetTexture = SKTexture(imageNamed: "nail")
    
    var anchoringPointNode = SKSpriteNode()
//    var anchoringPointTexture = SKTexture()
    
//    var hammerSound = NSURL(fileURLWithPath: Bundle.main.path(forResource: "hammerSound", ofType: "mp3")!)
//    var audioPlayer = AVAudioPlayer()
    
    let sounds = Sounds()
    let pitches:[Float] = [0.0, 100.0, 200.0, 300.0, 400.0, 500.0, 600.0]
//
    
    override func didMove(to view: SKView) {
        
        
        
        self.physicsWorld.contactDelegate = self
        
        player = self.childNode(withName: "hammer") as! SKSpriteNode
        player.physicsBody?.categoryBitMask = 1
        target = self.childNode(withName: "nail") as! SKSpriteNode
        
//        target.physicsBody?.categoryBitMask = 2
        
        anchoringPointNode = self.childNode(withName: "anchoringPoint") as! SKSpriteNode

//        let targetBody = SKPhysicsBody(rectangleOf: target.size)
//                targetBody.isDynamic = false
//                target.physicsBody = targetBody
//        targetBody.categoryBitMask = 2
        
        sounds.preload("Hammer sound")
        
        manager.startAccelerometerUpdates()
        manager.accelerometerUpdateInterval = 0.05
        manager.startAccelerometerUpdates(to: OperationQueue.main){
            (data, error) in
            self.physicsWorld.gravity = CGVectorMake(CGFloat(-1*(data?.acceleration.y)!) * 10, CGFloat((data?.acceleration.x)!) * 70)
        }
        
                
        let anchoringPointBody = SKPhysicsBody(rectangleOf: anchoringPointNode.size)
        //        print(anchoringPointNode.size)
        anchoringPointBody.isDynamic = false
        anchoringPointNode.physicsBody = anchoringPointBody
                    
        let playerBody = SKPhysicsBody(texture: playerTexture, size: player.size)
        playerBody.isDynamic = true // Ensure the hammer can move
        playerBody.affectedByGravity = true
        player.physicsBody = playerBody
        playerBody.categoryBitMask = 1
        playerBody.restitution = 0
        playerBody.friction = 0
//        print(player.attributeValues)
                    // Create a pin joint between anchoring point and hammer
        let pinJoint = SKPhysicsJointPin.joint(withBodyA: anchoringPointBody, bodyB: playerBody, anchor: CGPoint(x: 221.561, y: 106.796))
        self.physicsWorld.add(pinJoint)
        
//        try! audioPlayer = AVAudioPlayer(contentsOf: hammerSound as URL, fileTypeHint: nil)
//        audioPlayer.prepareToPlay()
        
        
        
        self.sounds.play("Hammer sound")
        
    }
    
    var playerSum = [Int]()
    var sum : Int = 0
    var flag : Bool = false
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB
        var sumHit = sum
//        var sum:Int = 0
//        print("Testing")
//        || (bodyA.categoryBitMask == 2 && bodyB.categoryBitMask == 1
        
        sounds.play("Hammer sound")
        print("something")
        
        
        if startMotionUpdates() && (bodyA.categoryBitMask == 1 && bodyB.categoryBitMask == 2){
            
            //EndScene
            
//            if startMotionUpdates() > 3.0{
//                startMotionUpdates()
            playCustomHaptic()
//            playHammerSound()
//            playSound(sound)
//            audioPlayer.play()
            
            sum+=1
            if sum % 2 == 0{
                sumHit /= 2
                print(sumHit+1)
            }
//            }
            
//            sum+=1
//            playerSum.append(sum)
            
//            print(playerSum.firstIndex(of: sum) ?? 0)
//            print(sum)
//            flag = true
            
            
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        
//        let bodyA = contact.bodyA
//        let bodyB = contact.bodyB
//        
//        if (bodyA.categoryBitMask == 1 && bodyB.categoryBitMask == 2){
//            flag = false
//        }
        sounds.play("Hammer sound")
    }
    
//    func playHammerSound() {
//            // 1 - Create player
//            let url = Bundle.main.url(forResource: "hammerSound", withExtension: "mp3")!
//            let player = try! AVAudioPlayer(contentsOf: url)
//            
//            // 2 - Play sound
//            player.play()
//        }
    
    
    override func update(_ currentTime: CFTimeInterval) {
        // Called before each frame is rendered
    }
}
