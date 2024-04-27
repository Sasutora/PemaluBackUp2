//
//  GameScene.swift
//  Pemalu
//
//  Created by Christian Aldrich Darrien on 25/04/24.
//

import SpriteKit
import GameplayKit
import CoreMotion
//import CoreHaptics


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let manager = CMMotionManager()
    var player = SKSpriteNode()
    var playerTexture = SKTexture(imageNamed: "hammer")
    var target = SKSpriteNode()
    var targetTexture = SKTexture(imageNamed: "nail")
    
    var anchoringPointNode = SKSpriteNode()
//    var anchoringPointTexture = SKTexture()
    
    
    
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
        manager.accelerometerUpdateInterval = 0.1
        manager.startAccelerometerUpdates(to: OperationQueue.main){
            (data, error) in
            self.physicsWorld.gravity = CGVectorMake(CGFloat(-1*(data?.acceleration.y)!) * 10, CGFloat((data?.acceleration.x)!) * 10)
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
//        print(player.attributeValues)
                    // Create a pin joint between anchoring point and hammer
        let pinJoint = SKPhysicsJointPin.joint(withBodyA: anchoringPointBody, bodyB: playerBody, anchor: CGPoint(x: 221.561, y: 106.796))
        self.physicsWorld.add(pinJoint)
        
        
        
    }
    
    var sum:Int = 0
    
    func didBegin(_ contact: SKPhysicsContact) {
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB
//        var sum:Int = 0
//        print("Testing")
//        || (bodyA.categoryBitMask == 2 && bodyB.categoryBitMask == 1
        if (bodyA.categoryBitMask == 1 && bodyB.categoryBitMask == 2){
            
            //EndScene
            playCustomHaptic()

            print(sum)
            sum+=1
            
        }
    }
    
    
    
    override func update(_ currentTime: CFTimeInterval) {
        // Called before each frame is rendered
    }
}
