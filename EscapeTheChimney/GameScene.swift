//
//  GameScene.swift
//  EscapeTheChimney
//
//  Created by Vincenzo D'Ambrosio on 05/12/22.
//

import SpriteKit
import GameplayKit

//Stati del tocco
enum TouchState {
    case Left
    case Right
    case None
}
//Stati di salto
enum JumpState {
    case Jump
    case Landing
    case None
}
//Dichiarare categorie di collisione ( in binario )
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
    
    //Dichiarazione telecamera
    let cam = SKCameraNode()
    
    //Dichiarare sprite qui
    
    var platformNames = ["platform1", "platform2", "platform3", "platform4"]
    var santa = SKSpriteNode(imageNamed: "santa")
    
    
    //Dichiarare variabili gameplay qui
    var movespeed: Int = 5
    var touchLocation: TouchState = .None
    var jumpState: JumpState = .None
    
    //Chiamata alla creazione della GameScene
    override func didMove(to view: SKView) {
    
        camera = cam //Assegnazione telecamera
        physicsWorld.contactDelegate = self  //Gestore delle collisioni
        
        //Creazione di Nabbo Batale
        makeSanta()
    }
    //Chiamata quando tocchi lo schermo
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
    //Chiamata quando tocchi muovi il dito sullo schermo
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
    //Chiamata quando finisci di toccare lo schermo
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchLocation = .None
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    //Chiamata prima di ogni frame renderizzato
    override func update(_ currentTime: TimeInterval) {
        //Aggiornamento telecamera
        cam.setScale(CGFloat(1))
        cam.position.y = santa.position.y + 500
        cam.position.x = 0
        
        // print(character.physicsBody?.velocity) // Usare per misure velocità personaggio
        switch (touchLocation) {
        case .Left:
            santa.physicsBody?.applyImpulse(CGVector(dx: -movespeed, dy: 0))
        case .Right:
            santa.physicsBody?.applyImpulse(CGVector(dx: movespeed, dy: 0))
        case .None:
            break
        }
        
        switch (jumpState) {
        case .Jump:
            santa.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 100))
            jumpState = .None
            makePlatform()
        case .Landing:
            break
        case .None:
            break
        }
    }
    
    func santaDeath() {
        santa.removeFromParent()
    }
    
    //Funzione attiva su ogni contatto tra oggetti
    func didBegin(_ contact: SKPhysicsContact) {
            let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask //Prende contatto di oggetto A e B
                if collision == PhysicsCategory.Santa | PhysicsCategory.Cookie {
                  //  cookieGet()
                }
        //Contatto tra babbo e fuoco = Morte
        if collision == PhysicsCategory.Santa | PhysicsCategory.Fire {
            print("Contact between santa and fire")
                    santaDeath()
                }
        //Contatto tra babbo e piattaforma = Salto
        if collision == PhysicsCategory.Santa | PhysicsCategory.Spring {
            print("Contact between santa and spring")
            jumpState = .Jump
                }
            }
    //Regolatore velocità
    override func didSimulatePhysics() {
        let yVelocity : CGFloat? = santa.physicsBody?.velocity.dy
        if ((santa.physicsBody?.velocity.dx)! > 500.00) {
            santa.physicsBody?.velocity = CGVectorMake(500, yVelocity!);
         }
        
        if ((santa.physicsBody?.velocity.dx)! < -500.00) {
            santa.physicsBody?.velocity = CGVectorMake(-500, yVelocity!);
         }
    }
    
    //ENTITY LIST
    
    //Propietà di Babbo Natale
    func makeSanta(){
        
        santa.position = CGPoint(x:0, y:-400)
        santa.physicsBody = SKPhysicsBody(rectangleOf: santa.size)
        santa.physicsBody?.isDynamic = true
        santa.physicsBody?.allowsRotation = false
        santa.physicsBody?.affectedByGravity = true
        santa.physicsBody?.friction = 1
        santa.physicsBody?.restitution = 0
        santa.physicsBody?.mass = 0.1
        santa.physicsBody?.categoryBitMask = PhysicsCategory.Santa
        addChild(santa)
        
    }
    
    //Proprietà delle piattaforme
    func makePlatform(){
        
        let platform = SKSpriteNode(imageNamed: platformNames.randomElement()!)
        platform.physicsBody = SKPhysicsBody(rectangleOf: platform.size)
        platform.physicsBody?.isDynamic = false
        platform.physicsBody?.allowsRotation = false
        platform.physicsBody?.affectedByGravity = false
        platform.physicsBody?.categoryBitMask = PhysicsCategory.Wall
        platform.position = CGPoint(x: 0, y: santa.position.y+200)
        print("Platform generated at \(platform.position)") //Test per posizione di generazione piattaforme
        addChild(platform)
        makeSpring(position: platform.position)
    }
    
    func makeSpring(position: CGPoint) -> SKNode{
        let spring = SKSpriteNode(imageNamed: "SpringPH")
        spring.position = CGPoint(x: position.x, y: position.y+20)
        spring.physicsBody?.isDynamic = false
        spring.physicsBody?.allowsRotation = false
        spring.physicsBody?.affectedByGravity = false
        spring.physicsBody?.categoryBitMask = PhysicsCategory.Spring
        print("Spring generated at \(spring.position)") //Test per posizione di generazione molle
        addChild(spring)
        return spring
    }
}
