import SpriteKit

class WeaponSystem {
    
    // MARK: - Weapon Stats
    struct WeaponStats {
        let damage: CGFloat
        let fireRate: TimeInterval
        let projectileSpeed: CGFloat
        let ammoCapacity: Int
        let reloadTime: TimeInterval
    }
    
    // MARK: - Available Weapons
    static let machineGunStats = WeaponStats(
        damage: GameConstants.Weapons.machineGunDamage,
        fireRate: GameConstants.Weapons.machineGunFireRate,
        projectileSpeed: GameConstants.Weapons.machineGunSpeed,
        ammoCapacity: 100,
        reloadTime: 2.0
    )
    
    static let missileStats = WeaponStats(
        damage: GameConstants.Weapons.missileDamage,
        fireRate: GameConstants.Weapons.missileFireRate,
        projectileSpeed: GameConstants.Weapons.missileSpeed,
        ammoCapacity: 10,
        reloadTime: 3.0
    )
    
    static let laserStats = WeaponStats(
        damage: GameConstants.Weapons.laserDamage,
        fireRate: GameConstants.Weapons.laserFireRate,
        projectileSpeed: GameConstants.Weapons.laserSpeed,
        ammoCapacity: 50,
        reloadTime: 1.5
    )
    
    // MARK: - Current State
    var currentWeapon: WeaponType = .machineGun
    var ammo: [WeaponType: Int] = [:]
    var isReloading: Bool = false
    var reloadTimer: TimeInterval = 0
    
    // MARK: - Initialization
    init() {
        // Initialize ammo
        ammo[.machineGun] = WeaponSystem.machineGunStats.ammoCapacity
        ammo[.missile] = WeaponSystem.missileStats.ammoCapacity
        ammo[.laser] = WeaponSystem.laserStats.ammoCapacity
    }
    
    // MARK: - Weapon Stats Access
    func stats(for weapon: WeaponType) -> WeaponStats {
        switch weapon {
        case .machineGun:
            return WeaponSystem.machineGunStats
        case .missile:
            return WeaponSystem.missileStats
        case .laser:
            return WeaponSystem.laserStats
        }
    }
    
    // MARK: - Ammo Management
    func currentAmmo() -> Int {
        return ammo[currentWeapon] ?? 0
    }
    
    func consumeAmmo() -> Bool {
        guard !isReloading else { return false }
        
        if let current = ammo[currentWeapon], current > 0 {
            ammo[currentWeapon] = current - 1
            return true
        }
        
        // Auto reload when empty
        startReload()
        return false
    }
    
    func addAmmo(for weapon: WeaponType, amount: Int) {
        let stats = self.stats(for: weapon)
        let current = ammo[weapon] ?? 0
        ammo[weapon] = min(current + amount, stats.ammoCapacity)
    }
    
    // MARK: - Reloading
    func startReload() {
        guard !isReloading else { return }
        
        isReloading = true
        reloadTimer = stats(for: currentWeapon).reloadTime
    }
    
    func updateReload(deltaTime: TimeInterval) {
        guard isReloading else { return }
        
        reloadTimer -= deltaTime
        
        if reloadTimer <= 0 {
            completeReload()
        }
    }
    
    private func completeReload() {
        isReloading = false
        let stats = self.stats(for: currentWeapon)
        ammo[currentWeapon] = stats.ammoCapacity
    }
    
    // MARK: - Weapon Switching
    func switchTo(_ weapon: WeaponType) {
        currentWeapon = weapon
        isReloading = false
    }
    
    // MARK: - Special Weapons
    func canUseSpecial() -> Bool {
        // TODO: Implement special weapon system
        return false
    }
}
