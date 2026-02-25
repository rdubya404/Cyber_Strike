import SpriteKit

class Enemy: SKNode {
    
    // MARK: - Properties
    let enemyType: EnemyType
    var health: CGFloat
    var maxHealth: CGFloat
    var damage: CGFloat
    var speed: CGFloat
    var isDestroyed: Bool = false
    
    // MARK: - Visual Components
    var bodyNode: SKShapeNode!
    var turretNode: SKShapeNode?
    var shadowNode: SKShapeNode!
    
    // MARK: - AI State
    enum AIState {
        case idle
        case patrol
        case chase
        case attack
        case retreat
    }
    var currentState: AIState = .patrol
    var patrolCenter: CGPoint = .zero
    var patrolRadius: CGFloat = 200
    var detectionRange: CGFloat = 400
    var attackRange: CGFloat = 250
    var lastFireTime: TimeInterval = 0
    var fireRate: TimeInterval = 1.0
    
    // MARK: - Movement
    var velocity: CGVector = .zero
    var targetPosition: CGPoint?
    var rotation: CGFloat = 0
    
    // MARK: - Initialization
    init(type: EnemyType) {
        self.enemyType = type
        
        // Set stats based on type
        switch type {
        case .tank:
            health = GameConstants.Enemies.tankHealth
            damage = GameConstants.Enemies.tankDamage
            speed = GameConstants.Enemies.tankSpeed
            fireRate = 1.5
            detectionRange = 350
            attackRange = 300
        case .chopper:
            health = GameConstants.Enemies.chopperHealth
            damage = GameConstants.Enemies.chopperDamage
            speed = GameConstants.Enemies.chopperSpeed
            fireRate = 0.4
            detectionRange = 500
            attackRange = 350
        case .turret:
            health = GameConstants.Enemies.turretHealth
            damage = GameConstants.Enemies.turretDamage
            speed = 0
            fireRate = 0.8
            detectionRange = 450
            attackRange = 400
        case .drone:
            health = GameConstants.Enemies.droneHealth
            damage = GameConstants.Enemies.droneDamage
            speed = GameConstants.Enemies.droneSpeed
            fireRate = 0.2
            detectionRange = 400
            attackRange = 200
        }
        
        maxHealth = health
        super.init()
        
        setupVisuals()
        setupPhysics()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupVisuals() {
        // Shadow
        shadowNode = SKShapeNode(ellipseOf: CGSize(width: 40, height: 25))
        shadowNode.fillColor = SKColor.black
        shadowNode.alpha = 0.3
        shadowNode.position = CGPoint(x: 5, y: -5)
        shadowNode.zPosition = GameConstants.ZPosition.shadows
        addChild(shadowNode)
        
        switch enemyType {
        case .tank:
            setupTankVisuals()
        case .chopper:
            setupChopperVisuals()
        case .turret:
            setupTurretVisuals()
        case .drone:
            setupDroneVisuals()
        }
    }
    
    private func setupTankVisuals() {
        // Tank body
        bodyNode = SKShapeNode(rectOf: CGSize(width: 40, height: 30), cornerRadius: 5)
        bodyNode.fillColor = SKColor(red: 0.2, green: 0.25, blue: 0.15, alpha: 1)
        bodyNode.strokeColor = GameConstants.Visuals.neonGreen
        bodyNode.lineWidth = 2
        bodyNode.zPosition = GameConstants.ZPosition.enemies
        addChild(bodyNode)
        
        // Treads
        for y in [-18, 18] {
            let tread = SKShapeNode(rectOf: CGSize(width: 44, height: 8))
            tread.fillColor = SKColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1)
            tread.position = CGPoint(x: 0, y: y)
            tread.zPosition = GameConstants.ZPosition.enemies - 1
            addChild(tread)
        }
        
        // Turret
        turretNode = SKShapeNode()
        let turretPath = CGMutablePath()
        turretPath.addEllipse(in: CGRect(x: -10, y: -10, width: 20, height: 20))
        turretNode?.path = turretPath
        turretNode?.fillColor = SKColor(red: 0.3, green: 0.35, blue: 0.25, alpha: 1)
        turretNode?.strokeColor = GameConstants.Visuals.neonGreen
        turretNode?.lineWidth = 1
        turretNode?.zPosition = GameConstants.ZPosition.enemies + 1
        addChild(turretNode!)
        
        // Barrel
        let barrel = SKShapeNode(rectOf: CGSize(width: 25, height: 6))
        barrel.fillColor = SKColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        barrel.strokeColor = GameConstants.Visuals.neonGreen
        barrel.lineWidth = 1
        barrel.position = CGPoint(x: 12, y: 0)
        barrel.zPosition = GameConstants.ZPosition.enemies + 1
        turretNode?.addChild(barrel)
    }
    
    private func setupChopperVisuals() {
        // Enemy chopper body
        bodyNode = SKShapeNode()
        let bodyPath = CGMutablePath()
        bodyPath.move(to: CGPoint(x: 20, y: 0))
        bodyPath.addLine(to: CGPoint(x: 5, y: 10))
        bodyPath.addLine(to: CGPoint(x: -20, y: 8))
        bodyPath.addLine(to: CGPoint(x: -30, y: 12))
        bodyPath.addLine(to: CGPoint(x: -30, y: -12))
        bodyPath.addLine(to: CGPoint(x: -20, y: -8))
        bodyPath.addLine(to: CGPoint(x: 5, y: -10))
        bodyPath.closeSubpath()
        
        bodyNode.path = bodyPath
        bodyNode.fillColor = SKColor(red: 0.3, green: 0.15, blue: 0.15, alpha: 1)
        bodyNode.strokeColor = GameConstants.Visuals.neonRed
        bodyNode.lineWidth = 2
        bodyNode.zPosition = GameConstants.ZPosition.enemies
        addChild(bodyNode)
        
        // Rotor
        let rotor = SKShapeNode()
        let rotorPath = CGMutablePath()
        rotorPath.move(to: CGPoint(x: -25, y: 0))
        rotorPath.addLine(to: CGPoint(x: 15, y: 0))
        rotor.path = rotorPath
        rotor.strokeColor = SKColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 0.7)
        rotor.lineWidth = 2
        rotor.zPosition = GameConstants.ZPosition.enemies + 2
        addChild(rotor)
        
        // Animate rotor
        let spinAction = SKAction.rotate(byAngle: .pi * 2, duration: 0.1)
        rotor.run(SKAction.repeatForever(spinAction))
        
        // Red light
        let light = SKShapeNode(circleOfRadius: 3)
        light.fillColor = GameConstants.Visuals.neonRed
        light.position = CGPoint(x: -25, y: 8)
        light.zPosition = GameConstants.ZPosition.enemies + 3
        addChild(light)
        
        let blinkAction = SKAction.sequence([
            SKAction.fadeAlpha(to: 0.3, duration: 0.3),
            SKAction.fadeAlpha(to: 1.0, duration: 0.3)
        ])
        light.run(SKAction.repeatForever(blinkAction))
    }
    
    private func setupTurretVisuals() {
        // Turret base
        let base = SKShapeNode(rectOf: CGSize(width: 35, height: 35))
        base.fillColor = SKColor(red: 0.15, green: 0.15, blue: 0.2, alpha: 1)
        base.strokeColor = GameConstants.Visuals.neonPurple
        base.lineWidth = 2
        base.zPosition = GameConstants.ZPosition.enemies
        addChild(base)
        
        // Turret body
        bodyNode = SKShapeNode(circleOfRadius: 15)
        bodyNode.fillColor = SKColor(red: 0.25, green: 0.2, blue: 0.3, alpha: 1)
        bodyNode.strokeColor = GameConstants.Visuals.neonPurple
        bodyNode.lineWidth = 2
        bodyNode.zPosition = GameConstants.ZPosition.enemies + 1
        addChild(bodyNode)
        
        // Barrel
        turretNode = SKShapeNode(rectOf: CGSize(width: 30, height: 8))
        turretNode?.fillColor = SKColor(red: 0.3, green: 0.3, blue: 0.35, alpha: 1)
        turretNode?.strokeColor = GameConstants.Visuals.neonPurple
        turretNode?.lineWidth = 1
        turretNode?.position = CGPoint(x: 15, y: 0)
        turretNode?.zPosition = GameConstants.ZPosition.enemies + 2
        addChild(turretNode!)
        
        // Glowing core
        let core = SKShapeNode(circleOfRadius: 6)
        core.fillColor = GameConstants.Visuals.neonPurple
        core.alpha = 0.5
        core.zPosition = GameConstants.ZPosition.enemies + 2
        bodyNode.addChild(core)
        
        let pulseAction = SKAction.sequence([
            SKAction.fadeAlpha(to: 0.8, duration: 0.5),
            SKAction.fadeAlpha(to: 0.3, duration: 0.5)
        ])
        core.run(SKAction.repeatForever(pulseAction))
    }
    
    private func setupDroneVisuals() {
        // Drone body - small and fast
        bodyNode = SKShapeNode()
        let bodyPath = CGMutablePath()
        bodyPath.move(to: CGPoint(x: 10, y: 0))
        bodyPath.addLine(to: CGPoint(x: -5, y: 8))
        bodyPath.addLine(to: CGPoint(x: -10, y: 0))
        bodyPath.addLine(to: CGPoint(x: -5, y: -8))
        bodyPath.closeSubpath()
        
        bodyNode.path = bodyPath
        bodyNode.fillColor = SKColor(red: 0.2, green: 0.2, blue: 0.25, alpha: 1)
        bodyNode.strokeColor = GameConstants.Visuals.neonYellow
        bodyNode.lineWidth = 1
        bodyNode.zPosition = GameConstants.ZPosition.enemies
        addChild(bodyNode)
        
        // Propellers
        for angle in [0, .pi / 2, .pi, .pi * 1.5] {
            let prop = SKShapeNode(circleOfRadius: 4)
            prop.fillColor = SKColor.clear
            prop.strokeColor = SKColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 0.5)
            prop.lineWidth = 1
            prop.position = CGPoint(
                x: cos(angle) * 8,
                y: sin(angle) * 8
            )
            prop.zPosition = GameConstants.ZPosition.enemies + 1
            addChild(prop)
            
            let spinAction = SKAction.rotate(byAngle: .pi * 2, duration: 0.05)
            prop.run(SKAction.repeatForever(spinAction))
        }
        
        // Yellow light
        let light = SKShapeNode(circleOfRadius: 2)
        light.fillColor = GameConstants.Visuals.neonYellow
        light.position = CGPoint(x: 0, y: 0)
        light.zPosition = GameConstants.ZPosition.enemies + 2
        addChild(light)
    }
    
    private func setupPhysics() {
        var body: SKPhysicsBody
        
        switch enemyType {
        case .tank:
            body = SKPhysicsBody(rectangleOf: CGSize(width: 40, height: 30))
        case .chopper:
            body = SKPhysicsBody(circleOfRadius: 20)
        case .turret:
            body = SKPhysicsBody(circleOfRadius: 15)
        case .drone:
            body = SKPhysicsBody(circleOfRadius: 10)
        }
        
        body.categoryBitMask = GameConstants.PhysicsCategory.enemy
        body.contactTestBitMask = GameConstants.PhysicsCategory.projectile | 
                                  GameConstants.PhysicsCategory.player
        body.collisionBitMask = GameConstants.PhysicsCategory.building | 
                               GameConstants.PhysicsCategory.enemy
        body.allowsRotation = false
        body.mass = 0.5
        
        self.physicsBody = body
    }
    
    // MARK: - Update
    func update(deltaTime: TimeInterval, playerPosition: CGPoint) {
        guard !isDestroyed else { return }
        
        // AI State Machine
        updateAI(deltaTime: deltaTime, playerPosition: playerPosition)
        
        // Update movement
        updateMovement(deltaTime: deltaTime)
        
        // Update turret rotation (if applicable)
        updateTurret(playerPosition: playerPosition)
        
        // Update visual effects
        updateVisualEffects()
    }
    
    private func updateAI(deltaTime: TimeInterval, playerPosition: CGPoint) {
        let distanceToPlayer = hypot(playerPosition.x - position.x, playerPosition.y - position.y)
        
        switch currentState {
        case .idle:
            if distanceToPlayer < detectionRange {
                currentState = .chase
            }
            
        case .patrol:
            if distanceToPlayer < detectionRange {
                currentState = .chase
            } else {
                // Patrol around center point
                let distanceFromCenter = hypot(position.x - patrolCenter.x, position.y - patrolCenter.y)
                if distanceFromCenter > patrolRadius {
                    // Return to patrol area
                    let angle = atan2(patrolCenter.y - position.y, patrolCenter.x - position.x)
                    velocity = CGVector(dx: cos(angle) * speed, dy: sin(angle) * speed)
                } else {
                    // Random patrol movement
                    if targetPosition == nil || hypot(position.x - targetPosition!.x, position.y - targetPosition!.y) < 10 {
                        let randomAngle = CGFloat.random(in: 0...(2 * .pi))
                        targetPosition = CGPoint(
                            x: patrolCenter.x + cos(randomAngle) * patrolRadius * 0.5,
                            y: patrolCenter.y + sin(randomAngle) * patrolRadius * 0.5
                        )
                    }
                }
            }
            
        case .chase:
            if distanceToPlayer > detectionRange * 1.5 {
                currentState = .patrol
            } else if distanceToPlayer < attackRange {
                currentState = .attack
            } else {
                // Move toward player
                let angle = atan2(playerPosition.y - position.y, playerPosition.x - position.x)
                velocity = CGVector(dx: cos(angle) * speed, dy: sin(angle) * speed)
                rotation = angle
            }
            
        case .attack:
            if distanceToPlayer > attackRange * 1.2 {
                currentState = .chase
            } else {
                // Face player and fire
                let angle = atan2(playerPosition.y - position.y, playerPosition.x - position.x)
                rotation = angle
                
                // Try to fire
                tryFire(at: playerPosition)
                
                // Strafe movement for some enemy types
                if enemyType == .chopper || enemyType == .drone {
                    let strafeAngle = angle + .pi / 2
                    velocity = CGVector(
                        dx: cos(strafeAngle) * speed * 0.5,
                        dy: sin(strafeAngle) * speed * 0.5
                    )
                } else {
                    velocity = .zero
                }
            }
            
        case .retreat:
            // Not implemented yet
            currentState = .patrol
        }
    }
    
    private func updateMovement(deltaTime: TimeInterval) {
        if let target = targetPosition, currentState == .patrol {
            let angle = atan2(target.y - position.y, target.x - position.x)
            velocity = CGVector(dx: cos(angle) * speed * 0.5, dy: sin(angle) * speed * 0.5)
        }
        
        // Apply velocity
        position.x += velocity.dx * deltaTime
        position.y += velocity.dy * deltaTime
        
        // Update physics body
        physicsBody?.velocity = velocity
        
        // Rotate body (except for turret which rotates separately)
        if enemyType != .turret {
            bodyNode.zRotation = rotation
        }
    }
    
    private func updateTurret(playerPosition: CGPoint) {
        guard enemyType == .tank || enemyType == .turret else { return }
        
        let angle = atan2(playerPosition.y - position.y, playerPosition.x - position.x)
        turretNode?.zRotation = angle
    }
    
    private func tryFire(at target: CGPoint) {
        let currentTime = CACurrentMediaTime()
        guard currentTime - lastFireTime >= fireRate else { return }
        
        guard let scene = scene as? GameScene else { return }
        
        let direction: CGVector
        if enemyType == .tank || enemyType == .turret {
            direction = CGVector(dx: cos(turretNode?.zRotation ?? rotation), dy: sin(turretNode?.zRotation ?? rotation))
        } else {
            direction = CGVector(dx: cos(rotation), dy: sin(rotation))
        }
        
        let firePosition = position + CGPoint(x: direction.dx * 25, y: direction.dy * 25)
        
        scene.spawnProjectile(
            from: firePosition,
            direction: direction,
            type: .machineGun,
            isPlayer: false
        )
        
        lastFireTime = currentTime
    }
    
    private func updateVisualEffects() {
        // Update shadow
        shadowNode.position = CGPoint(x: 5, y: -5)
    }
    
    // MARK: - Damage
    func takeDamage(_ amount: CGFloat) {
        health -= amount
        
        // Flash effect
        let flashAction = SKAction.sequence([
            SKAction.colorize(with: GameConstants.Visuals.neonRed, colorBlendFactor: 0.8, duration: 0.05),
            SKAction.colorize(withColorBlendFactor: 0, duration: 0.1)
        ])
        bodyNode.run(flashAction)
        
        if health <= 0 {
            isDestroyed = true
        }
    }
}
