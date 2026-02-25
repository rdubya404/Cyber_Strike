import SpriteKit

class CameraController {
    
    // MARK: - Properties
    private let camera: SKCameraNode
    private weak var target: SKNode?
    
    // MARK: - Camera Settings
    var followSpeed: CGFloat = 3.0
    var lookaheadDistance: CGFloat = 100.0
    var minZoom: CGFloat = 0.5
    var maxZoom: CGFloat = 1.5
    var currentZoom: CGFloat = 1.0
    
    // MARK: - Screen Shake
    private var shakeIntensity: CGFloat = 0
    private var shakeDuration: TimeInterval = 0
    private var shakeTimer: TimeInterval = 0
    
    // MARK: - Bounds
    var bounds: CGRect?
    
    // MARK: - Initialization
    init(camera: SKCameraNode, target: SKNode?) {
        self.camera = camera
        self.target = target
    }
    
    // MARK: - Update
    func update(deltaTime: TimeInterval) {
        guard let target = target else { return }
        
        // Calculate target position with lookahead
        var targetPosition = target.position
        
        // Add lookahead based on target's physics velocity
        if let physicsBody = target.physicsBody {
            let velocity = physicsBody.velocity
            let speed = hypot(velocity.dx, velocity.dy)
            if speed > 10 {
                let normalizedVelocity = CGVector(
                    dx: velocity.dx / speed,
                    dy: velocity.dy / speed
                )
                let lookahead = min(speed / 100, 1.0) * lookaheadDistance
                targetPosition.x += normalizedVelocity.dx * lookahead
                targetPosition.y += normalizedVelocity.dy * lookahead
            }
        }
        
        // Smooth follow
        let diffX = targetPosition.x - camera.position.x
        let diffY = targetPosition.y - camera.position.y
        
        camera.position.x += diffX * followSpeed * deltaTime
        camera.position.y += diffY * followSpeed * deltaTime
        
        // Apply bounds
        if let bounds = bounds {
            let halfWidth = (camera.scene?.size.width ?? 800) * 0.5 / currentZoom
            let halfHeight = (camera.scene?.size.height ?? 600) * 0.5 / currentZoom
            
            camera.position.x = max(bounds.minX + halfWidth, min(bounds.maxX - halfWidth, camera.position.x))
            camera.position.y = max(bounds.minY + halfHeight, min(bounds.maxY - halfHeight, camera.position.y))
        }
        
        // Apply screen shake
        updateShake(deltaTime: deltaTime)
        
        // Apply zoom
        camera.setScale(currentZoom)
    }
    
    // MARK: - Screen Shake
    func shake(duration: TimeInterval, intensity: CGFloat) {
        shakeDuration = duration
        shakeIntensity = intensity
        shakeTimer = 0
    }
    
    private func updateShake(deltaTime: TimeInterval) {
        guard shakeDuration > 0 else { return }
        
        shakeTimer += deltaTime
        
        if shakeTimer >= shakeDuration {
            shakeDuration = 0
            shakeIntensity = 0
            camera.position = CGPoint(x: round(camera.position.x), y: round(camera.position.y))
            return
        }
        
        // Decay intensity over time
        let progress = shakeTimer / shakeDuration
        let currentIntensity = shakeIntensity * (1 - progress)
        
        // Apply random offset
        let offsetX = CGFloat.random(in: -currentIntensity...currentIntensity)
        let offsetY = CGFloat.random(in: -currentIntensity...currentIntensity)
        
        camera.position.x += offsetX
        camera.position.y += offsetY
    }
    
    // MARK: - Zoom Control
    func zoom(to scale: CGFloat, duration: TimeInterval = 0.3) {
        let clampedScale = max(minZoom, min(maxZoom, scale))
        
        let zoomAction = SKAction.scale(to: 1 / clampedScale, duration: duration)
        zoomAction.timingMode = .easeInEaseOut
        camera.run(zoomAction)
        
        currentZoom = clampedScale
    }
    
    func zoomIn(duration: TimeInterval = 0.3) {
        zoom(to: currentZoom * 1.2, duration: duration)
    }
    
    func zoomOut(duration: TimeInterval = 0.3) {
        zoom(to: currentZoom / 1.2, duration: duration)
    }
    
    // MARK: - Focus Point
    func focus(on point: CGPoint, duration: TimeInterval = 0.5) {
        let moveAction = SKAction.move(to: point, duration: duration)
        moveAction.timingMode = .easeInEaseOut
        camera.run(moveAction)
    }
    
    // MARK: - Reset
    func reset() {
        shakeDuration = 0
        shakeIntensity = 0
        currentZoom = 1.0
        camera.setScale(1.0)
    }
}
