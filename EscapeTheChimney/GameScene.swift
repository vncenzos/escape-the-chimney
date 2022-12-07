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

enum JumpState {
    case Jump
    case Landing
    case None
}

struct PhysicsCategory {
    static let None: UInt32 = 0
    static let Wall: UInt32 = 0b1 // 1
    static let Santa: UInt32 = 0b10 // 2
    static let Fire: UInt32 = 0b11 // 3
    static let Cookie: UInt32 = 0b100 // 4
    static let Milk: UInt32 = 0b101 // 5
    static let Spring: UInt32 = 0b110 // 6
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var character = SKSpriteNode(imageNamed: "santa")
    var movespeed: Int = 5
    var touchLocation: TouchState = .None
    var jumpState: JumpState = .None
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        //SantaCharacter
        character.setScale(1)
        character.position = CGPoint(x:0, y:0)
        character.physicsBody = SKPhysicsBody(rectangleOf: character.size)
        character.physicsBody?.isDynamic = true
        character.physicsBody?.allowsRotation = false
        character.physicsBody?.affectedByGravity = true
        character.physicsBody?.friction = 1
        character.physicsBody?.restitution = 0
        character.physicsBody?.mass = 0.1
        character.physicsBody?.categoryBitMask = PhysicsCategory.Santa
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
        // Called before each frame is rendered
        // print(character.physicsBody?.velocity) // USE FOR DEBUG
        switch (touchLocation) {
        case .Left:
            character.physicsBody?.applyImpulse(CGVector(dx: -movespeed, dy: 0))
        case .Right:
            character.physicsBody?.applyImpulse(CGVector(dx: movespeed, dy: 0))
        case .None:
            break
        }
        
        switch (jumpState) {
        case .Jump:
            character.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 100))
            jumpState = .None
        case .Landing:
            break
        case .None:
            break
        }
    }
    
    func santaDeath() {
        character.removeFromParent()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
            let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
                if collision == PhysicsCategory.Santa | PhysicsCategory.Cookie {
                  //  cookieGet()
                }
        if collision == PhysicsCategory.Santa | PhysicsCategory.Fire {
            print("Contact between santa and fire")
                    santaDeath()
                }
        if collision == PhysicsCategory.Santa | PhysicsCategory.Spring {
            print("Contact between santa and spring")
            jumpState = .Jump
                }
            }
    // Max speed regulator
    override func didSimulatePhysics() {
        var yVelocity : CGFloat? = character.physicsBody?.velocity.dy
        if ((character.physicsBody?.velocity.dx)! > 500.00) {
            character.physicsBody?.velocity = CGVectorMake(500, yVelocity!);
         }
        
        if ((character.physicsBody?.velocity.dx)! < -500.00) {
            character.physicsBody?.velocity = CGVectorMake(-500, yVelocity!);
         }
    }
}


