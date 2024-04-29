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
        playerBody.isDynamic = true
        playerBody.affectedByGravity = true
        player.physicsBody = playerBody
        playerBody.categoryBitMask = 1
        playerBody.restitution = 0
        playerBody.friction = 0
//        print(player.attributeValues)
        let pinJoint = SKPhysicsJointPin.joint(withBodyA: anchoringPointBody, bodyB: playerBody, anchor: CGPoint(x: 221.561, y: 106.796))
        self.physicsWorld.add(pinJoint)
        
//        self.sounds.play("Hammer sound")
        
    }
    
    var playerSum = [Int]()
    var sum : Int = 0
    var flag : Bool = false
    
//    private var audioPlayer: AVAudioPlayer?
    var soundManager = Sounds()
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB
        var sumHit = sum
        
        if startMotionUpdates() && (bodyA.categoryBitMask == 1 && bodyB.categoryBitMask == 2){
            
            //EndScene

            playCustomHaptic()
            
            

            sum+=1
            if sum % 2 == 0{
                soundManager.playHammerSound(name: "hamSoundTrim")
                sumHit /= 2
                print(sumHit+1)
            }
            
        }
    }
    
//    func didEnd(_ contact: SKPhysicsContact) {
        
//        let bodyA = contact.bodyA
//        let bodyB = contact.bodyB
//        
//        if (bodyA.categoryBitMask == 1 && bodyB.categoryBitMask == 2){
//            flag = false
//        }
//        sounds.play("Hammer sound")
//    }
    
    
    override func update(_ currentTime: CFTimeInterval) {
        // Called before each frame is rendered
    }
}
