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
    static let Background: UInt32 = 0b111 // 7
    static let DeleteBox: UInt32 = 0b1000 // 8
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    //Dichiarazione canzone
    let canzone = SKAction.playSoundFileNamed("SantaEscapeTheme", waitForCompletion: false)
    
    //Dichiarazione telecamera
    let cam = SKCameraNode()

    //Dichiarare sprite entità qui
    var killzone = SKSpriteNode(imageNamed: "SpringPH")
    var fire = SKSpriteNode(imageNamed: "fuoco1")
    var highscoreLabel = SKLabelNode()
    var santa = SKSpriteNode(imageNamed: "santa")
    var platformGroup = [SKNode]()
    var platformNames = ["platform1", "platform2", "platform3", "platform4"]
    var backgroundGroup = [SKNode]()
    var backgroundNames = ["wallUR1", "wallUR2", "wallUR3", "wallVR1", "wallR1" ,"wallR2" ,"wallR3" ,"wallR4" ,"wallR5" ,"wall1C" ,"wall2C" ,"wallN1" ,"wallN1" ,"wallN1" ,"wallN1" ,"wallN1" ,"wall5C" ,"wall3C", "wall4C","wallR6" ,"wallR7" ,"wallR8" ,"wallR9" ,"wallR10" , "wallVR2", "wallVR3", "wallUR4", "wallUR5"]
    var soundNode = SKNode()
    private var santaAtlas: SKTextureAtlas {
        return SKTextureAtlas(named: "Player")
    }
    
    private var santaIdleTextures: [SKTexture] {
        return [
            santaAtlas.textureNamed("idle_1"),
            santaAtlas.textureNamed("idle_2"),
            santaAtlas.textureNamed("idle_3"),
            santaAtlas.textureNamed("idle_2")
        ]
    }
    
    //Distribuzione randomica asse x
    var randomPos = GKRandomDistribution(lowestValue: -320, highestValue: 320)
    
    //Distribuzione gaussiana per background
    var randomBackground = GKGaussianDistribution(randomSource: GKRandomSource(), lowestValue: 0, highestValue: 26)
    
    //Dichiarare variabili gameplay qui
    var movespeed: Int = 3
    var touchLocation: TouchState = .None
    var jumpState: JumpState = .None
    var highest = 0 //Funzione highscore
    var killzoneHeight = -1000 //Altezza killzone
    
    //Chiamata alla creazione della GameScene
    override func didMove(to view: SKView) {
        
        camera = cam //Assegnazione telecamera
        
        physicsWorld.contactDelegate = self  //Gestore delle collisioni
        
        //Creazione di Nabbo Batale
        makeSanta()
        //Creazione di piattaforme iniziali
        for _ in 1...10 {
            makePlatform()
        }
        //Creazione background iniziale
        for _ in 1...10 {
            makeBackground()
        }
        //Creazione highscoreLabel
        highscoreCreation()
        //Creazione killzone
        killzoneCreation()
        
        //play canzone
        playSound(sound: canzone)
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
        //Aggiornamento highscore
        highscoreUpdate()
        //Aggiornamento killzone
        killzoneUpdate()
        //Aggiornamento telecamera
        cam.setScale(CGFloat(0.95))
        cam.position.y = CGFloat(highest) - 200
        cam.position.x = 5
        
        //Condizione per far passare babbo attraverso le piattaforme da sotto ma non da sopra
        if((santa.physicsBody?.velocity.dy)!>1){
            santa.physicsBody?.collisionBitMask = 0
            santa.physicsBody?.categoryBitMask = 0
        }
        else
        {
            santa.physicsBody?.collisionBitMask = PhysicsCategory.Santa
            santa.physicsBody?.categoryBitMask = PhysicsCategory.Santa
        }
        
        //Switch per direzione asse X
        // print(character.physicsBody?.velocity) // Usare per misure velocità personaggio
        switch (touchLocation) {
        case .Left:
            santa.physicsBody?.applyImpulse(CGVector(dx: -movespeed, dy: 0))
        case .Right:
            santa.physicsBody?.applyImpulse(CGVector(dx: movespeed, dy: 0))
        case .None:
            let yVelocity : CGFloat? = santa.physicsBody?.velocity.dy
            santa.physicsBody?.velocity = CGVectorMake(0, yVelocity!)
        }
        
        //Switch per direzione asse Y (salto)
        switch (jumpState) {
        case .Jump:
            santa.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 100))
            jumpState = .None
            makePlatform()
            makeBackground()
            makeBackground()
        case .Landing:
            break
        case .None:
            break
        }
    }
    //Funzione morte di babbo
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
        let xVelocity : CGFloat? = santa.physicsBody?.velocity.dx
        if ((santa.physicsBody?.velocity.dy)! > 1000.00) {
            santa.physicsBody?.velocity = CGVectorMake(xVelocity!, 1000);
         }
        if ((santa.physicsBody?.velocity.dy)! < -1000.00) {
            santa.physicsBody?.velocity = CGVectorMake(xVelocity!, -1000);
        }
    }
    
    func playSound(sound : SKAction){
        run(sound)
    }
}

