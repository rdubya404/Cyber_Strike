import SpriteKit

// MARK: - Game Constants
struct GameConstants {
    
    // MARK: Physics Categories
    struct PhysicsCategory {
        static let none: UInt32 = 0
        static let player: UInt32 = 0b1
        static let enemy: UInt32 = 0b10
        static let projectile: UInt32 = 0b100
        static let enemyProjectile: UInt32 = 0b1000
        static let building: UInt32 = 0b10000
        static let powerUp: UInt32 = 0b100000
        static let ground: UInt32 = 0b1000000
    }
    
    // MARK: Player Constants
    struct Player {
        static let maxHealth: CGFloat = 100
        static let maxArmor: CGFloat = 50
        static let maxFuel: CGFloat = 100
        static let maxEnergy: CGFloat = 100
        static let acceleration: CGFloat = 400
        static let maxSpeed: CGFloat = 300
        static let friction: CGFloat = 0.92
        static let rotationSpeed: CGFloat = 3.0
        static let fuelConsumptionRate: CGFloat = 2.0
    }
    
    // MARK: Weapon Constants
    struct Weapons {
        static let machineGunDamage: CGFloat = 10
        static let machineGunFireRate: TimeInterval = 0.1
        static let machineGunSpeed: CGFloat = 800
        
        static let missileDamage: CGFloat = 50
        static let missileFireRate: TimeInterval = 0.5
        static let missileSpeed: CGFloat = 400
        static let missileTurnRate: CGFloat = 2.0
        
        static let laserDamage: CGFloat = 5
        static let laserFireRate: TimeInterval = 0.05
        static let laserSpeed: CGFloat = 1200
    }
    
    // MARK: Enemy Constants
    struct Enemies {
        static let tankHealth: CGFloat = 60
        static let tankDamage: CGFloat = 15
        static let tankSpeed: CGFloat = 50
        
        static let chopperHealth: CGFloat = 40
        static let chopperDamage: CGFloat = 10
        static let chopperSpeed: CGFloat = 150
        
        static let turretHealth: CGFloat = 80
        static let turretDamage: CGFloat = 20
        
        static let droneHealth: CGFloat = 20
        static let droneDamage: CGFloat = 5
        static let droneSpeed: CGFloat = 200
    }
    
    // MARK: Level Constants
    struct Level {
        static let tileSize: CGFloat = 64
        static let chunkSize: Int = 20
        static let parallaxLayers: Int = 3
    }
    
    // MARK: Visual Constants
    struct Visuals {
        static let neonCyan = SKColor(red: 0, green: 1, blue: 1, alpha: 1)
        static let neonPink = SKColor(red: 1, green: 0, blue: 0.8, alpha: 1)
        static let neonGreen = SKColor(red: 0, green: 1, blue: 0.4, alpha: 1)
        static let neonRed = SKColor(red: 1, green: 0.2, blue: 0.2, alpha: 1)
        static let neonPurple = SKColor(red: 0.8, green: 0, blue: 1, alpha: 1)
        static let neonYellow = SKColor(red: 1, green: 0.9, blue: 0, alpha: 1)
        static let darkBackground = SKColor(red: 0.05, green: 0.05, blue: 0.1, alpha: 1)
        static let buildingColor = SKColor(red: 0.1, green: 0.1, blue: 0.15, alpha: 1)
    }
    
    // MARK: Z-Positions
    struct ZPosition {
        static let background: CGFloat = 0
        static let parallaxBack: CGFloat = 10
        static let parallaxMid: CGFloat = 20
        static let ground: CGFloat = 30
        static let shadows: CGFloat = 35
        static let buildings: CGFloat = 40
        static let enemies: CGFloat = 50
        static let player: CGFloat = 60
        static let projectiles: CGFloat = 70
        static let particles: CGFloat = 80
        static let effects: CGFloat = 90
        static let hud: CGFloat = 100
        static let menu: CGFloat = 200
    }
}

// MARK: - Game State
enum GameState {
    case menu
    case playing
    case paused
    case gameOver
    case victory
}

// MARK: - Weapon Types
enum WeaponType {
    case machineGun
    case missile
    case laser
    
    var fireRate: TimeInterval {
        switch self {
        case .machineGun: return GameConstants.Weapons.machineGunFireRate
        case .missile: return GameConstants.Weapons.missileFireRate
        case .laser: return GameConstants.Weapons.laserFireRate
        }
    }
}

// MARK: - Enemy Types
enum EnemyType {
    case tank
    case chopper
    case turret
    case drone
}

// MARK: - PowerUp Types
enum PowerUpType {
    case health
    case armor
    case fuel
    case energy
    case ammo
    case weaponUpgrade
}
