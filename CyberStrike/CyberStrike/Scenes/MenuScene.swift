import SpriteKit

class MenuScene: SKScene {
    
    // MARK: - UI Elements
    var titleLabel: SKLabelNode!
    var subtitleLabel: SKLabelNode!
    var playButton: SKShapeNode!
    var settingsButton: SKShapeNode!
    var playLabel: SKLabelNode!
    var settingsLabel: SKLabelNode!
    
    // MARK: - Background
    var backgroundGrid: SKShapeNode!
    var floatingParticles: [SKShapeNode] = []
    
    // MARK: - Scene Setup
    override func didMove(to view: SKView) {
        setupBackground()
        setupTitle()
        setupButtons()
        startAnimations()
    }
    
    // MARK: - Setup
    private func setupBackground() {
        backgroundColor = GameConstants.Visuals.darkBackground
        
        // Create animated grid background
        let gridNode = SKShapeNode()
        let gridPath = CGMutablePath()
        
        for i in -20...20 {
            let offset = CGFloat(i) * 50
            gridPath.move(to: CGPoint(x: offset, y: -1000))
            gridPath.addLine(to: CGPoint(x: offset, y: 1000))
            gridPath.move(to: CGPoint(x: -1000, y: offset))
            gridPath.addLine(to: CGPoint(x: 1000, y: offset))
        }
        
        gridNode.path = gridPath
        gridNode.strokeColor = SKColor(red: 0.1, green: 0.3, blue: 0.4, alpha: 0.3)
        gridNode.lineWidth = 1
        gridNode.zPosition = GameConstants.ZPosition.background
        addChild(gridNode)
        backgroundGrid = gridNode
        
        // Create floating particles
        for _ in 0..<20 {
            let particle = SKShapeNode(circleOfRadius: CGFloat.random(in: 2...5))
            particle.fillColor = GameConstants.Visuals.neonCyan
            particle.alpha = CGFloat.random(in: 0.2...0.6)
            particle.position = CGPoint(
                x: CGFloat.random(in: -400...400),
                y: CGFloat.random(in: -300...300)
            )
            particle.zPosition = GameConstants.ZPosition.background + 1
            addChild(particle)
            floatingParticles.append(particle)
        }
    }
    
    private func setupTitle() {
        // Main title
        titleLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        titleLabel.text = "CYBER STRIKE"
        titleLabel.fontSize = 48
        titleLabel.fontColor = GameConstants.Visuals.neonCyan
        titleLabel.position = CGPoint(x: 0, y: 100)
        titleLabel.zPosition = GameConstants.ZPosition.menu
        addChild(titleLabel)
        
        // Glow effect for title
        let glowNode = SKLabelNode(fontNamed: "AvenirNext-Bold")
        glowNode.text = "CYBER STRIKE"
        glowNode.fontSize = 48
        glowNode.fontColor = GameConstants.Visuals.neonCyan
        glowNode.alpha = 0.3
        glowNode.position = CGPoint(x: 0, y: 100)
        glowNode.zPosition = GameConstants.ZPosition.menu - 1
        addChild(glowNode)
        
        // Animate glow
        let pulseAction = SKAction.sequence([
            SKAction.fadeAlpha(to: 0.6, duration: 0.5),
            SKAction.fadeAlpha(to: 0.2, duration: 0.5)
        ])
        glowNode.run(SKAction.repeatForever(pulseAction))
        
        // Subtitle
        subtitleLabel = SKLabelNode(fontNamed: "AvenirNext-Regular")
        subtitleLabel.text = "Tactical Helicopter Combat"
        subtitleLabel.fontSize = 18
        subtitleLabel.fontColor = GameConstants.Visuals.neonPink
        subtitleLabel.position = CGPoint(x: 0, y: 60)
        subtitleLabel.zPosition = GameConstants.ZPosition.menu
        addChild(subtitleLabel)
    }
    
    private func setupButtons() {
        // Play button
        playButton = SKShapeNode(rectOf: CGSize(width: 200, height: 50), cornerRadius: 10)
        playButton.fillColor = SKColor.clear
        playButton.strokeColor = GameConstants.Visuals.neonGreen
        playButton.lineWidth = 2
        playButton.position = CGPoint(x: 0, y: -20)
        playButton.zPosition = GameConstants.ZPosition.menu
        playButton.name = "playButton"
        addChild(playButton)
        
        playLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        playLabel.text = "PLAY"
        playLabel.fontSize = 24
        playLabel.fontColor = GameConstants.Visuals.neonGreen
        playLabel.position = CGPoint(x: 0, y: -8)
        playLabel.zPosition = GameConstants.ZPosition.menu + 1
        playLabel.name = "playButton"
        addChild(playLabel)
        
        // Settings button
        settingsButton = SKShapeNode(rectOf: CGSize(width: 200, height: 50), cornerRadius: 10)
        settingsButton.fillColor = SKColor.clear
        settingsButton.strokeColor = GameConstants.Visuals.neonPurple
        settingsButton.lineWidth = 2
        settingsButton.position = CGPoint(x: 0, y: -90)
        settingsButton.zPosition = GameConstants.ZPosition.menu
        settingsButton.name = "settingsButton"
        addChild(settingsButton)
        
        settingsLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        settingsLabel.text = "SETTINGS"
        settingsLabel.fontSize = 24
        settingsLabel.fontColor = GameConstants.Visuals.neonPurple
        settingsLabel.position = CGPoint(x: 0, y: -88)
        settingsLabel.zPosition = GameConstants.ZPosition.menu + 1
        settingsLabel.name = "settingsButton"
        addChild(settingsLabel)
    }
    
    private func startAnimations() {
        // Animate floating particles
        for particle in floatingParticles {
            let moveAction = SKAction.moveBy(x: 0, y: 50, duration: 3)
            moveAction.timingMode = .easeInEaseOut
            let fadeAction = SKAction.sequence([
                SKAction.fadeAlpha(to: 0.1, duration: 1.5),
                SKAction.fadeAlpha(to: 0.5, duration: 1.5)
            ])
            
            particle.run(SKAction.repeatForever(moveAction))
            particle.run(SKAction.repeatForever(fadeAction))
        }
        
        // Animate grid
        let rotateAction = SKAction.rotate(byAngle: 0.02, duration: 10)
        backgroundGrid.run(SKAction.repeatForever(rotateAction))
    }
    
    // MARK: - Touch Handling
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let nodesAtPoint = nodes(at: location)
        
        for node in nodesAtPoint {
            if node.name == "playButton" {
                buttonTapped(playButton, label: playLabel)
                startGame()
            } else if node.name == "settingsButton" {
                buttonTapped(settingsButton, label: settingsLabel)
                showSettings()
            }
        }
    }
    
    private func buttonTapped(_ button: SKShapeNode, label: SKLabelNode) {
        let scaleDown = SKAction.scale(to: 0.95, duration: 0.05)
        let scaleUp = SKAction.scale(to: 1.0, duration: 0.05)
        button.run(SKAction.sequence([scaleDown, scaleUp]))
        label.run(SKAction.sequence([scaleDown, scaleUp]))
    }
    
    private func startGame() {
        let transition = SKTransition.fade(withDuration: 0.5)
        let gameScene = GameScene(size: size)
        gameScene.scaleMode = .aspectFill
        
        view?.presentScene(gameScene, transition: transition)
    }
    
    private func showSettings() {
        // TODO: Implement settings screen
        print("Settings button tapped")
    }
    
    // MARK: - Update
    override func update(_ currentTime: TimeInterval) {
        // Animate title
        let pulse = sin(currentTime * 2) * 0.1 + 1.0
        titleLabel.setScale(CGFloat(pulse))
    }
}
