//
//  GameEntities.swift
//  EscapeTheChimney
//
//  Created by Vincenzo D'Ambrosio on 12/12/22.
//

import SpriteKit
import GameplayKit

extension GameScene {
    //ENTITY LIST
    
    //Propietà di Babbo Natale
    func makeSanta(){
        
        santa.position = CGPoint(x:0, y:-625)
        santa.physicsBody = SKPhysicsBody(rectangleOf: santa.size)
        santa.zPosition = 20
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
        platform.setScale(2)
        platform.zPosition = 2
        platform.physicsBody = SKPhysicsBody(rectangleOf: platform.size)
        platform.physicsBody?.isDynamic = false
        platform.physicsBody?.allowsRotation = false
        platform.physicsBody?.affectedByGravity = false
        platform.physicsBody?.categoryBitMask = PhysicsCategory.Wall
        platform.physicsBody?.collisionBitMask = PhysicsCategory.Wall
        platform.physicsBody?.contactTestBitMask = PhysicsCategory.Wall
        let randomX = randomPos.nextInt()
        if platformGroup.isEmpty{
            platform.position = CGPoint(x: randomX , y: Int(santa.position.y+200))
        }
        else
        {
            platform.position = CGPoint(x: randomX , y: Int(platformGroup.last!.position.y+200))
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
        spring.alpha = 0
        spring.xScale = 6
        spring.physicsBody = SKPhysicsBody(rectangleOf: spring.size)
        spring.position = CGPoint(x: position.x, y: position.y+5)
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
        if backgroundGroup.isEmpty{
            background.position = CGPoint(x: 0, y:-900)
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
        
        let score = Int(santa.position.y)+625
        if(score > highest){
            highest = score
        }
        let labelHeight = cam.position.y + 700
        highscoreLabel.position = CGPoint(x: 0, y: labelHeight)
        highscoreLabel.text = "Score: "  + String(highest)
    }
    
    func killzoneCreation(){
        addChild(killzone)
        addChild(fire)
        fire.setScale(6)
        fire.zPosition = 30
        killzone.xScale = 100
        killzone.physicsBody = SKPhysicsBody(rectangleOf: killzone.size)
        killzone.alpha = 0
        killzone.physicsBody?.isDynamic = false
        killzone.physicsBody?.categoryBitMask = PhysicsCategory.Fire
        killzone.physicsBody?.collisionBitMask = PhysicsCategory.Fire
        killzone.physicsBody?.contactTestBitMask = PhysicsCategory.Fire
    }
    
    func killzoneUpdate(){
        let kzHeight = Int(santa.position.y)-400
        if(kzHeight > killzoneHeight){
            killzoneHeight = kzHeight
        }
        killzone.position = CGPoint(x: 0, y: killzoneHeight)
        fire.position = CGPoint(x: 0, y: killzoneHeight+400)
    }
}

