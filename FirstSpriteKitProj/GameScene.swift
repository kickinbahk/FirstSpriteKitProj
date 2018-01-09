//
//  GameScene.swift
//  FirstSpriteKitProj
//
//  Created by Josiah Mory on 1/2/18.
//  Copyright © 2018 kickinbahk Productions. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    let player = SKSpriteNode(imageNamed: "player")
    var scoreLabel: SKLabelNode!
    
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.white
        player.position = CGPoint(x: size.width * 0.1, y: size.height * 0.5)
        addChild(player)

        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: "
        scoreLabel.color = .black
        scoreLabel.fontSize = 20
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = CGPoint(x: 980, y: 700)
        
        addChild(scoreLabel)
        
        physicsWorld.gravity = CGVector.zero
        physicsWorld.contactDelegate = self
        
        run(SKAction.repeatForever(SKAction.sequence([SKAction.run(addMonster), SKAction.wait(forDuration: 1.0)])))
        

    }
    
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    func addMonster() {
        let monster = SKSpriteNode(imageNamed: "monster")
        
        monster.physicsBody = SKPhysicsBody(rectangleOf: monster.size)
        monster.physicsBody?.isDynamic = true
        monster.physicsBody?.categoryBitMask = PhysicsCategory.Monster
        monster.physicsBody?.contactTestBitMask = PhysicsCategory.Projectile
        monster.physicsBody?.collisionBitMask = PhysicsCategory.None
        
        let actualY = random(min: monster.size.height / 2, max: size.height - monster.size.height / 2)
        monster.position = CGPoint(x: size.width + monster.size.width / 2, y: actualY)
        
        addChild(monster)
        
        let actualDuration = random(min: CGFloat(2.0), max: CGFloat(4.0))
        
        let actionMove = SKAction.move(to: CGPoint(x: -monster.size.width / 2, y: actualY), duration: TimeInterval(actualDuration))
        let actionMoveDone = SKAction.removeFromParent()
        monster.run(SKAction.sequence([actionMove, actionMoveDone]))
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        let touchLocation = touch.location(in: self)
        
        let projectile = SKSpriteNode(imageNamed: "projectile")
        projectile.position = player.position

        projectile.physicsBody = SKPhysicsBody(circleOfRadius: projectile.size.width / 2)
        projectile.physicsBody?.isDynamic = true
        projectile.physicsBody?.categoryBitMask = PhysicsCategory.Projectile
        projectile.physicsBody?.contactTestBitMask = PhysicsCategory.Monster
        projectile.physicsBody?.collisionBitMask = PhysicsCategory.None
        projectile.physicsBody?.usesPreciseCollisionDetection = true
        
        let offset = touchLocation - projectile.position
        
        if (offset.x < 0) { return }
        
        let action = SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 0.5)
        projectile.run(SKAction.repeatForever(action))
        
        addChild(projectile)
        
        let direction = offset.normalized()
        let shootAmount = direction * 1000
        
        let realDest = shootAmount + projectile.position
        let actionMove = SKAction.move(to: realDest, duration: 2.0)
        let actionMoveDone = SKAction.removeFromParent()
        
        projectile.run(SKAction.sequence([actionMove, actionMoveDone]))
        
    }
    
    func projectileDidCollideWithMonster(projectile: SKSpriteNode, monster: SKSpriteNode) {
        print("Hit")
        projectile.removeFromParent()
        monster.removeFromParent()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if ((firstBody.categoryBitMask & PhysicsCategory.Monster != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.Projectile != 0)) {
            if let monster = firstBody.node as? SKSpriteNode,
               let projectile = secondBody.node as? SKSpriteNode {
                projectileDidCollideWithMonster(projectile: projectile, monster: monster)
            }
        }
    }
}
