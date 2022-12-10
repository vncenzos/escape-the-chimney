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
    
    //Dichiarazione telecamera
    let cam = SKCameraNode()

    //Dichiarare sprite qui
    
    var highscoreLabel = SKLabelNode()
    var santa = SKSpriteNode(imageNamed: "santa")
    var platformGroup = [SKNode]()
    var platformNames = ["platform1", "platform2", "platform3", "platform4"]
    var backgroundGroup = [SKNode]()
    var backgroundNames = ["wall2", "wall3", "wall4", "wall5", "wall6"]
    
    //Distribuzione randomica asse x
    var randomPos = GKRandomDistribution(lowestValue: -320, highestValue: 320)
    
    //Distribuzione gaussiana per background
    var randomBackground = GKGaussianDistribution(randomSource: GKRandomSource(), lowestValue: 0, highestValue: 4)
    
    //Dichiarare variabili gameplay qui
    var movespeed: Int = 5
    var touchLocation: TouchState = .None
    var jumpState: JumpState = .None
    var highest = 0 //Funzione highscore
    
    //Chiamata alla creazione della GameScene
    override func didMove(to view: SKView) {
        
        camera = cam //Assegnazione telecamera
        
        physicsWorld.contactDelegate = self  //Gestore delle collisioni
        
        //Creazione di Nabbo Batale
        makeSanta()
        //Creazione di piattaforme iniziali
        for _ in 1...5 {
            makePlatform()
        }
        //Creazione background iniziale
        for _ in 1...5 {
            makeBackground()
        }
        //Creazione highscoreLabe
        highscoreCreation()
        
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
        
        //Aggiornamento telecamera
        cam.setScale(CGFloat(0.95))
        cam.position.y = santa.position.y + 550
        cam.position.x = 0
        
        //Condizione per far passare babbo attraverso le piattaforme da sotto ma non da sopra
        if((santa.physicsBody?.velocity.dy)!>100){
            santa.physicsBody?.collisionBitMask = 0
        }
        else
        {
            santa.physicsBody?.collisionBitMask = PhysicsCategory.Santa
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
            santa.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 80))
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
    }
    
    //ENTITY LIST
    
    //Propietà di Babbo Natale
    func makeSanta(){
        
        santa.position = CGPoint(x:0, y:-625)
        santa.physicsBody = SKPhysicsBody(rectangleOf: santa.size)
        santa.zPosition = 100
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
    func makePlatform() -> (){
        
        let platform = SKSpriteNode(imageNamed: platformNames.randomElement()!)
        platform.zPosition = 2
        platform.physicsBody = SKPhysicsBody(rectangleOf: platform.size)
        platform.physicsBody?.isDynamic = false
        platform.physicsBody?.allowsRotation = false
        platform.physicsBody?.affectedByGravity = false
        platform.physicsBody?.categoryBitMask = PhysicsCategory.Wall
        platform.physicsBody?.collisionBitMask = 0
        let randomX = randomPos.nextInt()
        if platformGroup.isEmpty{
            platform.position = CGPoint(x: randomX , y: Int(santa.position.y+250))
        }
        else
        {
            platform.position = CGPoint(x: randomX , y: Int(platformGroup.last!.position.y+250))
        }
        //print("Platform generated at \(platform.position)") //Test per posizione di generazione piattaforme
        addChild(platform)
        makeSpring(position: platform.position)
        platformGroup.append(platform)
        //print(platformGroup.last) //Test per ultimo elemento di piattaforme
        
    }
    
    func makeSpring(position: CGPoint) -> SKNode{
        
        let spring = SKSpriteNode(imageNamed: "SpringPH")
        spring.zPosition = 3
        spring.physicsBody = SKPhysicsBody(rectangleOf: spring.size)
        spring.position = CGPoint(x: position.x, y: position.y+20)
        spring.physicsBody?.isDynamic = false
        spring.physicsBody?.allowsRotation = false
        spring.physicsBody?.affectedByGravity = false
        spring.physicsBody?.categoryBitMask = PhysicsCategory.Spring
        spring.physicsBody?.contactTestBitMask = PhysicsCategory.Spring
        //print("Spring generated at \(spring.position)") //Test per posizione di generazione molle
        addChild(spring)
        return spring
        
    }
    
    func makeBackground(){
        let randomElement = randomBackground.nextInt()
        let background = SKSpriteNode(imageNamed: backgroundNames[randomElement])
        background.zPosition = -10
        background.setScale(6)
        if backgroundGroup.isEmpty{
            background.position = CGPoint(x: 0, y:-768)
        }
        else{
            let lastpos = backgroundGroup.last?.position.y
            background.position = CGPoint(x: 0, y: lastpos!+192)
        }
        //print("Background generated at \(background.position)") //Test per posizione di background
        backgroundGroup.append(background)
        addChild(background)
        
    }
    
    func highscoreCreation(){
        
        highscoreLabel.zPosition = 10
        highscoreLabel.verticalAlignmentMode = .center
        highscoreLabel.fontName = "Minecraft"
        highscoreLabel.setScale(2)
        addChild(highscoreLabel)
        
    }
    
    func highscoreUpdate(){
        
        let height = Int(santa.position.y)+625
        if(height > highest){
            highest = height
        }
        let labelHeight = santa.position.y + 1240
        highscoreLabel.position = CGPoint(x: 0, y: labelHeight)
        highscoreLabel.text = "Score: "  + String(highest)
        
    }
}
