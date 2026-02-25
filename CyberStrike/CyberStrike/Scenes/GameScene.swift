import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // MARK: - Game Objects
    var player: PlayerHelicopter!
    var cameraNode: SKCameraNode!
    var cameraController: CameraController!
    var inputManager: InputManager!
    var hud: HUD!
    var levelGenerator: LevelGenerator!
    var particleEffects: ParticleEffects!
    
    // MARK: - Game State
    var gameState: GameState = .playing
    var lastUpdateTime: TimeInterval = 0
    var enemies: [Enemy] = []
    var projectiles: [Projectile] = []
    var powerUps: [SKNode] = []
    
    // MARK: - World
    var worldNode: SKNode!
    var backgroundNode: SKNode!
    var parallaxNodes: [SKNode] = []
    
    // MARK: - Scene Setup
    override func didMove(to view: SKView) {
        setupPhysics()
        setupWorld()
        setupBackground()
        setupPlayer()
        setupCamera()
        setupInput()
        setupHUD()
        setupLevelGenerator()
        setupParticleEffects()
        
        // Spawn initial enemies for testing
        spawnTestEnemies()
    }
    
    // MARK: - Setup Methods
    private func setupPhysics() {
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
    }
    
    private func setupWorld() {
        worldNode = SKNode()
        worldNode.name = "world"
        addChild(worldNode)
    }
    
    private func setupBackground() {
        backgroundNode = SKNode()
        backgroundNode.name = "background"
        worldNode.addChild(backgroundNode)
        
        // Create parallax layers
        for i in 0..<GameConstants.Level.parallaxLayers {
            let parallaxNode = SKNode()
            parallaxNode.name = "parallax_\(i)"
            parallaxNode.zPosition = GameConstants.ZPosition.parallaxBack + CGFloat(i) * 10
            backgroundNode.addChild(parallaxNode)
            parallaxNodes.append(parallaxNode)
        }
        
        // Add grid pattern to ground
        let gridNode = SKShapeNode(rectOf: CGSize(width: 5000, height: 5000))
        gridNode.fillColor = GameConstants.Visuals.darkBackground
        gridNode.strokeColor = SKColor(red: 0.1, green: 0.1, blue: 0.2, alpha: 1)
        gridNode.lineWidth = 2
        gridNode.zPosition = GameConstants.ZPosition.background
        
        // Create grid pattern
        let gridPath = CGMutablePath()
        for i in -25...25 {
            let offset = CGFloat(i) * 100
            gridPath.move(to: CGPoint(x: offset, y: -2500))
            gridPath.addLine(to: CGPoint(x: offset, y: 2500))
            gridPath.move(to: CGPoint(x: -2500, y: offset))
            gridPath.addLine(to: CGPoint(x: 2500, y: offset))
        }
        gridNode.path = gridPath
        backgroundNode.addChild(gridNode)
    }
    
    private func setupPlayer() {
        player = PlayerHelicopter()
        player.position = CGPoint(x: 0, y: 0)
        worldNode.addChild(player)
    }
    
    private func setupCamera() {
        cameraNode = SKCameraNode()
        camera = cameraNode
        addChild(cameraNode)
        
        cameraController = CameraController(camera: cameraNode, target: player)
    }
    
    private func setupInput() {
        inputManager = InputManager(scene: self)
    }
    
    private func setupHUD() {
        hud = HUD(scene: self)
        cameraNode.addChild(hud)
    }
    
    private func setupLevelGenerator() {
        levelGenerator = LevelGenerator(worldNode: worldNode)
        levelGenerator.generateInitialLevel()
    }
    
    private func setupParticleEffects() {
        particleEffects = ParticleEffects()
    }
    
    // MARK: - Update Loop
    override func update(_ currentTime: TimeInterval) {
        guard gameState == .playing else { return }
        
        let deltaTime = min(currentTime - lastUpdateTime, 1.0 / 30.0)
        lastUpdateTime = currentTime
        
        // Update all systems
        inputManager.update(deltaTime: deltaTime)
        player.update(deltaTime: deltaTime, input: inputManager)
        cameraController.update(deltaTime: deltaTime)
        levelGenerator.update(playerPosition: player.position)
        
        // Update enemies
        for enemy in enemies {
            enemy.update(deltaTime: deltaTime, playerPosition: player.position)
        }
        
        // Update projectiles
        for projectile in projectiles {
            projectile.update(deltaTime: deltaTime)
        }
        
        // Update HUD
        hud.update(player: player)
        
        // Update parallax backgrounds
        updateParallax()
        
        // Clean up off-screen entities
        cleanupOffScreenEntities()
    }
    
    private func updateParallax() {
        let cameraPos = cameraNode.position
        
        for (index, parallaxNode) in parallaxNodes.enumerated() {
            let factor = CGFloat(index + 1) * 0.1
            parallaxNode.position = CGPoint(
                x: -cameraPos.x * factor,
                y: -cameraPos.y * factor
            )
        }
    }
    
    private func cleanupOffScreenEntities() {
        let cleanupDistance: CGFloat = 1500
        let cameraPos = cameraNode.position
        
        // Remove off-screen projectiles
        projectiles.removeAll { projectile in
            let distance = hypot(projectile.position.x - cameraPos.x, projectile.position.y - cameraPos.y)
            if distance > cleanupDistance {
                projectile.removeFromParent()
                return true
            }
            return false
        }
    }
    
    // MARK: - Enemy Spawning
    func spawnTestEnemies() {
        // Spawn some test enemies around the player
        for i in 0..<5 {
            let angle = CGFloat(i) * (.pi * 2 / 5)
            let distance: CGFloat = 400
            let position = CGPoint(
                x: cos(angle) * distance,
                y: sin(angle) * distance
            )
            
            let enemyType: EnemyType = i % 2 == 0 ? .tank : .chopper
            spawnEnemy(type: enemyType, at: position)
        }
    }
    
    func spawnEnemy(type: EnemyType, at position: CGPoint) {
        let enemy = Enemy(type: type)
        enemy.position = position
        worldNode.addChild(enemy)
        enemies.append(enemy)
    }
    
    // MARK: - Projectile Management
    func spawnProjectile(from position: CGPoint, direction: CGVector, type: WeaponType, isPlayer: Bool) {
        let projectile = Projectile(type: type, position: position, direction: direction, isPlayer: isPlayer)
        worldNode.addChild(projectile)
        projectiles.append(projectile)
        
        // Add muzzle flash effect
        particleEffects.createMuzzleFlash(at: position, in: worldNode)
    }
    
    // MARK: - Collision Handling
    func didBegin(_ contact: SKPhysicsContact) {
        let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        // Player projectile hits enemy
        if collision == GameConstants.PhysicsCategory.projectile | GameConstants.PhysicsCategory.enemy {
            handleProjectileEnemyCollision(contact: contact)
        }
        
        // Enemy projectile hits player
        if collision == GameConstants.PhysicsCategory.enemyProjectile | GameConstants.PhysicsCategory.player {
            handleEnemyProjectilePlayerCollision(contact: contact)
        }
        
        // Player collides with enemy
        if collision == GameConstants.PhysicsCategory.player | GameConstants.PhysicsCategory.enemy {
            handlePlayerEnemyCollision(contact: contact)
        }
        
        // Player collects power-up
        if collision == GameConstants.PhysicsCategory.player | GameConstants.PhysicsCategory.powerUp {
            handlePowerUpCollection(contact: contact)
        }
        
        // Projectile hits building
        if collision == GameConstants.PhysicsCategory.projectile | GameConstants.PhysicsCategory.building {
            handleProjectileBuildingCollision(contact: contact)
        }
    }
    
    private func handleProjectileEnemyCollision(contact: SKPhysicsContact) {
        var projectileBody: SKPhysicsBody?
        var enemyBody: SKPhysicsBody?
        
        if contact.bodyA.categoryBitMask == GameConstants.PhysicsCategory.projectile {
            projectileBody = contact.bodyA
            enemyBody = contact.bodyB
        } else {
            projectileBody = contact.bodyB
            enemyBody = contact.bodyA
        }
        
        guard let projectileNode = projectileBody?.node as? Projectile,
              let enemyNode = enemyBody?.node as? Enemy else { return }
        
        // Apply damage
        enemyNode.takeDamage(projectileNode.damage)
        
        // Create explosion effect
        particleEffects.createExplosion(at: contact.contactPoint, size: .small, in: worldNode)
        
        // Remove projectile
        projectileNode.removeFromParent()
        projectiles.removeAll { $0 == projectileNode }
        
        // Check if enemy destroyed
        if enemyNode.isDestroyed {
            enemyDestroyed(enemy: enemyNode)
        }
    }
    
    private func handleEnemyProjectilePlayerCollision(contact: SKPhysicsContact) {
        var projectileBody: SKPhysicsBody?
        
        if contact.bodyA.categoryBitMask == GameConstants.PhysicsCategory.enemyProjectile {
            projectileBody = contact.bodyA
        } else {
            projectileBody = contact.bodyB
        }
        
        guard let projectileNode = projectileBody?.node as? Projectile else { return }
        
        player.takeDamage(projectileNode.damage)
        
        // Screen shake effect
        cameraController.shake(duration: 0.2, intensity: 5)
        
        // Create hit effect
        particleEffects.createSpark(at: contact.contactPoint, in: worldNode)
        
        projectileNode.removeFromParent()
        projectiles.removeAll { $0 == projectileNode }
    }
    
    private func handlePlayerEnemyCollision(contact: SKPhysicsContact) {
        var enemyBody: SKPhysicsBody?
        
        if contact.bodyA.categoryBitMask == GameConstants.PhysicsCategory.enemy {
            enemyBody = contact.bodyA
        } else {
            enemyBody = contact.bodyB
        }
        
        guard let enemyNode = enemyBody?.node as? Enemy else { return }
        
        player.takeDamage(20)
        enemyNode.takeDamage(50)
        
        cameraController.shake(duration: 0.3, intensity: 10)
        particleEffects.createExplosion(at: contact.contactPoint, size: .medium, in: worldNode)
        
        if enemyNode.isDestroyed {
            enemyDestroyed(enemy: enemyNode)
        }
    }
    
    private func handlePowerUpCollection(contact: SKPhysicsContact) {
        var powerUpBody: SKPhysicsBody?
        
        if contact.bodyA.categoryBitMask == GameConstants.PhysicsCategory.powerUp {
            powerUpBody = contact.bodyA
        } else {
            powerUpBody = contact.bodyB
        }
        
        guard let powerUpNode = powerUpBody?.node else { return }
        
        // Apply power-up effect
        if let powerUp = powerUpNode as? PowerUp {
            player.applyPowerUp(powerUp.type)
        }
        
        powerUpNode.removeFromParent()
    }
    
    private func handleProjectileBuildingCollision(contact: SKPhysicsContact) {
        var projectileBody: SKPhysicsBody?
        
        if contact.bodyA.categoryBitMask == GameConstants.PhysicsCategory.projectile {
            projectileBody = contact.bodyA
        } else {
            projectileBody = contact.bodyB
        }
        
        guard let projectileNode = projectileBody?.node as? Projectile else { return }
        
        particleEffects.createSpark(at: contact.contactPoint, in: worldNode)
        
        projectileNode.removeFromParent()
        projectiles.removeAll { $0 == projectileNode }
    }
    
    private func enemyDestroyed(enemy: Enemy) {
        // Create explosion
        particleEffects.createExplosion(at: enemy.position, size: .large, in: worldNode)
        
        // Screen shake
        cameraController.shake(duration: 0.15, intensity: 3)
        
        // Remove enemy
        enemy.removeFromParent()
        enemies.removeAll { $0 == enemy }
        
        // Chance to drop power-up
        if Double.random(in: 0...1) < 0.3 {
            spawnPowerUp(at: enemy.position)
        }
    }
    
    private func spawnPowerUp(at position: CGPoint) {
        let types: [PowerUpType] = [.health, .armor, .fuel, .energy, .ammo]
        let type = types.randomElement()!
        
        let powerUp = PowerUp(type: type)
        powerUp.position = position
        worldNode.addChild(powerUp)
        powerUps.append(powerUp)
    }
    
    // MARK: - Game State Management
    func pauseGame() {
        gameState = .paused
        isPaused = true
        hud.showPauseMenu()
    }
    
    func resumeGame() {
        gameState = .playing
        isPaused = false
        hud.hidePauseMenu()
    }
    
    func gameOver() {
        gameState = .gameOver
        hud.showGameOver()
    }
    
    // MARK: - Touch Handling (delegated to InputManager)
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        inputManager.touchesBegan(touches, with: event)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        inputManager.touchesMoved(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        inputManager.touchesEnded(touches, with: event)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        inputManager.touchesCancelled(touches, with: event)
    }
}
