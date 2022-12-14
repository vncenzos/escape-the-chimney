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
        
        santa.position = CGPoint(x:0, y:-645)
        santa.physicsBody = SKPhysicsBody(rectangleOf: santa.size)
        santa.zPosition = 199
        santa.physicsBody?.isDynamic = true
        santa.physicsBody?.allowsRotation = false
        santa.physicsBody?.affectedByGravity = true
        santa.physicsBody?.friction = 1
        santa.physicsBody?.restitution = 0
        santa.physicsBody?.mass = 0.1
        santa.physicsBody?.categoryBitMask = PhysicsCategory.Player
        santa.physicsBody?.collisionBitMask = PhysicsCategory.Collidable
        santa.physicsBody?.contactTestBitMask = PhysicsCategory.Intersecable
        addChild(santa)
        
    }
    
    //Proprietà delle piattaforme
    func makePlatform() -> (){
        
        let platformName = platformNames.randomElement()
        let platformTexture = SKTexture(imageNamed: platformName!)
        let platform = SKSpriteNode(imageNamed: platformName!)
        platform.setScale(2)
        platform.zPosition = 150
        let randomX = randomPos.nextInt()
        if platformGroup.isEmpty{
            platform.position = CGPoint(x: randomX , y: Int(santa.position.y+200))
        }
        else{
            platform.position = CGPoint(x: randomX , y: Int(platformGroup.last!.position.y+200))
        }
        //print("Platform generated at \(platform.position)") //Test per posizione di generazione piattaforme
        addChild(platform)
        makeSpring(position: platform.position)
        platformGroup.append(platform)
        
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
        spring.physicsBody?.contactTestBitMask = PhysicsCategory.Player
        spring.physicsBody?.collisionBitMask = PhysicsCategory.Player
        //print("Spring generated at \(spring.position)") //Test per posizione di generazione molle
        addChild(spring)
        return spring
        
    }
    
    func makeBackground(){
        let randomElement = randomBackground.nextInt()
        let background = SKSpriteNode(imageNamed: "MuroDefinitivo")
  //      let background = SKSpriteNode(imageNamed: backgroundNames[randomElement])
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
        
        highscoreLabel.zPosition = 200
        highscoreLabel.verticalAlignmentMode = .center
        highscoreLabel.fontName = "Minecraft"
        highscoreLabel.setScale(2)
        addChild(highscoreLabel)
        
    }
    
    func highscoreUpdate(){
        
        let points = Int((Int(santa.position.y)+625)/10)+(biscuitCount*100)
        if(points > highest){
            highest = points
            score = points
        }
        let labelHeight = cam.position.y + 700
        highscoreLabel.position = CGPoint(x: 0, y: labelHeight)
        highscoreLabel.text = "Score: "  + String(score)
        
    }
    
    func killzoneCreation(){
        shadow = SKSpriteNode(texture: shadowTexture)
        fire = SKSpriteNode(texture: fireTexture)
        shadow.zPosition = 30
        fire.zPosition = 175
        killzone.xScale = 100
        killzone.physicsBody = SKPhysicsBody(rectangleOf: killzone.size)
        killzone.alpha = 0
        killzone.physicsBody?.isDynamic = false
        killzone.physicsBody?.categoryBitMask = PhysicsCategory.DeleteBox
        killzone.physicsBody?.collisionBitMask = PhysicsCategory.None
        killzone.physicsBody?.contactTestBitMask = PhysicsCategory.Player
        addChild(killzone)
        addChild(fire)
        addChild(shadow)
        
        startFireAnimation()
        startShadowAnimation()
        
    }
    
    func killzoneUpdate(){
        
        let kzHeight = Int(santa.position.y)-400
        if(kzHeight > killzoneHeight){
            killzoneHeight = kzHeight
        }
        killzone.position = CGPoint(x: 0, y: killzoneHeight)
        fire.position = CGPoint(x: 0, y: killzoneHeight+170)
        shadow.position = CGPoint(x:0, y: killzoneHeight+1475)
        
    }
    
    func makeGround(){
        
        ground.position = CGPoint(x: 0, y: santa.position.y-32)
        ground.zPosition = 5
        ground.setScale(2)
        ground.physicsBody = SKPhysicsBody(rectangleOf: ground.size)
        ground.physicsBody?.isDynamic = false
        ground.physicsBody?.allowsRotation = false
        ground.physicsBody?.affectedByGravity = false
        ground.physicsBody?.categoryBitMask = PhysicsCategory.Collidable
        addChild(ground)
        
    }
    
    func makeBounds(){
        
        bounds[0].position = CGPoint(x: -100, y: -645)
        bounds[0].zPosition = 90
        bounds[0].yScale = 50
        bounds[0].alpha = 0
        bounds[0].physicsBody = SKPhysicsBody(rectangleOf: bounds[0].size)
        bounds[0].physicsBody?.isDynamic = false
        bounds[0].physicsBody?.allowsRotation = false
        bounds[0].physicsBody?.affectedByGravity = false
        bounds[0].physicsBody?.contactTestBitMask = 0
        bounds[0].physicsBody?.collisionBitMask = 0
        bounds[0].physicsBody?.categoryBitMask = PhysicsCategory.Collidable
        addChild(bounds[0])
        bounds[1].position = CGPoint(x: -100, y: -645)
        bounds[1].zPosition = 90
        bounds[1].yScale = 50
        bounds[1].alpha = 0
        bounds[1].physicsBody = SKPhysicsBody(rectangleOf: bounds[1].size)
        bounds[1].physicsBody?.isDynamic = false
        bounds[1].physicsBody?.allowsRotation = false
        bounds[1].physicsBody?.affectedByGravity = false
        bounds[1].physicsBody?.contactTestBitMask = 0
        bounds[1].physicsBody?.collisionBitMask = 0
        bounds[1].physicsBody?.categoryBitMask = PhysicsCategory.Collidable
        addChild(bounds[1])
        
    }
    
    func updateBounds(){
        bounds[0].position = CGPoint(x: -300, y: santa.position.y)
        bounds[1].position = CGPoint(x: 300, y: santa.position.y)
        if((santa.physicsBody?.velocity.dy)!>1){
            bounds[0].physicsBody?.categoryBitMask = PhysicsCategory.Intersecable
            bounds[1].physicsBody?.categoryBitMask = PhysicsCategory.Intersecable
        }
        else{
            bounds[0].physicsBody?.categoryBitMask = PhysicsCategory.Collidable
            bounds[1].physicsBody?.categoryBitMask = PhysicsCategory.Collidable
        }

    }
    
    func createFireball(){
        fireball = SKSpriteNode(texture: fireballTexture)
        fireball.zPosition = 15
        fireball.setScale(0.75)
        fireball.position = CGPoint(x: indicator.position.x, y: killzone.position.y)
        fireball.physicsBody = SKPhysicsBody(circleOfRadius: 5)
        fireball.physicsBody?.affectedByGravity = true
        fireball.physicsBody?.allowsRotation = false
        fireball.physicsBody?.categoryBitMask = PhysicsCategory.DeleteBox
        fireball.physicsBody?.collisionBitMask = PhysicsCategory.None
        fireball.physicsBody?.contactTestBitMask = PhysicsCategory.Player
        addChild(fireball)
        fireball.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 7))
        startFireballAnimation()
        playSound(sound: fireballSound)
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
        self.fireball.removeFromParent()
        }
    }
    
    func createIndicator() {
        indicator = SKSpriteNode(texture: indicatorTexture)
        indicator.position = CGPoint(x: santa.position.x, y: santa.position.y+100)
        indicator.zPosition = 200
        indicator.setScale(1.5)
        addChild(indicator)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
        self.indicator.removeFromParent()
        }
    }
    
    func createBiscuit(){
        biscuit = SKSpriteNode(texture: biscuitTexture)
        biscuit.zPosition = 199
        biscuit.position = CGPoint(x: randomPos.nextInt(), y: Int(santa.position.y)+1500)
        biscuit.physicsBody = SKPhysicsBody(circleOfRadius: 10)
        biscuit.physicsBody?.affectedByGravity = true
        biscuit.physicsBody?.categoryBitMask = PhysicsCategory.Cookie
        biscuit.physicsBody?.collisionBitMask = PhysicsCategory.None
        biscuit.physicsBody?.contactTestBitMask = PhysicsCategory.Player
        addChild(biscuit)
        startBiscuitAnimation()
    }
}

