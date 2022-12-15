//
//  GameScene.swift
//  EscapeTheChimney
//
//  Created by Vincenzo D'Ambrosio on 05/12/22.
//

import SpriteKit
import GameplayKit
import AVFoundation

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
    static let Player: UInt32 = 0b1 // 1
    static let Collidable: UInt32 = 0b10 // 2
    static let Intersecable: UInt32 = 0b11 // 3
    static let Cookie: UInt32 = 0b100 // 4
    static let Milk: UInt32 = 0b101 // 5
    static let Spring: UInt32 = 0b110 // 6
    static let Background: UInt32 = 0b111 // 7
    static let DeleteBox: UInt32 = 0b1000 // 8
    static let Intangible: UInt32 = 0b1001 // 9
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    //Dichiarazione telecamera
    let cam = SKCameraNode()
    
    //Dichiarazione canzone
    var songPlayer: AVAudioPlayer?
    
    //Dichiarazione suoni
    let jumpSound = SKAction.playSoundFileNamed("jumpSFX", waitForCompletion: false)
    let fireballSound = SKAction.playSoundFileNamed("fireballSound", waitForCompletion: false)
    let crunchSound = SKAction.playSoundFileNamed("crunchSound", waitForCompletion: false)
    
    
    //Dichiarare entità qui
    var bounds : [SKSpriteNode] = [SKSpriteNode(imageNamed: "SpringPH"), SKSpriteNode(imageNamed: "SpringPH")]
    var ground = SKSpriteNode(imageNamed: "platform_7")
    var killzone = SKSpriteNode(imageNamed: "SpringPH")
    var timeLabel = SKLabelNode()
    var highscoreLabel = SKLabelNode() //Label dello score salvato
    var scoreLabel = SKLabelNode() //Label dello score corrente
    var santa = SKSpriteNode(imageNamed: "santa")
    var platformGroup = [SKNode]()
    var platformNames = ["platform_1","platform_2","platform_3","platform_4","platform_5","platform_6","platform_7"]
    var backgroundGroup = [SKNode]()
    
    //Nodo per SFX
    var soundNode = SKNode()
    
    //Comando di salvataggio
    let defaults = UserDefaults.standard
    
    //Dichiarare entità animate qui
    var fire : SKSpriteNode!
    var shadow : SKSpriteNode!
    var fireball : SKSpriteNode!
    var indicator : SKSpriteNode!
    var biscuit : SKSpriteNode!
    
    //Variabile per il primo salto
    var firstJump = true
    //Distribuzione randomica asse x
    var randomPos = GKRandomDistribution(lowestValue: -260, highestValue: 260)
    var randomBackground = GKRandomDistribution(lowestValue: 0, highestValue: 6)
    //Dichiarare variabili gameplay qui
    var movespeed: Int = 3
    var touchLocation: TouchState = .None
    var jumpState: JumpState = .None
    var score = 0 //Punteggio
    var highscore = 0 //Punteggio più alto
    var biscuitCount = 0 //Conteggio biscotti
    var highest = 0 //Punto più alto della killzone
    var killzoneHeight = -1000 //Altezza killzone
    var updateTime: Double = 0
    var fireballTime: Double = 0
    
    //Chiamata alla creazione della GameScene
    override func didMove(to view: SKView) {
        
        //Play della canzone
        let ostPath = Bundle.main.path(forResource: "SantaEscapeTheme.mp3", ofType:nil)!
        let ostUrl = URL(fileURLWithPath: ostPath)
        songPlayer = try! AVAudioPlayer(contentsOf: ostUrl)
        songPlayer?.setVolume(0.15, fadeDuration: 0)
        songPlayer?.play()
        
        camera = cam //Assegnazione telecamera
        
        physicsWorld.contactDelegate = self  //Gestore delle collisioni
        
        //Creazione di Nabbo Batale
        makeSanta()
        //Creazione dei limiti di livello
        makeBounds()
        //Creazione della piattaforma base
        makeGround()
        //Creazione di piattaforme iniziali
        for _ in 1...10 {
            makePlatform()
        }
        //Creazione background iniziale
        for _ in 1...10 {
            makeBackground()
        }
        //Creazione scoreLabel
        scoreCreation()
        //Creazione highscoreLabel
        highscoreCreation()
        //Creazione killzone
        killzoneCreation()
    }
    
    //Chiamata quando tocchi lo schermo
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchLocation = .None
        for touch:AnyObject in touches {
            let location = touch.location(in: self)
            if location.x < 0 {
                touchLocation = .Left
                if(firstJump){ jumpState = .Jump }
            } else if location.x > 0 {
                touchLocation = .Right
                if(firstJump){ jumpState = .Jump }
            }
        }
    }
    //Chiamata quando tocchi muovi il dito sullo schermo
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchLocation = .None
        for touch:AnyObject in touches {
            let location = touch.location(in: self)
            if location.x < 0 {
                touchLocation = .Left
                if(firstJump){ jumpState = .Jump }
            } else if location.x > 0 {
                touchLocation = .Right
                if(firstJump){ jumpState = .Jump}
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
        if updateTime == 0 {
            updateTime = currentTime
        }
        if currentTime - updateTime > 6 {
            //Eseguire al timer
            createBiscuit()
            createIndicator()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.createFireball()
            }
            
                updateTime = currentTime
        }
        //Aggiornamento highscore
        highscoreUpdate()
        //Aggiornamento killzone
        killzoneUpdate()
        //Aggiornamento telecamera
        cam.setScale(CGFloat(0.95))
        cam.position.y = CGFloat(killzoneHeight) + 815
        cam.position.x = 0
        
        //Condizione per far passare babbo attraverso le piattaforme da sotto ma non da sopra
        
        if((santa.physicsBody?.velocity.dy)!>1){
            santa.physicsBody?.categoryBitMask = PhysicsCategory.Intangible
            santa.physicsBody?.contactTestBitMask = PhysicsCategory.Intersecable
            santa.physicsBody?.collisionBitMask = PhysicsCategory.Intangible
        }
        else
        {
            santa.physicsBody?.categoryBitMask = PhysicsCategory.Player
            santa.physicsBody?.contactTestBitMask = PhysicsCategory.Intersecable
            santa.physicsBody?.collisionBitMask = PhysicsCategory.Collidable
            
        }
        
        //Aggiornamento limiti di livello
        updateBounds()
        
        //Switch per direzione asse X
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
            playSound(sound: jumpSound)
            santa.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 120))
            firstJump = false
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
        songPlayer?.stop()
        soundNode.removeAllActions()
        santa.removeFromParent()
        gameOver()
    }
    
    //Funzione attiva su ogni contatto tra oggetti
    func didBegin(_ contact: SKPhysicsContact) {
        let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask//Prende contatto di oggetto A e B
        //Contatto tra babbo e fuoco = Morte
        if collision == PhysicsCategory.Player | PhysicsCategory.DeleteBox {
            santaDeath()
        }
        //Contatto tra babbo e piattaforma = Salto
        if collision == PhysicsCategory.Player | PhysicsCategory.Spring {
            jumpState = .Jump
        }
        //Contatto tra babbo e piattaforma = Salto
        if collision == PhysicsCategory.Player | PhysicsCategory.Cookie {
            biscuitCount+=1
            contact.bodyB.node?.removeFromParent()
            playSound(sound: crunchSound)
        }
        if collision == PhysicsCategory.Intangible | PhysicsCategory.Cookie {
            biscuitCount+=1
            contact.bodyB.node?.removeFromParent()
            playSound(sound: crunchSound)
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
        if ((santa.physicsBody?.velocity.dy)! > 900.00) {
            santa.physicsBody?.velocity = CGVectorMake(xVelocity!, 900);
        }
        if ((santa.physicsBody?.velocity.dy)! < -2000.00) {
            santa.physicsBody?.velocity = CGVectorMake(xVelocity!, -2000);
        }
    }
    
    
    //Funzione GameOver
    func gameOver() {
        let gameOverScene = GameOverScene(size: self.size)
        view?.presentScene(gameOverScene)
        
    }
}

