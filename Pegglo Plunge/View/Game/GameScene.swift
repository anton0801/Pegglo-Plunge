//
//  GameScene.swift
//  Pegglo Plunge
//
//  Created by Anton on 28/2/24.
//

import Foundation
import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var game: GameViewModel = GameViewModel()
    
    override func didMove(to view: SKView) {
        game.setPhysicBody(to: self)
        game.setContactDelegate(to: self, delegate: self)
        game.createScene(scene: self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        game.addBallOrObstacle(touches, with: event, to: self)
    }
    
    override func update(_ currentTime: TimeInterval) {
        game.startNewGame(self)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        game.collissionBetweenObjects(contact, in: self)
    }
    
}
