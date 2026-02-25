import SpriteKit

class Physics {
    
    // MARK: - Collision Detection Helpers
    static func checkCollision(between nodeA: SKNode, and nodeB: SKNode) -> Bool {
        guard let bodyA = nodeA.physicsBody, let bodyB = nodeB.physicsBody else {
            return false
        }
        
        return bodyA.allContactedBodies().contains(bodyB)
    }
    
    // MARK: - Raycasting
    static func raycast(from start: CGPoint, direction: CGVector, length: CGFloat, in scene: SKScene) -> [SKPhysicsBody] {
        let end = CGPoint(
            x: start.x + direction.dx * length,
            y: start.y + direction.dy * length
        )
        
        var hitBodies: [SKPhysicsBody] = []
        
        scene.physicsWorld.enumerateBodies(alongRayStart: start, end: end) { body, _, _, stop in
            hitBodies.append(body)
        }
        
        return hitBodies
    }
    
    // MARK: - Area Query
    static func queryBodies(in rect: CGRect, in scene: SKScene) -> [SKPhysicsBody] {
        var bodies: [SKPhysicsBody] = []
        
        scene.physicsWorld.enumerateBodies(in: rect) { body, stop in
            bodies.append(body)
        }
        
        return bodies
    }
    
    // MARK: - Explosion Force
    static func applyExplosionForce(at point: CGPoint, radius: CGFloat, force: CGFloat, in scene: SKScene) {
        let affectedBodies = queryBodies(in: CGRect(
            x: point.x - radius,
            y: point.y - radius,
            width: radius * 2,
            height: radius * 2
        ), in: scene)
        
        for body in affectedBodies {
            guard let node = body.node else { continue }
            
            let distance = hypot(node.position.x - point.x, node.position.y - point.y)
            guard distance < radius else { continue }
            
            let direction = CGVector(
                dx: (node.position.x - point.x) / distance,
                dy: (node.position.y - point.y) / distance
            )
            
            let falloff = 1 - (distance / radius)
            let appliedForce = force * falloff
            
            body.applyForce(CGVector(
                dx: direction.dx * appliedForce,
                dy: direction.dy * appliedForce
            ))
        }
    }
    
    // MARK: - Physics Helpers
    static func createCircularBody(radius: CGFloat, category: UInt32, collision: UInt32, contact: UInt32) -> SKPhysicsBody {
        let body = SKPhysicsBody(circleOfRadius: radius)
        body.categoryBitMask = category
        body.collisionBitMask = collision
        body.contactTestBitMask = contact
        return body
    }
    
    static func createRectangularBody(size: CGSize, category: UInt32, collision: UInt32, contact: UInt32) -> SKPhysicsBody {
        let body = SKPhysicsBody(rectangleOf: size)
        body.categoryBitMask = category
        body.collisionBitMask = collision
        body.contactTestBitMask = contact
        return body
    }
}

// MARK: - Vector Extensions
extension CGVector {
    static func + (lhs: CGVector, rhs: CGVector) -> CGVector {
        return CGVector(dx: lhs.dx + rhs.dx, dy: lhs.dy + rhs.dy)
    }
    
    static func - (lhs: CGVector, rhs: CGVector) -> CGVector {
        return CGVector(dx: lhs.dx - rhs.dx, dy: lhs.dy - rhs.dy)
    }
    
    static func * (lhs: CGVector, rhs: CGFloat) -> CGVector {
        return CGVector(dx: lhs.dx * rhs, dy: lhs.dy * rhs)
    }
    
    static func / (lhs: CGVector, rhs: CGFloat) -> CGVector {
        return CGVector(dx: lhs.dx / rhs, dy: lhs.dy / rhs)
    }
    
    var magnitude: CGFloat {
        return hypot(dx, dy)
    }
    
    var normalized: CGVector {
        let mag = magnitude
        guard mag > 0 else { return .zero }
        return self / mag
    }
    
    func dot(_ other: CGVector) -> CGFloat {
        return dx * other.dx + dy * other.dy
    }
}

// MARK: - CGPoint Extensions
extension CGPoint {
    static func + (lhs: CGPoint, rhs: CGVector) -> CGPoint {
        return CGPoint(x: lhs.x + rhs.dx, y: lhs.y + rhs.dy)
    }
    
    static func - (lhs: CGPoint, rhs: CGPoint) -> CGVector {
        return CGVector(dx: lhs.x - rhs.x, dy: lhs.y - rhs.y)
    }
    
    static func distance(from a: CGPoint, to b: CGPoint) -> CGFloat {
        return hypot(b.x - a.x, b.y - a.y)
    }
}
