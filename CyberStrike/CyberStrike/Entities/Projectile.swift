import SpriteKit

class Projectile: SKNode {
    
    // MARK: - Properties
    let weaponType: WeaponType
    let damage: CGFloat
    let speed: CGFloat
    let isPlayerProjectile: Bool
    var direction: CGVector
    var lifetime: TimeInterval = 3.0
    var age: TimeInterval = 0
    
    // MARK: - Visual Components
    var bodyNode: SKShapeNode!
    var trailNode: SKShapeNode?
    
    // MARK: - Initialization
    init(type: WeaponType, position: CGPoint, direction: CGVector, isPlayer: Bool) {
        self.weaponType = type
        self.direction = direction
        self.isPlayerProjectile = isPlayer
        
        // Set properties based on weapon type
        switch type {
        case .machineGun:
            damage = GameConstants.Weapons.machineGunDamage
            speed = GameConstants.Weapons.machineGunSpeed
            lifetime = 1.5
        case .missile:
            damage = GameConstants.Weapons.missileDamage
            speed = GameConstants.Weapons.missileSpeed
            lifetime = 5.0
        case .laser:
            damage = GameConstants.Weapons.laserDamage
            speed = GameConstants.Weapons.laserSpeed
            lifetime = 0.5
        }
        
        super.init()
        
        self.position = position
        self.zRotation = atan2(direction.dy, direction.dx)
        
        setupVisuals()
        setupPhysics()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupVisuals() {
        switch weaponType {
        case .machineGun:
            setupMachineGunVisuals()
        case .missile:
            setupMissileVisuals()
        case .laser:
            setupLaserVisuals()
        }
    }
    
    private func setupMachineGunVisuals() {
        // Bullet
        bodyNode = SKShapeNode(rectOf: CGSize(width: 12, height: 4), cornerRadius: 2)
        
        if isPlayerProjectile {
            bodyNode.fillColor = GameConstants.Visuals.neonYellow
            bodyNode.strokeColor = GameConstants.Visuals.neonYellow
        } else {
            bodyNode.fillColor = GameConstants.Visuals.neonRed
            bodyNode.strokeColor = GameConstants.Visuals.neonRed
        }
        
        bodyNode.lineWidth = 1
        bodyNode.zPosition = GameConstants.ZPosition.projectiles
        addChild(bodyNode)
        
        // Glow effect
        bodyNode.glowWidth = 3
    }
    
    private func setupMissileVisuals() {
        // Missile body
        bodyNode = SKShapeNode()
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 10, y: 0))
        path.addLine(to: CGPoint(x: -5, y: 4))
        path.addLine(to: CGPoint(x: -8, y: 2))
        path.addLine(to: CGPoint(x: -8, y: -2))
        path.addLine(to: CGPoint(x: -5, y: -4))
        path.closeSubpath()
        
        bodyNode.path = path
        bodyNode.fillColor = SKColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1)
        bodyNode.strokeColor = isPlayerProjectile ? GameConstants.Visuals.neonGreen : GameConstants.Visuals.neonRed
        bodyNode.lineWidth = 2
        bodyNode.zPosition = GameConstants.ZPosition.projectiles
        addChild(bodyNode)
        
        // Engine glow
        let engine = SKShapeNode(circleOfRadius: 4)
        engine.fillColor = GameConstants.Visuals.neonOrange
        engine.alpha = 0.7
        engine.position = CGPoint(x: -8, y: 0)
        engine.zPosition = GameConstants.ZPosition.projectiles - 1
        addChild(engine)
        
        // Engine flicker animation
        let flickerAction = SKAction.sequence([
            SKAction.scale(to: 1.2, duration: 0.05),
            SKAction.scale(to: 0.8, duration: 0.05)
        ])
        engine.run(SKAction.repeatForever(flickerAction))
    }
    
    private func setupLaserVisuals() {
        // Laser beam
        bodyNode = SKShapeNode(rectOf: CGSize(width: 30, height: 3))
        bodyNode.fillColor = isPlayerProjectile ? GameConstants.Visuals.neonCyan : GameConstants.Visuals.neonPurple
        bodyNode.strokeColor = SKColor.white
        bodyNode.lineWidth = 1
        bodyNode.zPosition = GameConstants.ZPosition.projectiles
        bodyNode.alpha = 0.9
        addChild(bodyNode)
        
        // Core glow
        bodyNode.glowWidth = 5
    }
    
    private func setupPhysics() {
        var body: SKPhysicsBody
        
        switch weaponType {
        case .machineGun:
            body = SKPhysicsBody(rectangleOf: CGSize(width: 12, height: 4))
        case .missile:
            body = SKPhysicsBody(circleOfRadius: 8)
        case .laser:
            body = SKPhysicsBody(rectangleOf: CGSize(width: 30, height: 3))
        }
        
        body.categoryBitMask = isPlayerProjectile ? 
            GameConstants.PhysicsCategory.projectile : 
            GameConstants.PhysicsCategory.enemyProjectile
        body.contactTestBitMask = isPlayerProjectile ?
            GameConstants.PhysicsCategory.enemy | GameConstants.PhysicsCategory.building :
            GameConstants.PhysicsCategory.player | GameConstants.PhysicsCategory.building
        body.collisionBitMask = GameConstants.PhysicsCategory.none
        body.allowsRotation = false
        body.mass = 0.01
        
        self.physicsBody = body
    }
    
    // MARK: - Update
    func update(deltaTime: TimeInterval) {
        age += deltaTime
        
        // Check lifetime
        if age >= lifetime {
            removeFromParent()
            return
        }
        
        // Update position
        position.x += direction.dx * speed * deltaTime
        position.y += direction.dy * speed * deltaTime
        
        // Update physics body velocity
        physicsBody?.velocity = CGVector(dx: direction.dx * speed, dy: direction.dy * speed)
        
        // Missile homing behavior
        if weaponType == .missile {
            updateMissileHoming(deltaTime: deltaTime)
        }
        
        // Fade out near end of life
        if age > lifetime - 0.3 {
            alpha = CGFloat((lifetime - age) / 0.3)
        }
    }
    
    private func updateMissileHoming(deltaTime: TimeInterval) {
        guard isPlayerProjectile else { return }
        
        // Find nearest enemy
        var nearestEnemy: SKNode?
        var nearestDistance: CGFloat = .greatestFiniteMagnitude
        
        scene?.enumerateChildNodes(withName: "//enemy") { node, _ in
            let distance = hypot(node.position.x - self.position.x, node.position.y - self.position.y)
            if distance < nearestDistance && distance < 300 {
                nearestDistance = distance
                nearestEnemy = node
            }
        }
        
        // Steer toward target
        if let target = nearestEnemy {
            let targetAngle = atan2(target.position.y - position.y, target.position.x - position.x)
            let currentAngle = atan2(direction.dy, direction.dx)
            
            var angleDiff = targetAngle - currentAngle
            while angleDiff > .pi { angleDiff -= 2 * .pi }
            while angleDiff < -.pi { angleDiff += 2 * .pi }
            
            let turnAmount = angleDiff * GameConstants.Weapons.missileTurnRate * deltaTime
            let newAngle = currentAngle + turnAmount
            
            direction = CGVector(dx: cos(newAngle), dy: sin(newAngle))
            zRotation = newAngle
        }
    }
}

// MARK: - PowerUp
class PowerUp: SKNode {
    
    let type: PowerUpType
    var bodyNode: SKShapeNode!
    var glowNode: SKShapeNode!
    
    init(type: PowerUpType) {
        self.type = type
        super.init()
        setupVisuals()
        setupPhysics()
        startAnimation()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupVisuals() {
        // Container for animation
        let container = SKNode()
        addChild(container)
        
        // Glow
        glowNode = SKShapeNode(circleOfRadius: 20)
        glowNode.fillColor = getColorForType()
        glowNode.alpha = 0.2
        glowNode.zPosition = GameConstants.ZPosition.powerUp - 1
        container.addChild(glowNode)
        
        // Main body
        bodyNode = SKShapeNode(circleOfRadius: 12)
        bodyNode.fillColor = SKColor.black
        bodyNode.strokeColor = getColorForType()
        bodyNode.lineWidth = 2
        bodyNode.zPosition = GameConstants.ZPosition.powerUp
        container.addChild(bodyNode)
        
        // Icon
        let icon = createIcon()
        icon.zPosition = GameConstants.ZPosition.powerUp + 1
        container.addChild(icon)
        
        // Store reference for animation
        container.name = "container"
    }
    
    private func createIcon() -> SKNode {
        let iconNode = SKNode()
        
        switch type {
        case .health:
            // Plus sign
            let hBar = SKShapeNode(rectOf: CGSize(width: 12, height: 4))
            hBar.fillColor = getColorForType()
            let vBar = SKShapeNode(rectOf: CGSize(width: 4, height: 12))
            vBar.fillColor = getColorForType()
            iconNode.addChild(hBar)
            iconNode.addChild(vBar)
            
        case .armor:
            // Shield shape
            let shield = SKShapeNode()
            let path = CGMutablePath()
            path.move(to: CGPoint(x: 0, y: 8))
            path.addLine(to: CGPoint(x: 8, y: 4))
            path.addLine(to: CGPoint(x: 6, y: -6))
            path.addLine(to: CGPoint(x: 0, y: -8))
            path.addLine(to: CGPoint(x: -6, y: -6))
            path.addLine(to: CGPoint(x: -8, y: 4))
            path.closeSubpath()
            shield.path = path
            shield.fillColor = getColorForType()
            iconNode.addChild(shield)
            
        case .fuel:
            // Fuel drop
            let drop = SKShapeNode()
            let path = CGMutablePath()
            path.move(to: CGPoint(x: 0, y: 8))
            path.addQuadCurve(to: CGPoint(x: 0, y: -8), control: CGPoint(x: 8, y: 0))
            path.addQuadCurve(to: CGPoint(x: 0, y: 8), control: CGPoint(x: -8, y: 0))
            drop.path = path
            drop.fillColor = getColorForType()
            iconNode.addChild(drop)
            
        case .energy:
            // Lightning bolt
            let bolt = SKShapeNode()
            let path = CGMutablePath()
            path.move(to: CGPoint(x: 2, y: 8))
            path.addLine(to: CGPoint(x: -4, y: 0))
            path.addLine(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: -2, y: -8))
            path.addLine(to: CGPoint(x: 4, y: 0))
            path.addLine(to: CGPoint(x: 0, y: 0))
            path.closeSubpath()
            bolt.path = path
            bolt.fillColor = getColorForType()
            iconNode.addChild(bolt)
            
        case .ammo:
            // Bullet
            let bullet = SKShapeNode(rectOf: CGSize(width: 4, height: 12))
            bullet.fillColor = getColorForType()
            iconNode.addChild(bullet)
            
        case .weaponUpgrade:
            // Star
            let star = SKShapeNode()
            let path = CGMutablePath()
            for i in 0..<10 {
                let angle = CGFloat(i) * .pi / 5 - .pi / 2
                let radius = i % 2 == 0 ? 8 : 4
                let point = CGPoint(x: cos(angle) * CGFloat(radius), y: sin(angle) * CGFloat(radius))
                if i == 0 {
                    path.move(to: point)
                } else {
                    path.addLine(to: point)
                }
            }
            path.closeSubpath()
            star.path = path
            star.fillColor = getColorForType()
            iconNode.addChild(star)
        }
        
        return iconNode
    }
    
    private func getColorForType() -> SKColor {
        switch type {
        case .health:
            return GameConstants.Visuals.neonRed
        case .armor:
            return GameConstants.Visuals.neonGreen
        case .fuel:
            return GameConstants.Visuals.neonYellow
        case .energy:
            return GameConstants.Visuals.neonCyan
        case .ammo:
            return GameConstants.Visuals.neonPurple
        case .weaponUpgrade:
            return SKColor.orange
        }
    }
    
    private func setupPhysics() {
        let body = SKPhysicsBody(circleOfRadius: 15)
        body.categoryBitMask = GameConstants.PhysicsCategory.powerUp
        body.contactTestBitMask = GameConstants.PhysicsCategory.player
        body.collisionBitMask = GameConstants.PhysicsCategory.none
        body.allowsRotation = false
        body.isDynamic = false
        
        self.physicsBody = body
    }
    
    private func startAnimation() {
        guard let container = childNode(withName: "container") else { return }
        
        // Float animation
        let floatAction = SKAction.sequence([
            SKAction.moveBy(x: 0, y: 5, duration: 0.5),
            SKAction.moveBy(x: 0, y: -5, duration: 0.5)
        ])
        container.run(SKAction.repeatForever(floatAction))
        
        // Glow pulse
        let pulseAction = SKAction.sequence([
            SKAction.fadeAlpha(to: 0.4, duration: 0.5),
            SKAction.fadeAlpha(to: 0.1, duration: 0.5)
        ])
        glowNode.run(SKAction.repeatForever(pulseAction))
        
        // Rotate slowly
        let rotateAction = SKAction.rotate(byAngle: .pi * 2, duration: 4)
        container.run(SKAction.repeatForever(rotateAction))
    }
}
