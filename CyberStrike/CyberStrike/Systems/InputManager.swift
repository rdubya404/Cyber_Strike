import SpriteKit

class InputManager {
    
    // MARK: - Input State
    var movementInput: CGVector = .zero
    var aimInput: CGVector = .zero
    var isFiring: Bool = false
    
    // MARK: - Touch Tracking
    private var movementTouch: UITouch?
    private var aimTouch: UITouch?
    private var fireTouch: UITouch?
    
    // MARK: - Joystick Visuals
    private var movementJoystick: JoystickNode?
    private var aimJoystick: JoystickNode?
    
    // MARK: - Scene Reference
    private weak var scene: SKScene?
    
    // MARK: - Configuration
    private let joystickRadius: CGFloat = 60
    private let joystickDeadzone: CGFloat = 10
    
    // MARK: - Initialization
    init(scene: SKScene) {
        self.scene = scene
        setupJoysticks()
    }
    
    // MARK: - Setup
    private func setupJoysticks() {
        guard let scene = scene else { return }
        
        // Movement joystick (bottom left)
        movementJoystick = JoystickNode(radius: joystickRadius)
        movementJoystick?.position = CGPoint(x: -scene.size.width / 2 + 100, y: -scene.size.height / 2 + 100)
        movementJoystick?.zPosition = GameConstants.ZPosition.hud
        scene.camera?.addChild(movementJoystick!)
        
        // Aim joystick (bottom right)
        aimJoystick = JoystickNode(radius: joystickRadius)
        aimJoystick?.position = CGPoint(x: scene.size.width / 2 - 100, y: -scene.size.height / 2 + 100)
        aimJoystick?.zPosition = GameConstants.ZPosition.hud
        scene.camera?.addChild(aimJoystick!)
    }
    
    // MARK: - Update
    func update(deltaTime: TimeInterval) {
        // Update joystick visuals based on input
        movementJoystick?.updateInput(movementInput)
        aimJoystick?.updateInput(aimInput)
    }
    
    // MARK: - Touch Handling
    func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let scene = scene else { return }
        
        for touch in touches {
            let location = touch.location(in: scene.camera!)
            
            // Check if touch is in movement joystick area (left side)
            if location.x < 0 && movementTouch == nil {
                movementTouch = touch
                movementJoystick?.show()
                movementJoystick?.position = CGPoint(
                    x: max(-scene.size.width / 2 + joystickRadius, location.x),
                    y: max(-scene.size.height / 2 + joystickRadius, location.y)
                )
            }
            // Check if touch is in aim joystick area (right side)
            else if location.x >= 0 && aimTouch == nil {
                aimTouch = touch
                aimJoystick?.show()
                aimJoystick?.position = CGPoint(
                    x: min(scene.size.width / 2 - joystickRadius, location.x),
                    y: max(-scene.size.height / 2 + joystickRadius, location.y)
                )
            }
        }
    }
    
    func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: scene!.camera!)
            
            if touch == movementTouch, let joystick = movementJoystick {
                let offset = CGVector(
                    dx: location.x - joystick.position.x,
                    dy: location.y - joystick.position.y
                )
                let distance = hypot(offset.dx, offset.dy)
                let maxDistance = joystickRadius
                
                if distance > joystickDeadzone {
                    let scale = min(distance, maxDistance) / distance
                    movementInput = CGVector(dx: offset.dx * scale / maxDistance, dy: offset.dy * scale / maxDistance)
                } else {
                    movementInput = .zero
                }
            }
            
            if touch == aimTouch, let joystick = aimJoystick {
                let offset = CGVector(
                    dx: location.x - joystick.position.x,
                    dy: location.y - joystick.position.y
                )
                let distance = hypot(offset.dx, offset.dy)
                let maxDistance = joystickRadius
                
                if distance > joystickDeadzone {
                    let scale = min(distance, maxDistance) / distance
                    aimInput = CGVector(dx: offset.dx * scale / maxDistance, dy: offset.dy * scale / maxDistance)
                    isFiring = true
                } else {
                    aimInput = .zero
                    isFiring = false
                }
            }
        }
    }
    
    func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if touch == movementTouch {
                movementTouch = nil
                movementInput = .zero
                movementJoystick?.hide()
            }
            
            if touch == aimTouch {
                aimTouch = nil
                aimInput = .zero
                isFiring = false
                aimJoystick?.hide()
            }
        }
    }
    
    func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesEnded(touches, with: event)
    }
}

// MARK: - Joystick Node
class JoystickNode: SKNode {
    
    private let background: SKShapeNode
    private let stick: SKShapeNode
    private let radius: CGFloat
    
    init(radius: CGFloat) {
        self.radius = radius
        
        // Background ring
        background = SKShapeNode(circleOfRadius: radius)
        background.fillColor = SKColor(white: 0.2, alpha: 0.3)
        background.strokeColor = SKColor(white: 0.5, alpha: 0.5)
        background.lineWidth = 2
        
        // Stick
        stick = SKShapeNode(circleOfRadius: radius * 0.4)
        stick.fillColor = GameConstants.Visuals.neonCyan
        stick.alpha = 0.8
        
        super.init()
        
        addChild(background)
        addChild(stick)
        
        alpha = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show() {
        alpha = 0
        let fadeIn = SKAction.fadeIn(withDuration: 0.1)
        run(fadeIn)
    }
    
    func hide() {
        let fadeOut = SKAction.fadeOut(withDuration: 0.1)
        run(fadeOut)
    }
    
    func updateInput(_ input: CGVector) {
        let maxDistance = radius * 0.5
        stick.position = CGPoint(
            x: input.dx * maxDistance,
            y: input.dy * maxDistance
        )
        
        // Change color based on input magnitude
        let magnitude = hypot(input.dx, input.dy)
        if magnitude > 0.5 {
            stick.fillColor = GameConstants.Visuals.neonGreen
        } else {
            stick.fillColor = GameConstants.Visuals.neonCyan
        }
    }
}
