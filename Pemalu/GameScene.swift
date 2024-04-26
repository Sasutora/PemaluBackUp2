//
//  GameScene.swift
//  Pemalu
//
//  Created by Christian Aldrich Darrien on 25/04/24.
//

import SpriteKit
import GameplayKit
import CoreMotion

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let manager = CMMotionManager()
    var player = SKSpriteNode()
    var target = SKSpriteNode()
    
    override func didMove(to view: SKView) {
        
        self.physicsWorld.contactDelegate = self
        
        player = self.childNode(withName: "hammer") as! SKSpriteNode
        target = self.childNode(withName: "nail") as! SKSpriteNode
        
        manager.startAccelerometerUpdates()
        manager.accelerometerUpdateInterval = 0.1
        manager.startAccelerometerUpdates(to: OperationQueue.main){
            (data, error) in
            self.physicsWorld.gravity = CGVectorMake(CGFloat(-1*(data?.acceleration.y)!) * 10, CGFloat((data?.acceleration.x)!) * 10)
        }
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var bodyA = contact.bodyA
        var bodyB = contact.bodyB
        
        
        if bodyA.categoryBitMask == 1 && bodyB.categoryBitMask == 2 || bodyA.categoryBitMask == 2 && bodyB.categoryBitMask == 1{
            
            //EndScene
            print("paku kena")
            
        }
    }
    override func update(_ currentTime: CFTimeInterval) {
        // Called before each frame is rendered
    }
}
