//
//  StartScene.swift
//  EscapeTheChimney
//
//  Created by Vincenzo D'Ambrosio on 15/12/22.
//

import SpriteKit
import AVFoundation

class StartScene: SKScene {
    
    let background = SKSpriteNode(imageNamed: "startScreenBKG")
    let button = SKSpriteNode(imageNamed: "startButton")
//    let gameTitle = SKSpriteNode(imageNamed: "gameTitle")
    var songPlayer : AVAudioPlayer?
    
    override func didMove(to view: SKView) {
        
        let ostPath = Bundle.main.path(forResource: "SantaEscapeTheme.mp3", ofType:nil)!
        let ostUrl = URL(fileURLWithPath: ostPath)
        songPlayer = try! AVAudioPlayer(contentsOf: ostUrl)
        songPlayer?.setVolume(0.1, fadeDuration: 0)
        songPlayer?.play()
        
        button.position = CGPoint(x: 27.5 , y: -550)
        button.zPosition = 100
        addChild(button)
        
        background.position = CGPoint(x: 0 , y: 0)
        background.zPosition = -10
        background.xScale = 0.995
        background.yScale = 0.975
        addChild(background)
//
//        gameTitle.position = CGPoint(x: 0, y: 0)
//        gameTitle.setScale(0.75)
//        gameTitle.zPosition = 5
//        addChild(gameTitle)
        
//        let tapLabel = SKLabelNode()
//        tapLabel.fontName = "Minecraft"
//        tapLabel.zPosition = 5
//        tapLabel.position = CGPoint(x: 0, y: -300)
//        tapLabel.text = "Tap to start"
//        tapLabel.fontSize = 50
//        tapLabel.fontColor = .white
//        addChild(tapLabel)
        
//        let outAction = SKAction.fadeOut(withDuration: 0.5)
//        let inAction = SKAction.fadeIn(withDuration: 0.5)
//        let sequence = SKAction.sequence([outAction, inAction])
        
//        tapLabel.run(SKAction.repeatForever(sequence))
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
             let gameScene = GameScene(size: self.size)
             view?.presentScene(gameScene)
         }
    }
