import SpriteKit

class HUD: SKNode {
    
    // MARK: - UI Components
    var healthBar: SKShapeNode!
    var healthFill: SKShapeNode!
    var armorBar: SKShapeNode!
    var armorFill: SKShapeNode!
    var fuelBar: SKShapeNode!
    var fuelFill: SKShapeNode!
    var energyBar: SKShapeNode!
    var energyFill: SKShapeNode!
    
    var weaponIcon: SKShapeNode!
    var ammoLabel: SKLabelNode!
    
    var minimap: SKShapeNode!
    var minimapPlayer: SKShapeNode!
    
    var scoreLabel: SKLabelNode!
    var waveLabel: SKLabelNode!
    
    // MARK: - Menu Components
    var pauseMenu: SKNode?
    var gameOverMenu: SKNode?
    
    // MARK: - Scene Reference
    weak var sceneRef: SKScene?
    
    // MARK: - Initialization
    init(scene: SKScene) {
        self.sceneRef = scene
        super.init()
        
        setupHealthBar()
        setupArmorBar()
        setupFuelBar()
        setupEnergyBar()
        setupWeaponDisplay()
        setupMinimap()
        setupScoreDisplay()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    private func setupHealthBar() {
        let x = -sceneRef!.size.width / 2 + 20
        let y = sceneRef!.size.height / 2 - 40
        
        // Background
        healthBar = SKShapeNode(rectOf: CGSize(width: 200, height: 16), cornerRadius: 4)
        healthBar.fillColor = SKColor(white: 0.2, alpha: 0.8)
        healthBar.strokeColor = GameConstants.Visuals.neonRed
        healthBar.lineWidth = 2
        healthBar.position = CGPoint(x: x + 100, y: y)
        healthBar.zPosition = GameConstants.ZPosition.hud
        addChild(healthBar)
        
        // Fill
        healthFill = SKShapeNode(rectOf: CGSize(width: 196, height: 12), cornerRadius: 2)
        healthFill.fillColor = GameConstants.Visuals.neonRed
        healthFill.strokeColor = SKColor.clear
        healthFill.position = CGPoint(x: -98, y: 0)
        healthFill.zPosition = GameConstants.ZPosition.hud + 1
        healthBar.addChild(healthFill)
        
        // Label
        let label = SKLabelNode(fontNamed: "AvenirNext-Bold")
        label.text = "HP"
        label.fontSize = 10
        label.fontColor = SKColor.white
        label.position = CGPoint(x: -110, y: -5)
        label.zPosition = GameConstants.ZPosition.hud + 2
        healthBar.addChild(label)
    }
    
    private func setupArmorBar() {
        let x = -sceneRef!.size.width / 2 + 20
        let y = sceneRef!.size.height / 2 - 65
        
        armorBar = SKShapeNode(rectOf: CGSize(width: 150, height: 12), cornerRadius: 3)
        armorBar.fillColor = SKColor(white: 0.2, alpha: 0.8)
        armorBar.strokeColor = GameConstants.Visuals.neonGreen
        armorBar.lineWidth = 1
        armorBar.position = CGPoint(x: x + 75, y: y)
        armorBar.zPosition = GameConstants.ZPosition.hud
        addChild(armorBar)
        
        armorFill = SKShapeNode(rectOf: CGSize(width: 146, height: 8), cornerRadius: 2)
        armorFill.fillColor = GameConstants.Visuals.neonGreen
        armorFill.strokeColor = SKColor.clear
        armorFill.position = CGPoint(x: -73, y: 0)
        armorFill.zPosition = GameConstants.ZPosition.hud + 1
        armorBar.addChild(armorFill)
        
        let label = SKLabelNode(fontNamed: "AvenirNext-Bold")
        label.text = "ARMOR"
        label.fontSize = 8
        label.fontColor = SKColor.white
        label.position = CGPoint(x: -85, y: -4)
        label.zPosition = GameConstants.ZPosition.hud + 2
        armorBar.addChild(label)
    }
    
    private func setupFuelBar() {
        let x = -sceneRef!.size.width / 2 + 20
        let y = sceneRef!.size.height / 2 - 85
        
        fuelBar = SKShapeNode(rectOf: CGSize(width: 150, height: 10), cornerRadius: 2)
        fuelBar.fillColor = SKColor(white: 0.2, alpha: 0.8)
        fuelBar.strokeColor = GameConstants.Visuals.neonYellow
        fuelBar.lineWidth = 1
        fuelBar.position = CGPoint(x: x + 75, y: y)
        fuelBar.zPosition = GameConstants.ZPosition.hud
        addChild(fuelBar)
        
        fuelFill = SKShapeNode(rectOf: CGSize(width: 146, height: 6), cornerRadius: 1)
        fuelFill.fillColor = GameConstants.Visuals.neonYellow
        fuelFill.strokeColor = SKColor.clear
        fuelFill.position = CGPoint(x: -73, y: 0)
        fuelFill.zPosition = GameConstants.ZPosition.hud + 1
        fuelBar.addChild(fuelFill)
        
        let label = SKLabelNode(fontNamed: "AvenirNext-Bold")
        label.text = "FUEL"
        label.fontSize = 7
        label.fontColor = SKColor.white
        label.position = CGPoint(x: -80, y: -3)
        label.zPosition = GameConstants.ZPosition.hud + 2
        fuelBar.addChild(label)
    }
    
    private func setupEnergyBar() {
        let x = -sceneRef!.size.width / 2 + 20
        let y = sceneRef!.size.height / 2 - 102
        
        energyBar = SKShapeNode(rectOf: CGSize(width: 150, height: 10), cornerRadius: 2)
        energyBar.fillColor = SKColor(white: 0.2, alpha: 0.8)
        energyBar.strokeColor = GameConstants.Visuals.neonCyan
        energyBar.lineWidth = 1
        energyBar.position = CGPoint(x: x + 75, y: y)
        energyBar.zPosition = GameConstants.ZPosition.hud
        addChild(energyBar)
        
        energyFill = SKShapeNode(rectOf: CGSize(width: 146, height: 6), cornerRadius: 1)
        energyFill.fillColor = GameConstants.Visuals.neonCyan
        energyFill.strokeColor = SKColor.clear
        energyFill.position = CGPoint(x: -73, y: 0)
        energyFill.zPosition = GameConstants.ZPosition.hud + 1
        energyBar.addChild(energyFill)
        
        let label = SKLabelNode(fontNamed: "AvenirNext-Bold")
        label.text = "NRG"
        label.fontSize = 7
        label.fontColor = SKColor.white
        label.position = CGPoint(x: -80, y: -3)
        label.zPosition = GameConstants.ZPosition.hud + 2
        energyBar.addChild(label)
    }
    
    private func setupWeaponDisplay() {
        let x = sceneRef!.size.width / 2 - 80
        let y = -sceneRef!.size.height / 2 + 60
        
        // Weapon icon background
        weaponIcon = SKShapeNode(rectOf: CGSize(width: 60, height: 40), cornerRadius: 5)
        weaponIcon.fillColor = SKColor(white: 0.2, alpha: 0.8)
        weaponIcon.strokeColor = GameConstants.Visuals.neonCyan
        weaponIcon.lineWidth = 2
        weaponIcon.position = CGPoint(x: x, y: y)
        weaponIcon.zPosition = GameConstants.ZPosition.hud
        addChild(weaponIcon)
        
        // Weapon name
        let weaponLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        weaponLabel.text = "MACHINE GUN"
        weaponLabel.fontSize = 10
        weaponLabel.fontColor = SKColor.white
        weaponLabel.position = CGPoint(x: 0, y: 8)
        weaponLabel.zPosition = GameConstants.ZPosition.hud + 1
        weaponLabel.name = "weaponLabel"
        weaponIcon.addChild(weaponLabel)
        
        // Ammo count
        ammoLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        ammoLabel.text = "∞"
        ammoLabel.fontSize = 14
        ammoLabel.fontColor = GameConstants.Visuals.neonYellow
        ammoLabel.position = CGPoint(x: 0, y: -8)
        ammoLabel.zPosition = GameConstants.ZPosition.hud + 1
        weaponIcon.addChild(ammoLabel)
    }
    
    private func setupMinimap() {
        let x = sceneRef!.size.width / 2 - 70
        let y = sceneRef!.size.height / 2 - 70
        
        // Minimap background
        minimap = SKShapeNode(circleOfRadius: 60)
        minimap.fillColor = SKColor(white: 0.1, alpha: 0.8)
        minimap.strokeColor = GameConstants.Visuals.neonCyan
        minimap.lineWidth = 2
        minimap.position = CGPoint(x: x, y: y)
        minimap.zPosition = GameConstants.ZPosition.hud
        addChild(minimap)
        
        // Grid lines
        for i in -2...2 {
            let hLine = SKShapeNode(rectOf: CGSize(width: 100, height: 0.5))
            hLine.fillColor = SKColor(white: 0.3, alpha: 0.5)
            hLine.position = CGPoint(x: 0, y: CGFloat(i) * 20)
            hLine.zPosition = GameConstants.ZPosition.hud + 1
            minimap.addChild(hLine)
            
            let vLine = SKShapeNode(rectOf: CGSize(width: 0.5, height: 100))
            vLine.fillColor = SKColor(white: 0.3, alpha: 0.5)
            vLine.position = CGPoint(x: CGFloat(i) * 20, y: 0)
            vLine.zPosition = GameConstants.ZPosition.hud + 1
            minimap.addChild(vLine)
        }
        
        // Player indicator
        minimapPlayer = SKShapeNode(circleOfRadius: 4)
        minimapPlayer.fillColor = GameConstants.Visuals.neonCyan
        minimapPlayer.zPosition = GameConstants.ZPosition.hud + 2
        minimap.addChild(minimapPlayer)
    }
    
    private func setupScoreDisplay() {
        let x = 0
        let y = sceneRef!.size.height / 2 - 30
        
        scoreLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        scoreLabel.text = "SCORE: 0"
        scoreLabel.fontSize = 16
        scoreLabel.fontColor = SKColor.white
        scoreLabel.position = CGPoint(x: x, y: y)
        scoreLabel.zPosition = GameConstants.ZPosition.hud
        addChild(scoreLabel)
        
        waveLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        waveLabel.text = "WAVE 1"
        waveLabel.fontSize = 12
        waveLabel.fontColor = GameConstants.Visuals.neonPink
        waveLabel.position = CGPoint(x: x, y: y - 20)
        waveLabel.zPosition = GameConstants.ZPosition.hud
        addChild(waveLabel)
    }
    
    // MARK: - Update
    func update(player: PlayerHelicopter) {
        // Update health bar
        let healthPercent = max(0, player.health / GameConstants.Player.maxHealth)
        healthFill.xScale = healthPercent
        
        // Update armor bar
        let armorPercent = max(0, player.armor / GameConstants.Player.maxArmor)
        armorFill.xScale = armorPercent
        
        // Update fuel bar
        let fuelPercent = max(0, player.fuel / GameConstants.Player.maxFuel)
        fuelFill.xScale = fuelPercent
        
        // Update energy bar
        let energyPercent = max(0, player.energy / GameConstants.Player.maxEnergy)
        energyFill.xScale = energyPercent
        
        // Update weapon display
        updateWeaponDisplay(weapon: player.currentWeapon)
    }
    
    private func updateWeaponDisplay(weapon: WeaponType) {
        var weaponName = ""
        var ammoText = ""
        
        switch weapon {
        case .machineGun:
            weaponName = "MACHINE GUN"
            ammoText = "∞"
            weaponIcon.strokeColor = GameConstants.Visuals.neonYellow
        case .missile:
            weaponName = "MISSILES"
            ammoText = "10"
            weaponIcon.strokeColor = GameConstants.Visuals.neonGreen
        case .laser:
            weaponName = "LASER"
            ammoText = "50"
            weaponIcon.strokeColor = GameConstants.Visuals.neonCyan
        }
        
        if let label = weaponIcon.childNode(withName: "weaponLabel") as? SKLabelNode {
            label.text = weaponName
        }
        ammoLabel.text = ammoText
    }
    
    // MARK: - Pause Menu
    func showPauseMenu() {
        guard pauseMenu == nil else { return }
        
        let menu = SKNode()
        menu.zPosition = GameConstants.ZPosition.menu
        
        // Background overlay
        let overlay = SKShapeNode(rectOf: CGSize(width: 1000, height: 1000))
        overlay.fillColor = SKColor(white: 0, alpha: 0.7)
        overlay.position = CGPoint(x: 0, y: 0)
        overlay.zPosition = -1
        menu.addChild(overlay)
        
        // Menu panel
        let panel = SKShapeNode(rectOf: CGSize(width: 300, height: 200), cornerRadius: 10)
        panel.fillColor = SKColor(white: 0.1, alpha: 0.95)
        panel.strokeColor = GameConstants.Visuals.neonCyan
        panel.lineWidth = 2
        panel.zPosition = 0
        menu.addChild(panel)
        
        // Title
        let title = SKLabelNode(fontNamed: "AvenirNext-Bold")
        title.text = "PAUSED"
        title.fontSize = 32
        title.fontColor = GameConstants.Visuals.neonCyan
        title.position = CGPoint(x: 0, y: 60)
        title.zPosition = 1
        menu.addChild(title)
        
        // Resume button
        let resumeButton = createButton(text: "RESUME", y: 0, color: GameConstants.Visuals.neonGreen)
        resumeButton.name = "resumeButton"
        menu.addChild(resumeButton)
        
        // Quit button
        let quitButton = createButton(text: "QUIT", y: -60, color: GameConstants.Visuals.neonRed)
        quitButton.name = "quitButton"
        menu.addChild(quitButton)
        
        addChild(menu)
        pauseMenu = menu
    }
    
    func hidePauseMenu() {
        pauseMenu?.removeFromParent()
        pauseMenu = nil
    }
    
    // MARK: - Game Over Menu
    func showGameOver() {
        guard gameOverMenu == nil else { return }
        
        let menu = SKNode()
        menu.zPosition = GameConstants.ZPosition.menu
        
        // Background overlay
        let overlay = SKShapeNode(rectOf: CGSize(width: 1000, height: 1000))
        overlay.fillColor = SKColor(white: 0, alpha: 0.8)
        overlay.position = CGPoint(x: 0, y: 0)
        overlay.zPosition = -1
        menu.addChild(overlay)
        
        // Menu panel
        let panel = SKShapeNode(rectOf: CGSize(width: 350, height: 250), cornerRadius: 10)
        panel.fillColor = SKColor(white: 0.1, alpha: 0.95)
        panel.strokeColor = GameConstants.Visuals.neonRed
        panel.lineWidth = 3
        panel.zPosition = 0
        menu.addChild(panel)
        
        // Title
        let title = SKLabelNode(fontNamed: "AvenirNext-Bold")
        title.text = "GAME OVER"
        title.fontSize = 36
        title.fontColor = GameConstants.Visuals.neonRed
        title.position = CGPoint(x: 0, y: 70)
        title.zPosition = 1
        menu.addChild(title)
        
        // Score
        let scoreText = SKLabelNode(fontNamed: "AvenirNext-Regular")
        scoreText.text = "Final Score: 0"
        scoreText.fontSize = 18
        scoreText.fontColor = SKColor.white
        scoreText.position = CGPoint(x: 0, y: 20)
        scoreText.zPosition = 1
        menu.addChild(scoreText)
        
        // Restart button
        let restartButton = createButton(text: "RESTART", y: -30, color: GameConstants.Visuals.neonGreen)
        restartButton.name = "restartButton"
        menu.addChild(restartButton)
        
        // Main menu button
        let menuButton = createButton(text: "MAIN MENU", y: -90, color: GameConstants.Visuals.neonCyan)
        menuButton.name = "menuButton"
        menu.addChild(menuButton)
        
        addChild(menu)
        gameOverMenu = menu
    }
    
    private func createButton(text: String, y: CGFloat, color: SKColor) -> SKNode {
        let button = SKNode()
        button.position = CGPoint(x: 0, y: y)
        
        let background = SKShapeNode(rectOf: CGSize(width: 180, height: 40), cornerRadius: 5)
        background.fillColor = SKColor.clear
        background.strokeColor = color
        background.lineWidth = 2
        background.zPosition = 0
        button.addChild(background)
        
        let label = SKLabelNode(fontNamed: "AvenirNext-Bold")
        label.text = text
        label.fontSize = 18
        label.fontColor = color
        label.position = CGPoint(x: 0, y: -6)
        label.zPosition = 1
        button.addChild(label)
        
        return button
    }
    
    // MARK: - Touch Handling
    func handleTouch(at location: CGPoint) -> String? {
        let nodes = nodes(at: location)
        
        for node in nodes {
            if let name = node.name {
                return name
            }
        }
        
        return nil
    }
}
