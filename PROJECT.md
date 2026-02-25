# Cyber Strike - Project Status

## Overview
A top-down cyberpunk helicopter shooter for iPhone using SpriteKit and Swift. Inspired by Jungle Strike/Desert Strike with a modern cyberpunk aesthetic.

**CRITICAL: All game assets use TRUE TOP-DOWN perspective (90 degree overhead view)** - like looking at miniatures on a game board. You see ROTOR DISCS from above (not side profiles), building ROOFS (not sides), and tank treads from above.

## Current Status

### Phase 1: Xcode Project Setup ✅
- [x] Create Xcode project structure
- [x] SpriteKit game template
- [x] Organized folder structure (Scenes, Entities, UI, Utils, etc.)
- [x] Project.pbxproj with all source files
- [x] Info.plist configuration
- [x] Storyboards (Main, LaunchScreen)

### Phase 2: Core Game Systems ✅
- [x] Top-down camera following the helicopter (CameraController.swift)
- [x] Physics-based helicopter movement with momentum and inertia (PlayerHelicopter.swift)
- [x] Dual-stick touch-based controls optimized for iPhone (InputManager.swift)
- [x] Weapon systems (machine guns, missiles, lasers) (WeaponSystem.swift)
- [x] Health/armor system (PlayerHelicopter.swift)
- [x] Fuel/energy management (PlayerHelicopter.swift)

### Phase 3: Game Entities ✅
- [x] Player helicopter class with cyberpunk futuristic design placeholder (PlayerHelicopter.swift)
- [x] Enemy classes (tanks, choppers, turrets, drones) (Enemy.swift)
- [x] Projectile classes (bullets, missiles, lasers) (Projectile.swift)
- [x] Power-up system (Projectile.swift - PowerUp class)
- [x] Destructible environment objects (LevelGenerator.swift)

### Phase 4: Level System ✅
- [x] Tile-based cyberpunk city generation (LevelGenerator.swift)
- [x] Chunk-based infinite level system
- [x] Parallax background layers (GameScene.swift)
- [x] Buildings with neon-lit windows
- [x] Roads with markings
- [x] Neon signs with flicker effects
- [x] Decorative elements (containers, etc.)

### Phase 5: Gameplay Features ✅
- [x] Enemy AI with patrol, chase, and attack behaviors (Enemy.swift)
- [x] Collision detection and damage system (GameScene.swift)
- [x] Power-ups and pickups (PowerUp class in Projectile.swift)
- [x] Mission objectives placeholder

### Phase 6: UI/HUD ✅
- [x] Health bar, ammo counter, minimap (HUD.swift)
- [x] Armor, fuel, and energy bars
- [x] Weapon selection display
- [x] Pause menu (HUD.swift)
- [x] Game over screen (HUD.swift)
- [x] Main menu with cyberpunk styling (MenuScene.swift)

### Phase 7: Art Assets ✅ (COMPLETED - TRUE TOP-DOWN PERSPECTIVE)
- [x] Player helicopter (top-down view with rotor disc visible)
- [x] Enemy helicopters (scout, gunship - top-down)
- [x] Tanks (basic, heavy - top-down with treads visible)
- [x] Turrets (anti-air - top-down)
- [x] Drones (quadcopter - top-down)
- [x] Boss gunship (large dual-rotor - top-down)
- [x] Buildings (roofs visible from above - small, tall, corp, slum)
- [x] Environment (roads, bridges, rooftop details)
- [x] Effects (explosions, muzzle flashes, bullets, trails)
- [x] UI elements (buttons, HUD, minimap, icons)
- [x] Backgrounds (parallax layers, skies)

### Phase 8: Polish ✅
- [x] Particle effects (explosions, engine trails, muzzle flash) (ParticleEffects.swift)
- [x] Screen shake on impacts (CameraController.swift)
- [x] Sound effect placeholders (AudioManager.swift)
- [x] Smooth 60fps performance architecture

## Project Structure
```
CyberStrike/
├── CyberStrike.xcodeproj/
│   └── project.pbxproj
├── CyberStrike/
│   ├── AppDelegate.swift
│   ├── SceneDelegate.swift
│   ├── GameViewController.swift
│   ├── Info.plist
│   ├── Base.lproj/
│   │   ├── Main.storyboard
│   │   └── LaunchScreen.storyboard
│   ├── Assets.xcassets/
│   ├── Scenes/
│   │   ├── GameScene.swift
│   │   └── MenuScene.swift
│   ├── Entities/
│   │   ├── PlayerHelicopter.swift
│   │   ├── Enemy.swift
│   │   └── Projectile.swift
│   ├── Systems/
│   │   ├── WeaponSystem.swift
│   │   ├── Physics.swift
│   │   ├── InputManager.swift
│   │   ├── CameraController.swift
│   │   ├── ParticleEffects.swift
│   │   └── LevelGenerator.swift
│   ├── UI/
│   │   └── HUD.swift
│   └── Utils/
│       ├── GameConstants.swift
│       └── AudioManager.swift
├── CyberStrikeTests/
├── CyberStrikeUITests/
└── Assets_TopDown/          <-- USE THESE ASSETS (TRUE TOP-DOWN)
    ├── Player/
    │   ├── Helicopter/      (helicopter_idle, bank_left, bank_right, damaged)
    │   └── Effects/         (engine_exhaust_0-3)
    ├── Enemies/
    │   ├── Helicopters/     (enemy_scout, enemy_gunship)
    │   ├── Tanks/           (tank_basic, tank_heavy)
    │   ├── Turrets/         (turret_aa)
    │   ├── Drones/          (drone_small)
    │   └── Boss/            (boss_gunship)
    ├── Environment/
    │   ├── Buildings/       (building_small, tall, corp, slum)
    │   ├── Roads/           (road_straight, intersection)
    │   ├── Bridges/         (bridge_section)
    │   ├── Rooftops/        (ac_unit, antenna)
    │   └── Slums/           (slum_building)
    ├── Effects/
    │   ├── Explosions/      (explosion_small/medium/large_0-3)
    │   ├── MuzzleFlashes/   (muzzle_machinegun/missile_0-2)
    │   ├── Bullets/         (bullet_player, enemy, missile)
    │   ├── Trails/          (trail_0-3)
    │   ├── Shields/         (shield_energy)
    │   └── Weather/         (smoke, fire, rain)
    ├── Backgrounds/
    │   ├── Parallax/        (parallax_far, mid, near)
    │   ├── Skies/           (sky_night, dusk, storm)
    │   └── Decorations/     (flying_car_1-2, smog_cloud)
    └── UI/
        ├── Buttons/         (button_normal, hover)
        ├── HUD/             (healthbar_bg/fill, hud_corner)
        ├── Icons/           (icon_health, missile, machinegun)
        ├── minimap_frame
        ├── minimap_player
        └── minimap_enemy
```

## Asset Locations

### ⚠️ IMPORTANT: Use Assets_TopDown/ folder
All game sprites are in `/root/.openclaw/workspace/Cyber_Strike/Assets_TopDown/`

These assets are designed with **TRUE TOP-DOWN perspective** (90 degree overhead):
- Helicopters show ROTOR DISCS (circles/ovals) from above, not side profiles
- Buildings show ROOFS, not sides
- Tanks show turrets and treads from above
- All assets include @1x, @2x, @3x versions for iPhone displays

### Old Assets (Deprecated)
The `/root/.openclaw/workspace/Cyber_Strike/Assets/` folder contains old side-view assets and should not be used.

## Key Features Implemented

### 1. Physics-Based Helicopter Movement
- Momentum and inertia system like Jungle Strike
- Smooth acceleration and friction
- Rotation independent of movement direction
- Recoil from weapon firing

### 2. Dual-Stick Controls
- Left joystick for movement
- Right joystick for aiming and firing
- Dynamic joystick positioning
- Visual feedback with color changes

### 3. Enemy AI
- State machine with idle, patrol, chase, and attack states
- Different behaviors for each enemy type:
  - Tanks: Slow, heavy armor, turret tracking
  - Choppers: Fast, strafing attacks
  - Turrets: Stationary, accurate tracking
  - Drones: Fast, swarm behavior

### 4. Weapon System
- Machine Gun: Fast fire rate, unlimited ammo
- Missiles: Homing capability, limited ammo
- Laser: Instant hit, high speed

### 5. Visual Effects
- Cyberpunk color scheme (neon cyan, pink, purple, green)
- Glowing effects on all interactive elements
- Animated neon signs with flicker
- Particle explosions with multiple layers
- Screen shake on impacts

### 6. Level Generation
- Chunk-based infinite world
- Procedural building placement
- Road networks
- Decorative elements

## Build Instructions
1. Open `CyberStrike.xcodeproj` in Xcode 15+
2. Select target device (iPhone/iPad)
3. Build and run (⌘+R)

## Next Steps
1. Sound assets needed:
   - Machine gun fire
   - Missile launch
   - Laser shot
   - Explosions
   - Engine sounds
   - UI sounds

2. Update code to reference Assets_TopDown/ folder

## Asset Updates

### 2026-02-25 - Background Assets Fixed (TRUE Top-Down Perspective)
**CRITICAL FIX**: Background parallax layers were regenerated to use TRUE top-down perspective.

**Problem**: Original parallax layers showed side-view city skylines with buildings rising from the bottom (like looking at a horizon). This was WRONG for a Desert Strike-style top-down game.

**Solution**: All background assets now use TRUE bird's eye view (90° overhead):
- **parallax_far.png**: Faint dark building silhouettes scattered across entire image (no horizon)
- **parallax_mid.png**: Closer buildings with rooftop details, viewed from above
- **parallax_near.png**: Closest buildings with neon glow edges on some rooftops
- **flying_car_1/2.png**: Small vehicle shapes seen from directly above
- **smog_cloud.png**: Fog patches viewed from above (not horizon clouds)

**Key Changes**:
- NO horizon lines
- NO "ground" at the bottom of images
- Buildings appear as rectangles/rooftops from above
- Parallax layers tile seamlessly in all directions
- All assets include @1x, @2x, @3x versions

### 2026-02-25 - All top-down art assets regenerated with TRUE top-down perspective (Desert Strike/Jungle Strike style)

## Last Updated
2026-02-25 - Background parallax layers fixed to TRUE top-down perspective
