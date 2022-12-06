//
//  GameScene.swift
//  EscapeTheChimney
//
//  Created by Vincenzo D'Ambrosio on 05/12/22.
//

import SpriteKit
import GameplayKit

enum TouchState {
    case Left
    case Right
    case None
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var character = SKSpriteNode(imageNamed: "santa")
    var movespeed: Int = 5
    var touchLocation: TouchState = .None
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    override func didMove(to view: SKView) {
        //SantaCharacter
        character.setScale(1)
        character.position = CGPoint(x:0, y:0)
        character.physicsBody = SKPhysicsBody(rectangleOf: character.size)
        character.physicsBody?.isDynamic = true
        character.physicsBody?.allowsRotation = false
        character.physicsBody?.affectedByGravity = true
        character.physicsBody?.friction = 1
        character.physicsBody?.mass = 0.1
        addChild(character)
    }
    
    func touchDown(atPoint pos : CGPoint) {
    }
    
    func touchMoved(toPoint pos : CGPoint) {
    }
    
    func touchUp(atPoint pos : CGPoint) {
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch:AnyObject in touches {
            let location = touch.location(in: self)
            if location.x < CGRectGetMidX(self.frame) {
                touchLocation = .Left
            } else if location.x > CGRectGetMidX(self.frame) {
                touchLocation = .Right
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch:AnyObject in touches {
            let location = touch.location(in: self)
            if location.x < CGRectGetMidX(self.frame) {
                touchLocation = .Left
            } else if location.x > CGRectGetMidX(self.frame) {
                touchLocation = .Right
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchLocation = .None
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        // print(character.physicsBody?.velocity) // USE FOR DEBUG
        // Max speed regulator
        if ((character.physicsBody?.velocity.dx)! > 400.00) {
            character.physicsBody?.velocity = CGVectorMake(400, 0);
         }
        
        if ((character.physicsBody?.velocity.dx)! < -400.00) {
            character.physicsBody?.velocity = CGVectorMake(-400, 0);
         }
        
        // Called before each frame is rendered
        switch (touchLocation) {
        case .Left:
            character.physicsBody?.applyImpulse(CGVector(dx: -movespeed, dy: 0))
        case .Right:
            character.physicsBody?.applyImpulse(CGVector(dx: movespeed, dy: 0))
        case .None:
            break
        }
        
    }
    
}


