# Cyber Strike - Art Asset Catalog

Complete art asset documentation for the cyberpunk helicopter shooter game.

## Color Palette

| Color | Hex | RGB | Usage |
|-------|-----|-----|-------|
| BG Dark | #0A0C14 | (10, 12, 20) | Background base |
| BG Mid | #141928 | (20, 25, 40) | Buildings, midground |
| BG Light | #1E283C | (30, 40, 60) | Lighter structures |
| Neon Cyan | #00FFFF | (0, 255, 255) | Player accents, UI |
| Neon Pink | #FF0080 | (255, 0, 128) | Enemy accents, warnings |
| Neon Purple | #B400FF | (180, 0, 255) | Boss, special enemies |
| Neon Green | #00FF80 | (0, 255, 128) | Health, friendly |
| Neon Red | #FF3232 | (255, 50, 50) | Damage, enemy fire |
| Neon Yellow | #FFDC00 | (255, 220, 0) | Road markers, pickups |
| Metal Dark | #282D37 | (40, 45, 55) | Vehicle bodies |
| Metal Mid | #464B55 | (70, 75, 85) | Details, turrets |
| Metal Light | #787D87 | (120, 125, 135) | Highlights |

## Directory Structure

```
Assets/
├── Player/
│   ├── Helicopter/
│   │   ├── helicopter_idle.png (+@2x, @3x)
│   │   ├── helicopter_bank_left.png (+@2x, @3x)
│   │   ├── helicopter_bank_right.png (+@2x, @3x)
│   │   └── helicopter_damaged.png (+@2x, @3x)
│   └── Effects/
│       ├── engine_exhaust_0-3.png (+@2x, @3x)
├── Enemies/
│   ├── Helicopters/
│   │   ├── enemy_scout.png (+@2x, @3x)
│   │   └── enemy_gunship.png (+@2x, @3x)
│   ├── Tanks/
│   │   ├── tank_basic.png (+@2x, @3x)
│   │   └── tank_heavy.png (+@2x, @3x)
│   ├── Turrets/
│   │   └── turret_aa.png (+@2x, @3x)
│   ├── Drones/
│   │   └── drone_small.png (+@2x, @3x)
│   └── Boss/
│       └── boss_gunship.png (+@2x, @3x)
├── Environment/
│   ├── Buildings/
│   │   ├── building_small.png (+@2x, @3x)
│   │   ├── building_tall.png (+@2x, @3x)
│   │   └── building_corp.png (+@2x, @3x)
│   ├── Roads/
│   │   ├── road_straight.png (+@2x, @3x)
│   │   └── road_intersection.png (+@2x, @3x)
│   ├── Rooftops/
│   │   ├── ac_unit.png (+@2x, @3x)
│   │   └── antenna.png (+@2x, @3x)
│   ├── Bridges/
│   │   └── bridge_section.png (+@2x, @3x)
│   └── Slums/
│       └── slum_building.png (+@2x, @3x)
├── Effects/
│   ├── MuzzleFlashes/
│   │   ├── muzzle_machinegun_0-2.png (+@2x, @3x)
│   │   └── muzzle_missile.png (+@2x, @3x)
│   ├── Explosions/
│   │   ├── explosion_small_0-3.png (+@2x, @3x)
│   │   ├── explosion_medium_0-3.png (+@2x, @3x)
│   │   └── explosion_large_0-3.png (+@2x, @3x)
│   ├── Trails/
│   │   └── trail_0-3.png (+@2x, @3x)
│   ├── Bullets/
│   │   ├── bullet_player.png (+@2x, @3x)
│   │   ├── bullet_enemy.png (+@2x, @3x)
│   │   └── bullet_missile.png (+@2x, @3x)
│   ├── Shields/
│   │   └── shield_energy.png (+@2x, @3x)
│   └── Weather/
│       ├── rain_overlay.png (+@2x, @3x)
│       ├── smoke.png (+@2x, @3x)
│       └── fire.png (+@2x, @3x)
├── UI/
│   ├── HUD/
│   │   ├── hud_corner.png (+@2x, @3x)
│   │   ├── healthbar_bg.png (+@2x, @3x)
│   │   └── healthbar_fill.png (+@2x, @3x)
│   ├── Icons/
│   │   ├── icon_machinegun.png (+@2x, @3x)
│   │   ├── icon_missile.png (+@2x, @3x)
│   │   └── icon_health.png (+@2x, @3x)
│   ├── Buttons/
│   │   ├── button_normal.png (+@2x, @3x)
│   │   └── button_hover.png (+@2x, @3x)
│   ├── minimap_frame.png (+@2x, @3x)
│   ├── minimap_player.png (+@2x, @3x)
│   └── minimap_enemy.png (+@2x, @3x)
└── Backgrounds/
    ├── Parallax/
    │   ├── parallax_far.png (+@2x, @3x)
    │   ├── parallax_mid.png (+@2x, @3x)
    │   └── parallax_near.png (+@2x, @3x)
    ├── Skies/
    │   ├── sky_night.png (+@2x, @3x)
    │   ├── sky_dusk.png (+@2x, @3x)
    │   └── sky_storm.png (+@2x, @3x)
    └── Decorations/
        ├── flying_car_1.png (+@2x, @3x)
        ├── flying_car_2.png (+@2x, @3x)
        └── smog_cloud.png (+@2x, @3x)
```

## Sprite Specifications

### Player Helicopter (64x64)
- **Idle**: Centered, rotors spinning
- **Bank Left/Right**: Visual tilt indicators
- **Damaged**: Scorch marks, smoke trails

### Enemy Units
| Unit | Size | Description |
|------|------|-------------|
| Scout | 48x48 | Fast, light, red neon |
| Gunship | 64x64 | Heavy armor, purple neon |
| Basic Tank | 56x48 | Ground unit, turret |
| Heavy Tank | 64x56 | Dual cannons |
| AA Turret | 48x48 | Stationary, quad barrels |
| Drone | 24x24 | Swarm unit, pink neon |
| Boss | 128x128 | Massive gunship |

### Animation Frames
- **Engine exhaust**: 4 frames (0-3)
- **Muzzle flash**: 3 frames for machine gun
- **Explosions**: 4 frames each (small, medium, large)
- **Trails**: 4 frames for engine trails

## Usage Notes

### Retina Display Support
All assets include @2x and @3x versions for:
- iPhone standard displays (@1x)
- iPhone Retina displays (@2x)
- iPhone Super Retina displays (@3x)

### Recommended Font (UI)
For bitmap font or system font fallback:
- **Primary**: Orbitron (sci-fi, geometric)
- **Secondary**: Rajdhani (technical, clean)
- **Fallback**: System bold sans-serif

### Parallax Scrolling Speeds
- **Far layer**: 0.1x player speed
- **Mid layer**: 0.3x player speed
- **Near layer**: 0.6x player speed

### Tile Sizes
- **Road tiles**: 64x64 (tileable)
- **Building tiles**: 64x96 to 96x192
- **Bridge sections**: 128x64

---

Total Assets: 213 PNG files
Generated: 2026-02-25
