//
//  GameOverScene.swift
//  JumpGameTest
//
//  Created by Eleonora Ballarini on 12/12/22.
//

import SpriteKit
import AVFoundation

class GameOverScene: SKScene {
    
    let background = SKSpriteNode(imageNamed: "GameOverScreen")
    let gameOver = SKSpriteNode(imageNamed: "GameOver")
    var songPlayer : AVAudioPlayer?
    
    override func didMove(to view: SKView) {
        
        let ostPath = Bundle.main.path(forResource: "GameOverSong.mp3", ofType:nil)!
        let ostUrl = URL(fileURLWithPath: ostPath)
        songPlayer = try! AVAudioPlayer(contentsOf: ostUrl)
        songPlayer?.setVolume(0.1, fadeDuration: 0)
        songPlayer?.play()
        
        background.position = CGPoint(x: size.width / 2 , y: size.height / 2)
        addChild(background)
        
        gameOver.position = CGPoint(x: size.width / 2, y: size.height / 2)
        gameOver.setScale(0.75)
        gameOver.zPosition = 5
        addChild(gameOver)
        
        let tapLabel = SKLabelNode()
        tapLabel.fontName = "Minecraft"
        tapLabel.zPosition = 5
        tapLabel.position = CGPoint(x: size.width / 2, y: size.height / 4)
        tapLabel.text = "Tap to Restart"
        tapLabel.fontSize = 50
        tapLabel.fontColor = .white
        addChild(tapLabel)
        
        let outAction = SKAction.fadeOut(withDuration: 0.5)
        let inAction = SKAction.fadeIn(withDuration: 0.5)
        let sequence = SKAction.sequence([outAction, inAction])
        
        tapLabel.run(SKAction.repeatForever(sequence))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
             let gameScene = GameScene(size: self.size)
             view?.presentScene(gameScene)
         }
    }
