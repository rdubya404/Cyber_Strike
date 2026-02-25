import SpriteKit

class PlayerHelicopter: SKNode {
    
    // MARK: - Visual Components
    var bodyNode: SKShapeNode!
    var rotorNode: SKShapeNode!
    var tailRotorNode: SKShapeNode!
    var engineGlow: SKShapeNode!
    var shadowNode: SKShapeNode!
    
    // MARK: - Physics
    var physicsBodyNode: SKNode!
    
    // MARK: - State
    var velocity: CGVector = .zero
    var rotation: CGFloat = 0
    var health: CGFloat = GameConstants.Player.maxHealth
    var armor: CGFloat = GameConstants.Player.maxArmor
    var fuel: CGFloat = GameConstants.Player.maxFuel
    var energy: CGFloat = GameConstants.Player.maxEnergy
    
    // MARK: - Weapons
    var currentWeapon: WeaponType = .machineGun
    var weaponSystem: WeaponSystem!
    var lastFireTime: TimeInterval = 0
    
    // MARK: - Status
    var isDestroyed: Bool = false
    var isInvulnerable: Bool = false
    
    // MARK: - Initialization
    override init() {
        super.init()
        setupVisuals()
        setupPhysics()
        setupWeapons()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupVisuals() {
        // Shadow
        shadowNode = SKShapeNode(ellipseOf: CGSize(width: 50, height: 30))
        shadowNode.fillColor = SKColor.black
        shadowNode.alpha = 0.3
        shadowNode.position = CGPoint(x: 10, y: -10)
        shadowNode.zPosition = GameConstants.ZPosition.shadows
        addChild(shadowNode)
        
        // Main body - futuristic cyberpunk helicopter shape
        bodyNode = SKShapeNode()
        let bodyPath = CGMutablePath()
        
        // Draw helicopter body (top-down view)
        bodyPath.move(to: CGPoint(x: 25, y: 0))      // Nose
        bodyPath.addLine(to: CGPoint(x: 10, y: 12))   // Right side front
        bodyPath.addLine(to: CGPoint(x: -15, y: 10))  // Right side mid
        bodyPath.addLine(to: CGPoint(x: -35, y: 15))  // Right tail boom
        bodyPath.addLine(to: CGPoint(x: -40, y: 8))   // Right tail fin
        bodyPath.addLine(to: CGPoint(x: -40, y: -8))  // Left tail fin
        bodyPath.addLine(to: CGPoint(x: -35, y: -15)) // Left tail boom
        bodyPath.addLine(to: CGPoint(x: -15, y: -10)) // Left side mid
        bodyPath.addLine(to: CGPoint(x: 10, y: -12))  // Left side front
        bodyPath.closeSubpath()
        
        bodyNode.path = bodyPath
        bodyNode.fillColor = SKColor(red: 0.15, green: 0.15, blue: 0.2, alpha: 1)
        bodyNode.strokeColor = GameConstants.Visuals.neonCyan
        bodyNode.lineWidth = 2
        bodyNode.zPosition = GameConstants.ZPosition.player
        addChild(bodyNode)
        
        // Cockpit
        let cockpit = SKShapeNode(ellipseOf: CGSize(width: 15, height: 10))
        cockpit.fillColor = SKColor(red: 0, green: 0.8, blue: 1, alpha: 0.6)
        cockpit.strokeColor = GameConstants.Visuals.neonCyan
        cockpit.lineWidth = 1
        cockpit.position = CGPoint(x: 5, y: 0)
        cockpit.zPosition = GameConstants.ZPosition.player + 1
        addChild(cockpit)
        
        // Main rotor
        rotorNode = SKShapeNode()
        let rotorPath = CGMutablePath()
        rotorPath.move(to: CGPoint(x: -30, y: 0))
        rotorPath.addLine(to: CGPoint(x: 30, y: 0))
        rotorPath.move(to: CGPoint(x: 0, y: -8))
        rotorPath.addLine(to: CGPoint(x: 0, y: 8))
        
        rotorNode.path = rotorPath
        rotorNode.strokeColor = SKColor(red: 0.3, green: 0.3, blue: 0.4, alpha: 0.8)
        rotorNode.lineWidth = 3
        rotorNode.position = CGPoint(x: 0, y: 0)
        rotorNode.zPosition = GameConstants.ZPosition.player + 2
        addChild(rotorNode)
        
        // Tail rotor
        tailRotorNode = SKShapeNode()
        let tailPath = CGMutablePath()
        tailPath.move(to: CGPoint(x: -38, y: -5))
        tailPath.addLine(to: CGPoint(x: -38, y: 5))
        
        tailRotorNode.path = tailPath
        tailRotorNode.strokeColor = SKColor(red: 0.3, green: 0.3, blue: 0.4, alpha: 0.8)
        tailRotorNode.lineWidth = 2
        tailRotorNode.zPosition = GameConstants.ZPosition.player + 2
        addChild(tailRotorNode)
        
        // Engine glow
        engineGlow = SKShapeNode(circleOfRadius: 8)
        engineGlow.fillColor = GameConstants.Visuals.neonCyan
        engineGlow.alpha = 0.3
        engineGlow.position = CGPoint(x: -10, y: 0)
        engineGlow.zPosition = GameConstants.ZPosition.player - 1
        addChild(engineGlow)
        
        // Engine lights
        for i in 0..<2 {
            let light = SKShapeNode(circleOfRadius: 3)
            light.fillColor = i == 0 ? GameConstants.Visuals.neonRed : GameConstants.Visuals.neonGreen
            light.position = CGPoint(x: -25, y: i == 0 ? 8 : -8)
            light.zPosition = GameConstants.ZPosition.player + 3
            addChild(light)
            
            // Blink animation for lights
            let blinkAction = SKAction.sequence([
                SKAction.fadeAlpha(to: 0.3, duration: 0.5),
                SKAction.fadeAlpha(to: 1.0, duration: 0.5)
            ])
            light.run(SKAction.repeatForever(blinkAction))
        }
        
        // Weapon hardpoints
        for x in [10, -5] {
            let hardpoint = SKShapeNode(rectOf: CGSize(width: 6, height: 4))
            hardpoint.fillColor = SKColor.darkGray
            hardpoint.strokeColor = GameConstants.Visuals.neonYellow
            hardpoint.lineWidth = 1
            hardpoint.position = CGPoint(x: CGFloat(x), y: 12)
            hardpoint.zPosition = GameConstants.ZPosition.player + 1
            addChild(hardpoint)
            
            let hardpoint2 = hardpoint.copy() as! SKShapeNode
            hardpoint2.position = CGPoint(x: CGFloat(x), y: -12)
            addChild(hardpoint2)
        }
    }
    
    private func setupPhysics() {
        let body = SKPhysicsBody(rectangleOf: CGSize(width: 60, height: 30))
        body.categoryBitMask = GameConstants.PhysicsCategory.player
        body.contactTestBitMask = GameConstants.PhysicsCategory.enemyProjectile | 
                                  GameConstants.PhysicsCategory.enemy | 
                                  GameConstants.PhysicsCategory.powerUp
        body.collisionBitMask = GameConstants.PhysicsCategory.building
        body.allowsRotation = false
        body.mass = 1.0
        body.linearDamping = 0.5
        body.angularDamping = 0.8
        self.physicsBody = body
    }
    
    private func setupWeapons() {
        weaponSystem = WeaponSystem()
    }
    
    // MARK: - Update
    func update(deltaTime: TimeInterval, input: InputManager) {
        guard !isDestroyed else { return }
        
        // Update physics-based movement
        updateMovement(deltaTime: deltaTime, input: input)
        
        // Update rotation to face aim direction
        updateRotation(input: input)
        
        // Update rotor animation
        updateRotors(deltaTime: deltaTime)
        
        // Update fuel
        updateFuel(deltaTime: deltaTime)
        
        // Handle firing
        updateFiring(deltaTime: deltaTime, input: input)
        
        // Update visual effects
        updateVisualEffects(deltaTime: deltaTime)
    }
    
    private func updateMovement(deltaTime: TimeInterval, input: InputManager) {
        // Apply acceleration based on movement input
        let moveInput = input.movementInput
        
        if moveInput != .zero {
            let acceleration = CGVector(
                dx: moveInput.dx * GameConstants.Player.acceleration * deltaTime,
                dy: moveInput.dy * GameConstants.Player.acceleration * deltaTime
            )
            
            velocity.dx += acceleration.dx
            velocity.dy += acceleration.dy
            
            // Clamp max speed
            let speed = hypot(velocity.dx, velocity.dy)
            if speed > GameConstants.Player.maxSpeed {
                let scale = GameConstants.Player.maxSpeed / speed
                velocity.dx *= scale
                velocity.dy *= scale
            }
        }
        
        // Apply friction
        velocity.dx *= GameConstants.Player.friction
        velocity.dy *= GameConstants.Player.friction
        
        // Stop if very slow
        if hypot(velocity.dx, velocity.dy) < 5 {
            velocity = .zero
        }
        
        // Apply velocity
        position.x += velocity.dx * deltaTime
        position.y += velocity.dy * deltaTime
        
        // Update physics body velocity for collision response
        physicsBody?.velocity = velocity
    }
    
    private func updateRotation(input: InputManager) {
        let aimInput = input.aimInput
        
        if aimInput != .zero {
            let targetRotation = atan2(aimInput.dy, aimInput.dx)
            
            // Smooth rotation
            let diff = targetRotation - rotation
            let normalizedDiff = atan2(sin(diff), cos(diff))
            
            rotation += normalizedDiff * GameConstants.Player.rotationSpeed * 0.1
            
            // Apply rotation to body
            bodyNode.zRotation = rotation
        }
    }
    
    private func updateRotors(deltaTime: TimeInterval) {
        // Spin main rotor
        let rotorSpeed: CGFloat = 30.0
        rotorNode.zRotation += rotorSpeed * deltaTime
        
        // Spin tail rotor
        tailRotorNode.zRotation += rotorSpeed * 1.5 * deltaTime
    }
    
    private func updateFuel(deltaTime: TimeInterval) {
        fuel -= GameConstants.Player.fuelConsumptionRate * deltaTime
        fuel = max(0, fuel)
        
        if fuel <= 0 {
            // Out of fuel - reduced mobility
            velocity.dx *= 0.95
            velocity.dy *= 0.95
        }
    }
    
    private func updateFiring(deltaTime: TimeInterval, input: InputManager) {
        guard input.isFiring else { return }
        
        let currentTime = CACurrentMediaTime()
        let fireRate = currentWeapon.fireRate
        
        if currentTime - lastFireTime >= fireRate {
            fireWeapon()
            lastFireTime = currentTime
        }
    }
    
    private func fireWeapon() {
        guard let scene = scene as? GameScene else { return }
        
        let fireDirection = CGVector(dx: cos(rotation), dy: sin(rotation))
        let firePosition = position + CGPoint(x: cos(rotation) * 30, y: sin(rotation) * 30)
        
        scene.spawnProjectile(
            from: firePosition,
            direction: fireDirection,
            type: currentWeapon,
            isPlayer: true
        )
        
        // Recoil effect
        velocity.dx -= fireDirection.dx * 20
        velocity.dy -= fireDirection.dy * 20
    }
    
    private func updateVisualEffects(deltaTime: TimeInterval) {
        // Pulse engine glow based on velocity
        let speed = hypot(velocity.dx, velocity.dy)
        let glowIntensity = 0.2 + (speed / GameConstants.Player.maxSpeed) * 0.4
        engineGlow.alpha = glowIntensity
        
        // Update shadow position based on height (simulated)
        shadowNode.position = CGPoint(x: 10 + velocity.dx * 0.02, y: -10 + velocity.dy * 0.02)
    }
    
    // MARK: - Damage & Health
    func takeDamage(_ amount: CGFloat) {
        guard !isInvulnerable && !isDestroyed else { return }
        
        // Armor absorbs damage first
        let armorAbsorption = min(armor, amount * 0.5)
        armor -= armorAbsorption
        
        let remainingDamage = amount - armorAbsorption
        health -= remainingDamage
        
        // Flash effect
        let flashAction = SKAction.sequence([
            SKAction.colorize(with: GameConstants.Visuals.neonRed, colorBlendFactor: 0.8, duration: 0.05),
            SKAction.colorize(withColorBlendFactor: 0, duration: 0.1)
        ])
        bodyNode.run(flashAction)
        
        // Brief invulnerability
        isInvulnerable = true
        run(SKAction.sequence([
            SKAction.wait(forDuration: 0.5),
            SKAction.run { [weak self] in self?.isInvulnerable = false }
        ]))
        
        if health <= 0 {
            destroy()
        }
    }
    
    func heal(_ amount: CGFloat) {
        health = min(health + amount, GameConstants.Player.maxHealth)
    }
    
    func addArmor(_ amount: CGFloat) {
        armor = min(armor + amount, GameConstants.Player.maxArmor)
    }
    
    func refuel(_ amount: CGFloat) {
        fuel = min(fuel + amount, GameConstants.Player.maxFuel)
    }
    
    func recharge(_ amount: CGFloat) {
        energy = min(energy + amount, GameConstants.Player.maxEnergy)
    }
    
    func applyPowerUp(_ type: PowerUpType) {
        switch type {
        case .health:
            heal(25)
        case .armor:
            addArmor(25)
        case .fuel:
            refuel(30)
        case .energy:
            recharge(30)
        case .ammo:
            // TODO: Add ammo system
            break
        case .weaponUpgrade:
            // TODO: Implement weapon upgrade
            break
        }
    }
    
    // MARK: - Destruction
    func destroy() {
        isDestroyed = true
        
        // Create explosion effect
        if let scene = scene {
            let explosion = SKShapeNode(circleOfRadius: 40)
            explosion.fillColor = GameConstants.Visuals.neonRed
            explosion.alpha = 0.8
            explosion.position = position
            explosion.zPosition = GameConstants.ZPosition.effects
            scene.addChild(explosion)
            
            let expandAction = SKAction.scale(to: 2.0, duration: 0.3)
            let fadeAction = SKAction.fadeOut(withDuration: 0.3)
            let group = SKAction.group([expandAction, fadeAction])
            
            explosion.run(group) {
                explosion.removeFromParent()
            }
        }
        
        // Notify game scene
        if let gameScene = scene as? GameScene {
            gameScene.gameOver()
        }
        
        removeFromParent()
    }
    
    // MARK: - Weapon Switching
    func switchWeapon(to type: WeaponType) {
        currentWeapon = type
    }
}
