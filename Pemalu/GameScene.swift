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
    var colorOverlays = [SKShapeNode]()
        var currentColorIndex = 0
    var animationFinished = false
        func createOverlay(withColor color: UIColor, rect: CGRect) -> SKShapeNode {
            let overlay = SKShapeNode(rect: rect)
            overlay.fillColor = color
            overlay.alpha = 0.0 // Start with alpha 0
            overlay.zPosition = 100 // Ensure it's above other nodes
            return overlay
        }
        
        func animateColorOverlay() {
            // Animate the overlay with the current color
            let currentOverlay = colorOverlays[currentColorIndex]
            let fadeInAction = SKAction.fadeAlpha(to: 0.5, duration: 0.5)
            let waitAction = SKAction.wait(forDuration: 1.0)
            let fadeOutAction = SKAction.fadeAlpha(to: 0.0, duration: 0.5)
            let sequence = SKAction.sequence([fadeInAction, waitAction, fadeOutAction])
            
            // Move to the next color overlay
            currentColorIndex = (currentColorIndex + 1) % colorOverlays.count
            
            // Run the animation and recursively call animateColorOverlay after completion
            currentOverlay.run(sequence) {
                if self.currentColorIndex == 0 {
                                               // Set animationFinished to true after completing one full cycle
                                               self.animationFinished = true
                                           } else {
                                               // Recursively call animateColorOverlay for the next color overlay
                                               self.animateColorOverlay()
                                           }
            }
        }
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
        manager.accelerometerUpdateInterval = 0.0025
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
//        guard let sceneFrame = self.view?.frame else { return }
            // Create red, yellow, and green rectangles
            let overlayRect = CGRect(x: -1000, y: -1000, width: 2000, height: 2000)
            let redOverlay = createOverlay(withColor: .red, rect: overlayRect)
            let yellowOverlay = createOverlay(withColor: .yellow, rect: overlayRect)
            let greenOverlay = createOverlay(withColor: .green, rect: overlayRect)
            
            // Add overlays to the scene
            colorOverlays.append(redOverlay)
            colorOverlays.append(yellowOverlay)
            colorOverlays.append(greenOverlay)
            self.addChild(redOverlay)
            self.addChild(yellowOverlay)
            self.addChild(greenOverlay)
            
            // Start the animation
            animateColorOverlay()
        
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
