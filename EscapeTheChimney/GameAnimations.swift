//
//  GameAnimations.swift
//  EscapeTheChimney
//
//  Created by Vincenzo D'Ambrosio on 13/12/22.
//

import SpriteKit

extension GameScene{
 //DICHIARARE ENTITA' ANIMATE QUI

    //DICHIARAZIONE ATLAS TEXTURE QUI
     var fireAtlas: SKTextureAtlas {
        return SKTextureAtlas(named: "fire")
    }
    var shadowAtlas: SKTextureAtlas {
       return SKTextureAtlas(named: "shadow")
   }
    var fireballAtlas: SKTextureAtlas {
       return SKTextureAtlas(named: "fireball")
   }
    var indicatorAtlas: SKTextureAtlas {
       return SKTextureAtlas(named: "indicator")
   }
    var biscuitAtlas: SKTextureAtlas{
        return SKTextureAtlas(named: "biscuit")
    }
    
    //DICHIARAZIONE TEXTURE BASE QUI
     var fireTexture: SKTexture {
        return fireAtlas.textureNamed("fire_1")
    }
    var shadowTexture: SKTexture {
       return shadowAtlas.textureNamed("shadow_1")
    }
    var fireballTexture: SKTexture {
       return fireballAtlas.textureNamed("fireball_1")
    }
    var indicatorTexture: SKTexture {
       return indicatorAtlas.textureNamed("indicator_1")
    }
    var biscuitTexture: SKTexture {
       return biscuitAtlas.textureNamed("biscuit_1")
    }
    
    //DICHIARAZIONE FRAME ANIMAZIONE QUI
     var fireTextures: [SKTexture] {
        return [
            fireAtlas.textureNamed("fire_1"),
            fireAtlas.textureNamed("fire_2"),
            fireAtlas.textureNamed("fire_3"),
            fireAtlas.textureNamed("fire_4"),
        ]
    }
    var shadowTextures: [SKTexture] {
       return [
           shadowAtlas.textureNamed("shadow_1"),
           shadowAtlas.textureNamed("shadow_2"),
           shadowAtlas.textureNamed("shadow_3"),
           shadowAtlas.textureNamed("shadow_4"),
       ]
   }
    var fireballTextures: [SKTexture] {
       return [
           fireballAtlas.textureNamed("fireball_1"),
           fireballAtlas.textureNamed("fireball_2"),
           fireballAtlas.textureNamed("fireball_3"),
           fireballAtlas.textureNamed("fireball_4"),
           fireballAtlas.textureNamed("fireball_5"),
           fireballAtlas.textureNamed("fireball_6")
       ]
   }
    var biscuitTextures: [SKTexture] {
       return [
           biscuitAtlas.textureNamed("biscuit_1"),
           biscuitAtlas.textureNamed("biscuit_2"),
           biscuitAtlas.textureNamed("biscuit_3"),
           biscuitAtlas.textureNamed("biscuit_4"),
           biscuitAtlas.textureNamed("biscuit_5"),
           biscuitAtlas.textureNamed("biscuit_6")
       ]
   }
    //DICHIARAZIONE START ANIMAZIONE
    
    
    func startFireAnimation() {
        let fireAnimation = SKAction.animate(with: fireTextures, timePerFrame: 0.1)
        fire.run(SKAction.repeatForever(fireAnimation), withKey: "fireAnimation")
    }
    func startShadowAnimation() {
        let shadowAnimation = SKAction.animate(with: shadowTextures, timePerFrame: 0.1)
        shadow.run(SKAction.repeatForever(shadowAnimation), withKey: "shadowAnimation")
    }
    func startFireballAnimation() {
        let fireballAnimation = SKAction.animate(with: fireballTextures, timePerFrame: 0.3)
        fireball.run(SKAction.repeat(fireballAnimation, count: 1))
    }
    func startBiscuitAnimation() {
        let biscuitAnimation = SKAction.animate(with: biscuitTextures, timePerFrame: 0.2)
        biscuit.run(SKAction.repeat(biscuitAnimation, count: 1))
    }
}

