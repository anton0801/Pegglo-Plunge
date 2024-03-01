//
//  GameViewModel.swift
//  Pegglo Plunge
//
//  Created by Anton on 28/2/24.
//

import Foundation
import SpriteKit

class GameViewModel {
    
    // MARK: Properties
    var gameId: String = UUID().uuidString
    
    var scoreLabel: SKLabelNode!
    var progressGame: Scorable = ScoreGame(score: 0) {
        didSet {
            scoreLabel.text = "Score: \(progressGame.score)"
        }
    }
    
    var editLabel: SKLabelNode!
    var editingMode = false {
        didSet {
            if editingMode {
                editLabel.text = "Done"
            } else {
                editLabel.text = "Edit"
            }
        }
    }
    var amountBallLabel: SKLabelNode!
    var allBalls = 10 {
        didSet {
            amountBallLabel.text = "Balls: \(allBalls)"
        }
    }
    
    var winLabel: SKLabelNode!
    
    var closeBtn: SKSpriteNode!

    var currentObstaclle = 0
    var obstacles = [SKNode]()
    
     // MARK: - Actions methods
    func addBallOrObstacle(_ touches: Set<UITouch>, with event: UIEvent?, to scene: SKScene) {
        guard let touch = touches.first else { return }
        
        let location = touch.location(in: scene.self)
        let object = scene.nodes(at: location)
        
        guard !object.contains(closeBtn) else {
            NotificationCenter.default.post(name: Notification.Name("CLOSE_GAME"), object: nil)
            return
        }
        
        guard !object.contains(editLabel) else {
            editingMode.toggle()
            return
        }
        
        if editingMode {
            let obstacle = createObstacles(in: location)
            scene.addChild(obstacle)
            addSoundEffect(for: .put, to: scene)
        } else {
            if allBalls > 0 {
                if currentObstaclle >= 5 {
                    let ball = createBall(in: location)
                    scene.addChild(ball)
                    allBalls -= 1
                } else {
                    let labelOfObstacles = createLabel(at: CGPoint(x: UIScreen.main.bounds.width / 4, y: UIScreen.main.bounds.height / 2), text: "Put at leas 5 obstacles")
                    labelOfObstacles.zPosition = 10
                    scene.addChild(labelOfObstacles)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        labelOfObstacles.removeFromParent()
                    }
                }
            }
        }
        
    }
    
    // MARK: - Logic for win or lose
    func startNewGame(_ scene: SKScene) {
        guard let isWin = isWin() else { return }
        winLabel = createLabel(at: CGPoint(x: UIScreen.main.bounds.width / 4, y: UIScreen.main.bounds.height / 2), text: "")
    
        if isWin {
            winLabel.text = "You are win!"
            addSoundEffect(for: .win, to: scene)
            var currentPoints = UserDefaults.standard.integer(forKey: "score")
            // UserDefaults.standard.set(currentPoints + progressGame.score, forKey: "score")
            NotificationCenter.default.post(name: Notification.Name("WIN_ADD_POINTS"), object: nil, userInfo: ["data": progressGame.score, "gameId": gameId])
        } else {
            winLabel.text = "You lose! Try again"
            addSoundEffect(for: .lose, to: scene)
        }
        
        scene.addChild(winLabel)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            let newScene = GameScene()
            newScene.size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            newScene.scaleMode = .fill
            scene.view?.presentScene(newScene)
        }
    }
    
    private func isWin() -> Bool? {
        if obstacles.isEmpty && progressGame.score >= 10 {
            return true
        } else if allBalls == 0 {
            return false
        }
        
        return nil
    }
    
    
    // MARK: - Scene creation methods
    func createScene(scene: SKScene) {
        addBackground(to: scene)
        addBouncers(to: scene)
        addSlots(to: scene)
        addScoreLabel(in: scene)
        addAmountBallLabel(in: scene)
        addEditLabel(in: scene)
        addCloseGameBtn(in: scene)
    }
    
    private func addCloseGameBtn(in scene: SKScene) {
        closeBtn = SKSpriteNode(imageNamed: "close")
        closeBtn.size = CGSize(width: 80, height: 80)
        closeBtn.position = CGPoint(x: 80, y: UIScreen.main.bounds.size.height - 50)
        scene.addChild(closeBtn)
    }
    
    private func addBackground(to scene: SKScene) {
        let background = SKSpriteNode(imageNamed: UserDefaults.standard.string(forKey: "game_back") ?? "base_game_back")
        background.position = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
        background.blendMode = .replace
        background.zPosition = -1
        background.size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        addMusic(to: background, for: .back)
        scene.addChild(background)
    }
    
    private func createBall(in position: CGPoint) -> SKSpriteNode {
        let ball = SKSpriteNode(imageNamed: UserDefaults.standard.string(forKey: "game_ball") ?? "ball")
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2)
        ball.physicsBody?.contactTestBitMask = ball.physicsBody?.collisionBitMask ?? 1
        ball.physicsBody?.restitution = 0.4
        ball.position.x = position.x
        ball.position.y = UIScreen.main.bounds.height
        ball.size = CGSize(width: 32, height: 32)
        ball.name = Constants.ball
        return ball
    }
    
    private func createObstacles(in position: CGPoint) -> SKSpriteNode {
        let size = CGSize(width: Int.random(in: 16...128), height: 16)
        let color = UIColor(red: CGFloat(Int.random(in: 0...1)),
                            green: CGFloat(Int.random(in: 0...1)),
                            blue: CGFloat(Int.random(in: 0...1)), alpha: 1)
        let obstacle = SKSpriteNode(color: color, size: size)
        obstacle.zPosition = 1
        obstacle.zRotation = CGFloat.random(in: 0...3)
        obstacle.position = position
        obstacle.name = Constants.obstacle
        obstacle.physicsBody = SKPhysicsBody(rectangleOf: obstacle.size)
        obstacle.physicsBody?.isDynamic = false
        
        currentObstaclle += 1
        obstacles.append(obstacle)
        
        return obstacle
    }
    
    private func addSlots(to scene: SKScene) {
        makeSlot(to: scene, at: CGPoint(x: Int(UIScreen.main.bounds.width / 4) - 100, y: 0), isGood: true)
        makeSlot(to: scene, at: CGPoint(x: Int(UIScreen.main.bounds.width / 4) * 2 - 100, y: 0), isGood: false)
        makeSlot(to: scene, at: CGPoint(x: Int(UIScreen.main.bounds.width / 4) * 3 - 100, y: 0), isGood: true)
        makeSlot(to: scene, at: CGPoint(x: Int(UIScreen.main.bounds.width / 4) * 4 - 100, y: 0), isGood: false)
    }
    
    private func makeSlot(to scene: SKScene, at position: CGPoint, isGood: Bool) {
        var slotBase: SKSpriteNode
        var slotSource: SKSpriteNode
        
        if isGood {
            slotBase = SKSpriteNode(imageNamed: "slotGood")
            slotSource = SKSpriteNode(imageNamed: "slotGoodSource")
            slotBase.name = Constants.goodSlot
        } else {
            slotBase = SKSpriteNode(imageNamed: "slotBad")
            slotSource = SKSpriteNode(imageNamed: "slotBadSource")
            slotBase.name = Constants.badSlot
        }
        
        slotBase.position = position
        slotSource.position = position
        
        let spin = SKAction.rotate(byAngle: .pi, duration: 10)
        let spinForever = SKAction.repeatForever(spin)
        slotSource.run(spinForever)
        
        slotBase.physicsBody = SKPhysicsBody(rectangleOf: slotBase.size)
        slotBase.physicsBody?.isDynamic = false
        
        scene.addChild(slotBase)
        scene.addChild(slotSource)
    }
    
    private func addBouncers(to scene: SKScene) {
        for i in 0..<5 {
            makeBouncer(to: scene, at: CGPoint(x: Int(UIScreen.main.bounds.width / 4) * i, y: 0))
        }
    }
    
    private func makeBouncer(to scene: SKScene, at position: CGPoint) {
        let bouncer = SKSpriteNode(imageNamed: "bouncer")
        bouncer.position = position
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width / 2)
        bouncer.physicsBody?.isDynamic = false
        scene.addChild(bouncer)
    }
    
    // MARK: - Creating and adding labels
    private func addScoreLabel(in scene: SKScene) {
        scoreLabel = createLabel(at: CGPoint(x: UIScreen.main.bounds.size.width / 2 - 100, y: UIScreen.main.bounds.size.height - 60), text: "Score: 0")
        scene.addChild(scoreLabel)
    }
    
    private func addAmountBallLabel(in scene: SKScene) {
        amountBallLabel = createLabel(at: CGPoint(x: UIScreen.main.bounds.size.width / 2 + 170, y: UIScreen.main.bounds.size.height - 60), text: "Balls: \(allBalls)")
        scene.addChild(amountBallLabel)
    }
    
    private func addEditLabel(in scene: SKScene) {
        editLabel = createLabel(at: CGPoint(x: 160, y: UIScreen.main.bounds.size.height - 60), text: "Edit")
        scene.addChild(editLabel)
    }
    
    private func createLabel(at position: CGPoint, text: String) -> SKLabelNode {
        let newLabel = SKLabelNode(fontNamed: "Chalkduster")
        newLabel.text = text
        newLabel.horizontalAlignmentMode = .left
        newLabel.position = position
        return newLabel
    }
    
    // MARK: - Scene Setting Method
    func setPhysicBody(to scene: SKScene) {
        scene.physicsBody = SKPhysicsBody(edgeLoopFrom: scene.frame)
    }
    
    func setContactDelegate(to scene: SKScene, delegate: SKPhysicsContactDelegate) {
        scene.physicsWorld.contactDelegate = delegate
    }
    
    // MARK: - Collision's methods
    func collissionBetweenObjects(_ contact: SKPhysicsContact, in scene: SKScene) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        if nodeA.name == Constants.ball {
        } else if nodeB.name == Constants.ball {
            collissionBetween(ball: nodeB, object: nodeA, in: scene)
        }
    }
    
    private func collissionBetween(ball: SKNode, object: SKNode, in scene: SKScene) {
        if object.name == Constants.goodSlot {
            destroyBall(ball: ball, in: scene)
            progressGame.score += 1
            allBalls += 1
            addSoundEffect(for: .addScore, to: scene)
        } else if object.name == Constants.badSlot {
            destroyBall(ball: ball, in: scene)
            if progressGame.score > 0 {
                progressGame.score -= 1
            }
        }
        
        destroyObstacle(obstacle: object, in: scene)
    }
    
    private func destroyBall(ball: SKNode, in scene: SKScene) {
        if let fileParticles = SKEmitterNode(fileNamed: "Fire") {
            fileParticles.position.x = ball.position.x
            fileParticles.position.y = 0
            scene.addChild(fileParticles)
        }
        ball.removeFromParent()
        addSoundEffect(for: .fire, to: scene)
    }
    
    private func destroyObstacle(obstacle: SKNode, in scene: SKScene) {
        guard obstacle.name == Constants.obstacle else { return }
        
        if let obstacleIndex = obstacles.firstIndex(of: obstacle) {
            obstacles.remove(at: obstacleIndex)
        }
        
        progressGame.score += 1
        addSoundEffect(for: .addScore, to: scene)
        obstacle.removeFromParent()
    }
    
    // MARK: - Audio effects
    private func addMusic(to background: SKNode, for file: AudioNames) {
        if UserDefaults.standard.bool(forKey: "is_music_enabled") {
            let music = SKAudioNode(fileNamed: file.rawValue)
            background.addChild(music)
        }
    }
    
    private func addSoundEffect(for file: AudioNames, to scene: SKScene) {
        if UserDefaults.standard.bool(forKey: "is_sounds_enabled") {
            let soundAction = SKAction.playSoundFileNamed(file.rawValue, waitForCompletion: false)
            scene.run(soundAction)
        }
    }
    
}
