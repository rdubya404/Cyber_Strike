import SpriteKit

class ParticleEffects {
    
    // MARK: - Explosion Sizes
    enum ExplosionSize {
        case small
        case medium
        case large
        
        var radius: CGFloat {
            switch self {
            case .small: return 20
            case .medium: return 40
            case .large: return 70
            }
        }
        
        var particleCount: Int {
            switch self {
            case .small: return 8
            case .medium: return 15
            case .large: return 25
            }
        }
    }
    
    // MARK: - Explosion Effect
    func createExplosion(at position: CGPoint, size: ExplosionSize, in parent: SKNode) {
        // Main flash
        let flash = SKShapeNode(circleOfRadius: size.radius)
        flash.fillColor = SKColor.white
        flash.alpha = 0.8
        flash.position = position
        flash.zPosition = GameConstants.ZPosition.effects
        parent.addChild(flash)
        
        let flashExpand = SKAction.scale(to: 1.5, duration: 0.1)
        let flashFade = SKAction.fadeOut(withDuration: 0.2)
        flash.run(SKAction.sequence([flashExpand, flashFade])) {
            flash.removeFromParent()
        }
        
        // Explosion particles
        for _ in 0..<size.particleCount {
            let particle = createExplosionParticle(radius: size.radius)
            particle.position = position
            parent.addChild(particle)
            
            // Random direction
            let angle = CGFloat.random(in: 0...(2 * .pi))
            let speed = CGFloat.random(in: 50...150)
            let distance = CGFloat.random(in: size.radius * 0.5...size.radius * 1.5)
            
            let destination = CGPoint(
                x: position.x + cos(angle) * distance,
                y: position.y + sin(angle) * distance
            )
            
            let duration = TimeInterval(distance / speed)
            
            let moveAction = SKAction.move(to: destination, duration: duration)
            let fadeAction = SKAction.fadeOut(withDuration: duration)
            let scaleAction = SKAction.scale(to: 0, duration: duration)
            
            let group = SKAction.group([moveAction, fadeAction, scaleAction])
            particle.run(group) {
                particle.removeFromParent()
            }
        }
        
        // Smoke particles
        for _ in 0..<(size.particleCount / 2) {
            let smoke = createSmokeParticle()
            smoke.position = position
            parent.addChild(smoke)
            
            let angle = CGFloat.random(in: 0...(2 * .pi))
            let distance = CGFloat.random(in: 20...size.radius)
            let destination = CGPoint(
                x: position.x + cos(angle) * distance,
                y: position.y + sin(angle) * distance
            )
            
            let duration = TimeInterval.random(in: 0.5...1.0)
            
            let moveAction = SKAction.move(to: destination, duration: duration)
            let fadeAction = SKAction.fadeOut(withDuration: duration)
            let expandAction = SKAction.scale(to: 2.0, duration: duration)
            
            let group = SKAction.group([moveAction, fadeAction, expandAction])
            smoke.run(group) {
                smoke.removeFromParent()
            }
        }
    }
    
    private func createExplosionParticle(radius: CGFloat) -> SKShapeNode {
        let particle = SKShapeNode(circleOfRadius: CGFloat.random(in: 3...8))
        
        // Random fire colors
        let colors: [SKColor] = [
            GameConstants.Visuals.neonRed,
            GameConstants.Visuals.neonYellow,
            SKColor.orange,
            SKColor(red: 1, green: 0.5, blue: 0, alpha: 1)
        ]
        
        particle.fillColor = colors.randomElement()!
        particle.strokeColor = SKColor.clear
        particle.zPosition = GameConstants.ZPosition.effects
        return particle
    }
    
    private func createSmokeParticle() -> SKShapeNode {
        let particle = SKShapeNode(circleOfRadius: CGFloat.random(in: 5...12))
        particle.fillColor = SKColor(white: 0.3, alpha: 0.5)
        particle.strokeColor = SKColor.clear
        particle.zPosition = GameConstants.ZPosition.effects - 1
        return particle
    }
    
    // MARK: - Muzzle Flash
    func createMuzzleFlash(at position: CGPoint, in parent: SKNode) {
        let flash = SKShapeNode(circleOfRadius: 8)
        flash.fillColor = GameConstants.Visuals.neonYellow
        flash.alpha = 0.9
        flash.position = position
        flash.zPosition = GameConstants.ZPosition.effects
        parent.addChild(flash)
        
        let expand = SKAction.scale(to: 1.5, duration: 0.02)
        let fade = SKAction.fadeOut(withDuration: 0.05)
        
        flash.run(SKAction.sequence([expand, fade])) {
            flash.removeFromParent()
        }
        
        // Light rays
        for i in 0..<4 {
            let ray = SKShapeNode(rectOf: CGSize(width: 20, height: 3))
            ray.fillColor = GameConstants.Visuals.neonYellow
            ray.alpha = 0.6
            ray.position = position
            ray.zRotation = CGFloat(i) * (.pi / 4)
            ray.zPosition = GameConstants.ZPosition.effects - 1
            parent.addChild(ray)
            
            let rayFade = SKAction.fadeOut(withDuration: 0.08)
            ray.run(rayFade) {
                ray.removeFromParent()
            }
        }
    }
    
    // MARK: - Spark Effect
    func createSpark(at position: CGPoint, in parent: SKNode) {
        for _ in 0..<5 {
            let spark = SKShapeNode(circleOfRadius: CGFloat.random(in: 2...4))
            spark.fillColor = GameConstants.Visuals.neonYellow
            spark.position = position
            spark.zPosition = GameConstants.ZPosition.effects
            parent.addChild(spark)
            
            let angle = CGFloat.random(in: 0...(2 * .pi))
            let distance = CGFloat.random(in: 10...30)
            let destination = CGPoint(
                x: position.x + cos(angle) * distance,
                y: position.y + sin(angle) * distance
            )
            
            let duration = TimeInterval.random(in: 0.1...0.2)
            
            let moveAction = SKAction.move(to: destination, duration: duration)
            let fadeAction = SKAction.fadeOut(withDuration: duration)
            
            spark.run(SKAction.group([moveAction, fadeAction])) {
                spark.removeFromParent()
            }
        }
    }
    
    // MARK: - Engine Trail
    func createEngineTrail(at position: CGPoint, direction: CGVector, in parent: SKNode) {
        let trail = SKShapeNode(circleOfRadius: 4)
        trail.fillColor = GameConstants.Visuals.neonCyan
        trail.alpha = 0.4
        trail.position = position
        trail.zPosition = GameConstants.ZPosition.particles
        parent.addChild(trail)
        
        let fadeAction = SKAction.fadeOut(withDuration: 0.3)
        let shrinkAction = SKAction.scale(to: 0.5, duration: 0.3)
        
        trail.run(SKAction.group([fadeAction, shrinkAction])) {
            trail.removeFromParent()
        }
    }
    
    // MARK: - Rain Effect
    func createRainEffect(in parent: SKNode, frame: CGRect) -> SKNode {
        let rainNode = SKNode()
        rainNode.name = "rain"
        rainNode.zPosition = GameConstants.ZPosition.effects + 10
        
        // Create rain drops
        for _ in 0..<100 {
            let drop = SKShapeNode(rectOf: CGSize(width: 1, height: 15))
            drop.fillColor = SKColor(red: 0.6, green: 0.7, blue: 0.9, alpha: 0.3)
            drop.position = CGPoint(
                x: CGFloat.random(in: frame.minX...frame.maxX),
                y: CGFloat.random(in: frame.minY...frame.maxY)
            )
            rainNode.addChild(drop)
            
            // Animate drop
            let speed = CGFloat.random(in: 300...500)
            let duration = TimeInterval((drop.position.y - frame.minY) / speed)
            
            let moveAction = SKAction.moveTo(y: frame.minY, duration: duration)
            let resetAction = SKAction.run {
                drop.position.y = frame.maxY
                drop.position.x = CGFloat.random(in: frame.minX...frame.maxX)
            }
            
            drop.run(SKAction.repeatForever(SKAction.sequence([moveAction, resetAction])))
        }
        
        parent.addChild(rainNode)
        return rainNode
    }
    
    // MARK: - Neon Glow Effect
    func createNeonGlow(for node: SKNode, color: SKColor, radius: CGFloat) {
        let glow = SKShapeNode(circleOfRadius: radius)
        glow.fillColor = color
        glow.alpha = 0.15
        glow.zPosition = -1
        
        let pulseAction = SKAction.sequence([
            SKAction.fadeAlpha(to: 0.25, duration: 0.5),
            SKAction.fadeAlpha(to: 0.1, duration: 0.5)
        ])
        glow.run(SKAction.repeatForever(pulseAction))
        
        node.addChild(glow)
    }
}
