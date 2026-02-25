import SpriteKit

class LevelGenerator {
    
    // MARK: - Properties
    weak var worldNode: SKNode?
    
    // MARK: - Tile Management
    var tiles: [String: SKNode] = [:]
    var buildings: [SKNode] = []
    var currentChunk: Int = 0
    var generatedChunks: Set<Int> = []
    
    // MARK: - Configuration
    let chunkWidth: CGFloat = 1280
    let chunkHeight: CGFloat = 1280
    let tileSize: CGFloat = 64
    
    // MARK: - Initialization
    init(worldNode: SKNode) {
        self.worldNode = worldNode
    }
    
    // MARK: - Initial Generation
    func generateInitialLevel() {
        // Generate central chunk
        generateChunk(at: 0)
        
        // Generate surrounding chunks
        for x in -1...1 {
            for y in -1...1 {
                if x == 0 && y == 0 { continue }
                generateChunk(at: x + y * 10)
            }
        }
    }
    
    // MARK: - Chunk Generation
    func generateChunk(at index: Int) {
        guard !generatedChunks.contains(index) else { return }
        generatedChunks.insert(index)
        
        let chunkX = CGFloat(index % 10) * chunkWidth
        let chunkY = CGFloat(index / 10) * chunkHeight
        
        // Generate buildings
        generateBuildings(in: CGRect(
            x: chunkX,
            y: chunkY,
            width: chunkWidth,
            height: chunkHeight
        ))
        
        // Generate roads
        generateRoads(in: CGRect(
            x: chunkX,
            y: chunkY,
            width: chunkWidth,
            height: chunkHeight
        ))
        
        // Generate neon signs
        generateNeonSigns(in: CGRect(
            x: chunkX,
            y: chunkY,
            width: chunkWidth,
            height: chunkHeight
        ))
        
        // Generate decorative elements
        generateDecorations(in: CGRect(
            x: chunkX,
            y: chunkY,
            width: chunkWidth,
            height: chunkHeight
        ))
    }
    
    // MARK: - Building Generation
    private func generateBuildings(in rect: CGRect) {
        let buildingCount = Int.random(in: 3...6)
        
        for _ in 0..<buildingCount {
            let width = CGFloat.random(in: 60...150)
            let height = CGFloat.random(in: 60...150)
            
            let x = CGFloat.random(in: rect.minX + 100...rect.maxX - 100)
            let y = CGFloat.random(in: rect.minY + 100...rect.maxY - 100)
            
            let building = createBuilding(width: width, height: height)
            building.position = CGPoint(x: x, y: y)
            worldNode?.addChild(building)
            buildings.append(building)
        }
    }
    
    private func createBuilding(width: CGFloat, height: CGFloat) -> SKNode {
        let building = SKNode()
        building.name = "building"
        
        // Main building body
        let body = SKShapeNode(rectOf: CGSize(width: width, height: height))
        body.fillColor = GameConstants.Visuals.buildingColor
        body.strokeColor = SKColor(red: 0.2, green: 0.2, blue: 0.3, alpha: 1)
        body.lineWidth = 2
        body.zPosition = GameConstants.ZPosition.buildings
        building.addChild(body)
        
        // Add windows
        let windowRows = Int(height / 20)
        let windowCols = Int(width / 20)
        
        for row in 0..<windowRows {
            for col in 0..<windowCols {
                if CGFloat.random(in: 0...1) > 0.3 {
                    let window = SKShapeNode(rectOf: CGSize(width: 8, height: 8))
                    
                    // Random window colors (cyberpunk style)
                    let colors: [SKColor] = [
                        SKColor(red: 0.9, green: 0.9, blue: 0.7, alpha: 0.6),  // Warm light
                        SKColor(red: 0.6, green: 0.8, blue: 1, alpha: 0.5),     // Cool light
                        SKColor(red: 1, green: 0.6, blue: 0.8, alpha: 0.5),     // Pink light
                        SKColor.clear
                    ]
                    
                    window.fillColor = colors.randomElement()!
                    window.strokeColor = SKColor.clear
                    window.position = CGPoint(
                        x: CGFloat(col) * 20 - width / 2 + 10,
                        y: CGFloat(row) * 20 - height / 2 + 10
                    )
                    window.zPosition = GameConstants.ZPosition.buildings + 1
                    building.addChild(window)
                }
            }
        }
        
        // Add physics body
        let physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: width, height: height))
        physicsBody.categoryBitMask = GameConstants.PhysicsCategory.building
        physicsBody.contactTestBitMask = GameConstants.PhysicsCategory.projectile
        physicsBody.collisionBitMask = GameConstants.PhysicsCategory.player | GameConstants.PhysicsCategory.enemy
        physicsBody.isDynamic = false
        physicsBody.allowsRotation = false
        building.physicsBody = physicsBody
        
        return building
    }
    
    // MARK: - Road Generation
    private func generateRoads(in rect: CGRect) {
        // Horizontal road
        let roadY = rect.midY + CGFloat.random(in: -100...100)
        let hRoad = createRoad(width: chunkWidth, height: 60, horizontal: true)
        hRoad.position = CGPoint(x: rect.midX, y: roadY)
        worldNode?.addChild(hRoad)
        
        // Vertical road
        let roadX = rect.midX + CGFloat.random(in: -100...100)
        let vRoad = createRoad(width: 60, height: chunkHeight, horizontal: false)
        vRoad.position = CGPoint(x: roadX, y: rect.midY)
        worldNode?.addChild(vRoad)
        
        // Intersection
        let intersection = SKShapeNode(rectOf: CGSize(width: 60, height: 60))
        intersection.fillColor = SKColor(red: 0.15, green: 0.15, blue: 0.2, alpha: 1)
        intersection.position = CGPoint(x: roadX, y: roadY)
        intersection.zPosition = GameConstants.ZPosition.ground
        worldNode?.addChild(intersection)
    }
    
    private func createRoad(width: CGFloat, height: CGFloat, horizontal: Bool) -> SKNode {
        let road = SKNode()
        
        // Road surface
        let surface = SKShapeNode(rectOf: CGSize(width: width, height: height))
        surface.fillColor = SKColor(red: 0.12, green: 0.12, blue: 0.15, alpha: 1)
        surface.strokeColor = SKColor.clear
        surface.zPosition = GameConstants.ZPosition.ground
        road.addChild(surface)
        
        // Road markings
        if horizontal {
            let marking = SKShapeNode(rectOf: CGSize(width: width, height: 2))
            marking.fillColor = SKColor(red: 0.4, green: 0.4, blue: 0.5, alpha: 0.5)
            marking.position = CGPoint(x: 0, y: 0)
            marking.zPosition = GameConstants.ZPosition.ground + 1
            road.addChild(marking)
        } else {
            let marking = SKShapeNode(rectOf: CGSize(width: 2, height: height))
            marking.fillColor = SKColor(red: 0.4, green: 0.4, blue: 0.5, alpha: 0.5)
            marking.position = CGPoint(x: 0, y: 0)
            marking.zPosition = GameConstants.ZPosition.ground + 1
            road.addChild(marking)
        }
        
        return road
    }
    
    // MARK: - Neon Sign Generation
    private func generateNeonSigns(in rect: CGRect) {
        let signCount = Int.random(in: 2...4)
        
        for _ in 0..<signCount {
            let x = CGFloat.random(in: rect.minX + 50...rect.maxX - 50)
            let y = CGFloat.random(in: rect.minY + 50...rect.maxY - 50)
            
            let sign = createNeonSign()
            sign.position = CGPoint(x: x, y: y)
            worldNode?.addChild(sign)
        }
    }
    
    private func createNeonSign() -> SKNode {
        let sign = SKNode()
        
        let colors: [SKColor] = [
            GameConstants.Visuals.neonPink,
            GameConstants.Visuals.neonCyan,
            GameConstants.Visuals.neonGreen,
            GameConstants.Visuals.neonPurple
        ]
        let color = colors.randomElement()!
        
        // Sign backing
        let backing = SKShapeNode(rectOf: CGSize(width: 80, height: 30), cornerRadius: 4)
        backing.fillColor = SKColor(white: 0.1, alpha: 1)
        backing.strokeColor = color
        backing.lineWidth = 2
        backing.zPosition = GameConstants.ZPosition.buildings + 2
        sign.addChild(backing)
        
        // Glow effect
        let glow = SKShapeNode(rectOf: CGSize(width: 84, height: 34), cornerRadius: 4)
        glow.fillColor = color
        glow.alpha = 0.2
        glow.zPosition = GameConstants.ZPosition.buildings + 1
        sign.addChild(glow)
        
        // Flicker animation
        let flickerAction = SKAction.sequence([
            SKAction.fadeAlpha(to: 0.1, duration: 0.05),
            SKAction.fadeAlpha(to: 0.3, duration: 0.05),
            SKAction.wait(forDuration: TimeInterval.random(in: 0.1...0.5)),
            SKAction.fadeAlpha(to: 0.15, duration: 0.1)
        ])
        glow.run(SKAction.repeatForever(flickerAction))
        
        return sign
    }
    
    // MARK: - Decoration Generation
    private func generateDecorations(in rect: CGRect) {
        // Add some containers/barrels
        let containerCount = Int.random(in: 3...8)
        
        for _ in 0..<containerCount {
            let x = CGFloat.random(in: rect.minX + 50...rect.maxX - 50)
            let y = CGFloat.random(in: rect.minY + 50...rect.maxY - 50)
            
            let container = createContainer()
            container.position = CGPoint(x: x, y: y)
            worldNode?.addChild(container)
        }
    }
    
    private func createContainer() -> SKNode {
        let container = SKNode()
        
        let size = CGFloat.random(in: 20...40)
        let box = SKShapeNode(rectOf: CGSize(width: size, height: size))
        box.fillColor = SKColor(red: 0.3, green: 0.2, blue: 0.1, alpha: 1)
        box.strokeColor = SKColor(red: 0.5, green: 0.4, blue: 0.2, alpha: 1)
        box.lineWidth = 1
        box.zPosition = GameConstants.ZPosition.buildings
        container.addChild(box)
        
        // Physics
        let physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: size, height: size))
        physicsBody.categoryBitMask = GameConstants.PhysicsCategory.building
        physicsBody.isDynamic = false
        container.physicsBody = physicsBody
        
        return container
    }
    
    // MARK: - Dynamic Update
    func update(playerPosition: CGPoint) {
        // Determine which chunk the player is in
        let chunkX = Int(playerPosition.x / chunkWidth)
        let chunkY = Int(playerPosition.y / chunkHeight)
        let currentChunkIndex = chunkX + chunkY * 10
        
        // Generate surrounding chunks if needed
        for dx in -1...1 {
            for dy in -1...1 {
                let chunkIndex = (chunkX + dx) + (chunkY + dy) * 10
                generateChunk(at: chunkIndex)
            }
        }
        
        // Cleanup distant chunks (optional, for memory management)
        // cleanupDistantChunks(from: currentChunkIndex)
    }
    
    // MARK: - Cleanup
    private func cleanupDistantChunks(from centerChunk: Int) {
        let centerX = centerChunk % 10
        let centerY = centerChunk / 10
        
        for chunkIndex in generatedChunks {
            let chunkX = chunkIndex % 10
            let chunkY = chunkIndex / 10
            
            let distance = max(abs(chunkX - centerX), abs(chunkY - centerY))
            
            if distance > 2 {
                // Remove chunk
                // TODO: Implement chunk removal
            }
        }
    }
}
