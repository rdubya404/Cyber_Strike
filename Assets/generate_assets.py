#!/usr/bin/env python3
"""
Cyber Strike Art Asset Generator
Generates all art assets for the cyberpunk helicopter shooter game.
Style: Dark cyberpunk with neon accents (purple, cyan, pink)
"""

from PIL import Image, ImageDraw, ImageFilter, ImageEnhance
import math
import os

# Base resolution for iPhone Retina
BASE_SIZE = 64  # Base sprite size
SCALE_2X = 2
SCALE_3X = 3

# Cyberpunk color palette
COLORS = {
    'bg_dark': (10, 12, 20),
    'bg_mid': (20, 25, 40),
    'bg_light': (30, 40, 60),
    'neon_cyan': (0, 255, 255),
    'neon_pink': (255, 0, 128),
    'neon_purple': (180, 0, 255),
    'neon_green': (0, 255, 128),
    'neon_red': (255, 50, 50),
    'neon_yellow': (255, 220, 0),
    'metal_dark': (40, 45, 55),
    'metal_mid': (70, 75, 85),
    'metal_light': (120, 125, 135),
    'glass': (150, 200, 255, 180),
    'black': (0, 0, 0),
    'white': (255, 255, 255),
}

def save_scaled(image, base_path, name):
    """Save image at 1x, 2x, and 3x scales"""
    # 1x
    image.save(f"{base_path}/{name}.png")
    
    # 2x
    img_2x = image.resize((image.width * SCALE_2X, image.height * SCALE_2X), Image.NEAREST)
    img_2x.save(f"{base_path}/{name}@2x.png")
    
    # 3x
    img_3x = image.resize((image.width * SCALE_3X, image.height * SCALE_3X), Image.NEAREST)
    img_3x.save(f"{base_path}/{name}@3x.png")

def create_glow(draw, x, y, radius, color, intensity=0.5):
    """Create a glowing effect"""
    for i in range(radius, 0, -1):
        alpha = int(255 * intensity * (i / radius))
        glow_color = (*color[:3], alpha)
        draw.ellipse([x - i, y - i, x + i, y + i], fill=glow_color)

def draw_neon_line(draw, x1, y1, x2, y2, color, width=2):
    """Draw a line with neon glow effect"""
    # Outer glow
    glow_color = (*color[:3], 80)
    for offset in range(4, 1, -1):
        draw.line([x1, y1, x2, y2], fill=glow_color, width=width + offset*2)
    # Core line
    draw.line([x1, y1, x2, y2], fill=color, width=width)

# ==================== PLAYER HELICOPTER ====================

def create_player_helicopter():
    """Create player helicopter sprites"""
    base_path = "Player/Helicopter"
    os.makedirs(base_path, exist_ok=True)
    
    # Idle frame
    img = Image.new('RGBA', (64, 64), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    
    cx, cy = 32, 32
    
    # Main body - sleek angular design
    body_points = [
        (cx, cy - 20),      # nose
        (cx + 12, cy - 5),  # right shoulder
        (cx + 10, cy + 15), # right rear
        (cx, cy + 10),      # tail base
        (cx - 10, cy + 15), # left rear
        (cx - 12, cy - 5),  # left shoulder
    ]
    draw.polygon(body_points, fill=COLORS['metal_dark'], outline=COLORS['metal_mid'])
    
    # Cockpit
    cockpit_points = [
        (cx, cy - 12),
        (cx + 6, cy - 2),
        (cx, cy + 5),
        (cx - 6, cy - 2),
    ]
    draw.polygon(cockpit_points, fill=COLORS['glass'])
    
    # Main rotor
    rotor_y = cy - 22
    draw.line([cx - 28, rotor_y, cx + 28, rotor_y], fill=COLORS['metal_light'], width=3)
    draw.line([cx, rotor_y - 8, cx, rotor_y + 8], fill=COLORS['metal_light'], width=2)
    # Rotor hub glow
    draw.ellipse([cx - 3, rotor_y - 3, cx + 3, rotor_y + 3], fill=COLORS['neon_cyan'])
    
    # Tail rotor
    tail_x = cx
    tail_y = cy + 18
    draw.line([tail_x, tail_y - 8, tail_x, tail_y + 8], fill=COLORS['metal_mid'], width=2)
    draw.line([tail_x - 4, tail_y, tail_x + 4, tail_y], fill=COLORS['metal_mid'], width=2)
    
    # Side weapons/rockets
    draw.rectangle([cx - 18, cy + 2, cx - 14, cy + 12], fill=COLORS['metal_mid'], outline=COLORS['neon_cyan'])
    draw.rectangle([cx + 14, cy + 2, cx + 18, cy + 12], fill=COLORS['metal_mid'], outline=COLORS['neon_cyan'])
    
    # Neon accents
    draw.line([cx - 8, cy + 8, cx - 8, cy + 12], fill=COLORS['neon_cyan'], width=2)
    draw.line([cx + 8, cy + 8, cx + 8, cy + 12], fill=COLORS['neon_cyan'], width=2)
    draw.line([cx - 2, cy + 15, cx + 2, cy + 15], fill=COLORS['neon_pink'], width=2)
    
    # Engine glow
    draw.ellipse([cx - 4, cy + 16, cx + 4, cy + 22], fill=COLORS['neon_cyan'])
    
    save_scaled(img, base_path, "helicopter_idle")
    
    # Banking left
    img_left = img.copy()
    draw_l = ImageDraw.Draw(img_left)
    # Add tilt visual
    draw_l.polygon([(cx - 15, cy - 5), (cx - 20, cy), (cx - 15, cy + 5)], fill=COLORS['neon_cyan'])
    save_scaled(img_left, base_path, "helicopter_bank_left")
    
    # Banking right
    img_right = img.copy()
    draw_r = ImageDraw.Draw(img_right)
    draw_r.polygon([(cx + 15, cy - 5), (cx + 20, cy), (cx + 15, cy + 5)], fill=COLORS['neon_cyan'])
    save_scaled(img_right, base_path, "helicopter_bank_right")
    
    # Damaged state
    img_dmg = img.copy()
    draw_d = ImageDraw.Draw(img_dmg)
    # Add damage marks
    draw_d.line([cx - 10, cy - 10, cx - 5, cy - 5], fill=COLORS['neon_red'], width=2)
    draw_d.line([cx + 5, cy + 5, cx + 10, cy + 10], fill=COLORS['neon_red'], width=2)
    draw_d.ellipse([cx - 15, cy - 5, cx - 5, cy + 5], fill=(*COLORS['neon_red'][:3], 100))
    save_scaled(img_dmg, base_path, "helicopter_damaged")
    
    print(f"✓ Created player helicopter sprites in {base_path}")

def create_engine_effects():
    """Create engine exhaust/glow effects"""
    base_path = "Player/Effects"
    os.makedirs(base_path, exist_ok=True)
    
    # Engine exhaust frames for animation
    for i in range(4):
        img = Image.new('RGBA', (32, 32), (0, 0, 0, 0))
        draw = ImageDraw.Draw(img)
        
        cx, cy = 16, 8
        size = 6 + i * 2
        
        # Exhaust glow
        for r in range(size, 0, -1):
            alpha = int(200 * (r / size) * (1 - i * 0.15))
            color = (0, 255, 255, alpha) if i % 2 == 0 else (0, 200, 255, alpha)
            draw.ellipse([cx - r, cy + i*3, cx + r, cy + i*3 + r], fill=color)
        
        save_scaled(img, base_path, f"engine_exhaust_{i}")
    
    print(f"✓ Created engine effects in {base_path}")

# ==================== ENEMIES ====================

def create_enemy_helicopters():
    """Create enemy helicopter variants"""
    base_path = "Enemies/Helicopters"
    os.makedirs(base_path, exist_ok=True)
    
    # Light scout helicopter
    img = Image.new('RGBA', (48, 48), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    cx, cy = 24, 24
    
    # Smaller, faster design
    body = [(cx, cy - 12), (cx + 8, cy), (cx + 6, cy + 10), (cx, cy + 8), (cx - 6, cy + 10), (cx - 8, cy)]
    draw.polygon(body, fill=COLORS['metal_dark'], outline=COLORS['neon_red'])
    draw.ellipse([cx - 4, cy - 4, cx + 4, cy + 4], fill=COLORS['neon_red'])
    draw.line([cx - 20, cy - 10, cx + 20, cy - 10], fill=COLORS['metal_mid'], width=2)
    
    save_scaled(img, base_path, "enemy_scout")
    
    # Heavy gunship
    img2 = Image.new('RGBA', (64, 64), (0, 0, 0, 0))
    draw2 = ImageDraw.Draw(img2)
    cx, cy = 32, 32
    
    # Bulkier design
    body2 = [(cx, cy - 18), (cx + 15, cy - 5), (cx + 12, cy + 18), (cx, cy + 12), 
             (cx - 12, cy + 18), (cx - 15, cy - 5)]
    draw2.polygon(body2, fill=COLORS['metal_dark'], outline=COLORS['neon_purple'])
    
    # Heavy weapons
    draw2.rectangle([cx - 20, cy + 5, cx - 12, cy + 15], fill=COLORS['metal_mid'], outline=COLORS['neon_purple'])
    draw2.rectangle([cx + 12, cy + 5, cx + 20, cy + 15], fill=COLORS['metal_mid'], outline=COLORS['neon_purple'])
    
    # Rotor
    draw2.line([cx - 30, cy - 20, cx + 30, cy - 20], fill=COLORS['metal_light'], width=4)
    draw2.ellipse([cx - 5, cy - 23, cx + 5, cy - 17], fill=COLORS['neon_purple'])
    
    save_scaled(img2, base_path, "enemy_gunship")
    
    print(f"✓ Created enemy helicopters in {base_path}")

def create_enemy_tanks():
    """Create ground tank enemies"""
    base_path = "Enemies/Tanks"
    os.makedirs(base_path, exist_ok=True)
    
    img = Image.new('RGBA', (56, 48), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    cx, cy = 28, 28
    
    # Tank body
    draw.rectangle([cx - 20, cy - 8, cx + 20, cy + 12], fill=COLORS['metal_dark'], outline=COLORS['metal_mid'])
    
    # Turret
    draw.rectangle([cx - 10, cy - 15, cx + 10, cy - 5], fill=COLORS['metal_mid'], outline=COLORS['neon_red'])
    
    # Barrel
    draw.rectangle([cx - 3, cy - 28, cx + 3, cy - 15], fill=COLORS['metal_light'])
    
    # Tracks
    draw.rectangle([cx - 22, cy + 5, cx - 18, cy + 15], fill=COLORS['black'])
    draw.rectangle([cx + 18, cy + 5, cx + 22, cy + 15], fill=COLORS['black'])
    
    # Neon accents
    draw.line([cx - 15, cy, cx + 15, cy], fill=COLORS['neon_red'], width=2)
    
    save_scaled(img, base_path, "tank_basic")
    
    # Heavy tank
    img2 = Image.new('RGBA', (64, 56), (0, 0, 0, 0))
    draw2 = ImageDraw.Draw(img2)
    cx, cy = 32, 30
    
    draw2.rectangle([cx - 24, cy - 10, cx + 24, cy + 14], fill=COLORS['metal_dark'], outline=COLORS['neon_purple'])
    draw2.rectangle([cx - 12, cy - 18, cx + 12, cy - 6], fill=COLORS['metal_mid'], outline=COLORS['neon_purple'])
    draw2.rectangle([cx - 4, cy - 32, cx + 4, cy - 18], fill=COLORS['metal_light'])
    
    # Dual barrels
    draw2.rectangle([cx - 8, cy - 30, cx - 2, cy - 18], fill=COLORS['metal_light'])
    draw2.rectangle([cx + 2, cy - 30, cx + 8, cy - 18], fill=COLORS['metal_light'])
    
    save_scaled(img2, base_path, "tank_heavy")
    
    print(f"✓ Created enemy tanks in {base_path}")

def create_turrets():
    """Create anti-air turrets"""
    base_path = "Enemies/Turrets"
    os.makedirs(base_path, exist_ok=True)
    
    img = Image.new('RGBA', (48, 48), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    cx, cy = 24, 28
    
    # Base
    draw.rectangle([cx - 16, cy - 4, cx + 16, cy + 12], fill=COLORS['metal_dark'], outline=COLORS['metal_mid'])
    
    # Turret head
    draw.ellipse([cx - 10, cy - 14, cx + 10, cy + 6], fill=COLORS['metal_mid'], outline=COLORS['neon_cyan'])
    
    # Quad barrels
    for offset in [-6, -2, 2, 6]:
        draw.rectangle([cx + offset - 1, cy - 24, cx + offset + 1, cy - 14], fill=COLORS['metal_light'])
    
    # Glow
    draw.ellipse([cx - 4, cy - 8, cx + 4, cy], fill=COLORS['neon_cyan'])
    
    save_scaled(img, base_path, "turret_aa")
    
    print(f"✓ Created turrets in {base_path}")

def create_drones():
    """Create flying drone swarms"""
    base_path = "Enemies/Drones"
    os.makedirs(base_path, exist_ok=True)
    
    img = Image.new('RGBA', (24, 24), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    cx, cy = 12, 12
    
    # Small drone body
    draw.ellipse([cx - 6, cy - 6, cx + 6, cy + 6], fill=COLORS['metal_dark'], outline=COLORS['neon_pink'])
    
    # Rotors (X shape)
    draw.line([cx - 10, cy - 10, cx + 10, cy + 10], fill=COLORS['metal_mid'], width=2)
    draw.line([cx + 10, cy - 10, cx - 10, cy + 10], fill=COLORS['metal_mid'], width=2)
    
    # Center glow
    draw.ellipse([cx - 3, cy - 3, cx + 3, cy + 3], fill=COLORS['neon_pink'])
    
    save_scaled(img, base_path, "drone_small")
    
    print(f"✓ Created drones in {base_path}")

def create_boss():
    """Create boss gunship"""
    base_path = "Enemies/Boss"
    os.makedirs(base_path, exist_ok=True)
    
    img = Image.new('RGBA', (128, 128), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    cx, cy = 64, 64
    
    # Massive body
    body_points = [
        (cx, cy - 40),
        (cx + 30, cy - 20),
        (cx + 35, cy + 20),
        (cx + 20, cy + 40),
        (cx, cy + 35),
        (cx - 20, cy + 40),
        (cx - 35, cy + 20),
        (cx - 30, cy - 20),
    ]
    draw.polygon(body_points, fill=COLORS['metal_dark'], outline=COLORS['neon_purple'])
    
    # Inner detail
    inner_points = [
        (cx, cy - 25),
        (cx + 18, cy - 10),
        (cx + 20, cy + 15),
        (cx, cy + 25),
        (cx - 20, cy + 15),
        (cx - 18, cy - 10),
    ]
    draw.polygon(inner_points, fill=COLORS['metal_mid'], outline=COLORS['neon_pink'])
    
    # Main cannon
    draw.rectangle([cx - 6, cy - 60, cx + 6, cy - 40], fill=COLORS['metal_light'], outline=COLORS['neon_red'])
    
    # Side cannons
    draw.rectangle([cx - 30, cy - 30, cx - 22, cy - 10], fill=COLORS['metal_light'], outline=COLORS['neon_red'])
    draw.rectangle([cx + 22, cy - 30, cx + 30, cy - 10], fill=COLORS['metal_light'], outline=COLORS['neon_red'])
    
    # Main rotor
    draw.line([cx - 60, cy - 42, cx + 60, cy - 42], fill=COLORS['metal_light'], width=6)
    draw.line([cx, cy - 55, cx, cy - 30], fill=COLORS['metal_light'], width=4)
    draw.ellipse([cx - 8, cy - 46, cx + 8, cy - 38], fill=COLORS['neon_purple'])
    
    # Tail rotors
    draw.line([cx - 35, cy + 45, cx - 35, cy + 55], fill=COLORS['metal_mid'], width=3)
    draw.line([cx + 35, cy + 45, cx + 35, cy + 55], fill=COLORS['metal_mid'], width=3)
    
    # Weapon pods
    draw.rectangle([cx - 50, cy + 10, cx - 35, cy + 30], fill=COLORS['metal_dark'], outline=COLORS['neon_cyan'])
    draw.rectangle([cx + 35, cy + 10, cx + 50, cy + 30], fill=COLORS['metal_dark'], outline=COLORS['neon_cyan'])
    
    save_scaled(img, base_path, "boss_gunship")
    
    print(f"✓ Created boss in {base_path}")

# ==================== ENVIRONMENT ====================

def create_buildings():
    """Create cyberpunk city buildings"""
    base_path = "Environment/Buildings"
    os.makedirs(base_path, exist_ok=True)
    
    # Small building
    img = Image.new('RGBA', (64, 96), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    
    # Building body
    draw.rectangle([8, 16, 56, 88], fill=COLORS['bg_mid'], outline=COLORS['metal_dark'])
    
    # Windows with neon
    for y in range(24, 80, 12):
        for x in range(16, 48, 12):
            color = COLORS['neon_cyan'] if (x + y) % 24 == 0 else COLORS['bg_light']
            draw.rectangle([x, y, x + 6, y + 8], fill=color)
    
    # Roof details
    draw.rectangle([20, 8, 24, 16], fill=COLORS['metal_mid'])
    draw.rectangle([40, 10, 44, 16], fill=COLORS['metal_mid'])
    
    save_scaled(img, base_path, "building_small")
    
    # Tall building
    img2 = Image.new('RGBA', (80, 160), (0, 0, 0, 0))
    draw2 = ImageDraw.Draw(img2)
    
    draw2.rectangle([10, 20, 70, 150], fill=COLORS['bg_dark'], outline=COLORS['metal_dark'])
    
    # Vertical neon strip
    draw2.rectangle([36, 20, 44, 150], fill=COLORS['neon_pink'])
    
    # Windows
    for y in range(30, 140, 15):
        draw2.rectangle([18, y, 32, y + 10], fill=COLORS['neon_cyan'] if y % 30 == 0 else COLORS['bg_light'])
        draw2.rectangle([48, y, 62, y + 10], fill=COLORS['neon_purple'] if y % 45 == 0 else COLORS['bg_light'])
    
    save_scaled(img2, base_path, "building_tall")
    
    # Corporate tower
    img3 = Image.new('RGBA', (96, 192), (0, 0, 0, 0))
    draw3 = ImageDraw.Draw(img3)
    
    # Sleek tower
    draw3.rectangle([20, 10, 76, 180], fill=COLORS['bg_dark'], outline=COLORS['neon_cyan'])
    
    # Holographic ad space
    draw3.rectangle([24, 40, 72, 80], fill=(*COLORS['neon_purple'][:3], 100), outline=COLORS['neon_pink'])
    
    # Grid windows
    for y in range(100, 170, 12):
        for x in range(28, 68, 10):
            draw3.rectangle([x, y, x + 6, y + 8], fill=COLORS['neon_cyan'])
    
    save_scaled(img3, base_path, "building_corp")
    
    print(f"✓ Created buildings in {base_path}")

def create_roads():
    """Create road tiles"""
    base_path = "Environment/Roads"
    os.makedirs(base_path, exist_ok=True)
    
    # Straight road
    img = Image.new('RGBA', (64, 64), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    
    # Asphalt
    draw.rectangle([0, 0, 64, 64], fill=(25, 25, 30))
    
    # Lane markers (glowing)
    for y in range(8, 64, 16):
        draw.rectangle([30, y, 34, y + 8], fill=COLORS['neon_yellow'])
    
    save_scaled(img, base_path, "road_straight")
    
    # Intersection
    img2 = Image.new('RGBA', (64, 64), (0, 0, 0, 0))
    draw2 = ImageDraw.Draw(img2)
    
    draw2.rectangle([0, 0, 64, 64], fill=(25, 25, 30))
    
    # Crosswalk lines
    for i in range(4):
        draw2.rectangle([i * 16, 0, i * 16 + 8, 64], fill=(35, 35, 40))
        draw2.rectangle([0, i * 16, 64, i * 16 + 8], fill=(35, 35, 40))
    
    # Center glow
    draw2.ellipse([24, 24, 40, 40], fill=COLORS['neon_cyan'])
    
    save_scaled(img2, base_path, "road_intersection")
    
    print(f"✓ Created roads in {base_path}")

def create_rooftops():
    """Create rooftop details"""
    base_path = "Environment/Rooftops"
    os.makedirs(base_path, exist_ok=True)
    
    # AC Unit
    img = Image.new('RGBA', (32, 32), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    
    draw.rectangle([4, 8, 28, 24], fill=COLORS['metal_mid'], outline=COLORS['metal_light'])
    draw.line([8, 12, 24, 12], fill=COLORS['metal_dark'], width=2)
    draw.line([8, 16, 24, 16], fill=COLORS['metal_dark'], width=2)
    draw.line([8, 20, 24, 20], fill=COLORS['metal_dark'], width=2)
    
    save_scaled(img, base_path, "ac_unit")
    
    # Antenna
    img2 = Image.new('RGBA', (16, 48), (0, 0, 0, 0))
    draw2 = ImageDraw.Draw(img2)
    
    draw2.line([8, 8, 8, 40], fill=COLORS['metal_mid'], width=2)
    draw2.ellipse([4, 4, 12, 12], fill=COLORS['neon_red'])
    
    save_scaled(img2, base_path, "antenna")
    
    print(f"✓ Created rooftops in {base_path}")

def create_bridges():
    """Create bridge tiles"""
    base_path = "Environment/Bridges"
    os.makedirs(base_path, exist_ok=True)
    
    img = Image.new('RGBA', (128, 64), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    
    # Bridge deck
    draw.rectangle([0, 20, 128, 44], fill=COLORS['metal_dark'], outline=COLORS['metal_mid'])
    
    # Support cables
    for x in range(0, 129, 16):
        draw.line([x, 20, x + 8, 0], fill=COLORS['metal_mid'], width=1)
        draw.line([x, 44, x + 8, 64], fill=COLORS['metal_mid'], width=1)
    
    # Neon trim
    draw.line([0, 22, 128, 22], fill=COLORS['neon_cyan'], width=2)
    draw.line([0, 42, 128, 42], fill=COLORS['neon_cyan'], width=2)
    
    save_scaled(img, base_path, "bridge_section")
    
    print(f"✓ Created bridges in {base_path}")

def create_slums():
    """Create slums/industrial areas"""
    base_path = "Environment/Slums"
    os.makedirs(base_path, exist_ok=True)
    
    img = Image.new('RGBA', (64, 64), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    
    # Rundown building
    draw.rectangle([8, 16, 56, 56], fill=(40, 35, 30), outline=(60, 55, 50))
    
    # Broken windows
    draw.rectangle([16, 24, 26, 32], fill=(20, 20, 25))
    draw.rectangle([38, 28, 48, 36], fill=(20, 20, 25))
    draw.rectangle([20, 40, 30, 48], fill=(20, 20, 25))
    
    # Rust stains
    draw.line([10, 45, 20, 55], fill=(100, 60, 40), width=3)
    
    save_scaled(img, base_path, "slum_building")
    
    print(f"✓ Created slums in {base_path}")

# ==================== EFFECTS ====================

def create_muzzle_flashes():
    """Create muzzle flash effects"""
    base_path = "Effects/MuzzleFlashes"
    os.makedirs(base_path, exist_ok=True)
    
    # Machine gun flash
    for i in range(3):
        img = Image.new('RGBA', (32, 32), (0, 0, 0, 0))
        draw = ImageDraw.Draw(img)
        
        cx, cy = 8, 16
        length = 12 + i * 4
        
        # Flash rays
        for angle in range(0, 360, 45):
            rad = math.radians(angle)
            x2 = cx + int(length * math.cos(rad))
            y2 = cy + int(length * math.sin(rad))
            draw.line([cx, cy, x2, y2], fill=COLORS['neon_yellow'], width=2)
        
        # Core
        draw.ellipse([cx - 4, cy - 4, cx + 4, cy + 4], fill=COLORS['white'])
        
        save_scaled(img, base_path, f"muzzle_machinegun_{i}")
    
    # Missile launch flash
    img2 = Image.new('RGBA', (48, 48), (0, 0, 0, 0))
    draw2 = ImageDraw.Draw(img2)
    
    cx, cy = 16, 24
    
    # Large burst
    for r in range(20, 0, -3):
        alpha = int(200 * (r / 20))
        color = (255, 100, 50, alpha)
        draw2.ellipse([cx - r, cy - r, cx + r, cy + r], fill=color)
    
    draw2.ellipse([cx - 8, cy - 8, cx + 8, cy + 8], fill=COLORS['white'])
    
    save_scaled(img2, base_path, "muzzle_missile")
    
    print(f"✓ Created muzzle flashes in {base_path}")

def create_explosions():
    """Create explosion effects"""
    base_path = "Effects/Explosions"
    os.makedirs(base_path, exist_ok=True)
    
    sizes = [(32, 'small'), (64, 'medium'), (96, 'large')]
    
    for size, name in sizes:
        for frame in range(4):
            img = Image.new('RGBA', (size, size), (0, 0, 0, 0))
            draw = ImageDraw.Draw(img)
            
            cx, cy = size // 2, size // 2
            max_r = size // 2 - 4
            
            # Expanding rings
            r = max_r - frame * 4
            if r > 0:
                for ring in range(r, 0, -4):
                    alpha = int(255 * (ring / r) * (1 - frame * 0.2))
                    
                    # Fire colors
                    if ring > r * 0.6:
                        color = (255, 255, 200, alpha)  # White hot
                    elif ring > r * 0.3:
                        color = (255, 200, 50, alpha)   # Yellow
                    else:
                        color = (255, 100, 50, alpha)   # Orange
                    
                    draw.ellipse([cx - ring, cy - ring, cx + ring, cy + ring], fill=color)
            
            save_scaled(img, base_path, f"explosion_{name}_{frame}")
    
    print(f"✓ Created explosions in {base_path}")

def create_trails():
    """Create engine trails"""
    base_path = "Effects/Trails"
    os.makedirs(base_path, exist_ok=True)
    
    for i in range(4):
        img = Image.new('RGBA', (16, 32), (0, 0, 0, 0))
        draw = ImageDraw.Draw(img)
        
        # Fading trail
        for y in range(0, 32, 4):
            alpha = int(200 * (1 - y / 32) * (1 - i * 0.2))
            size = 4 - y // 8
            color = (0, 255, 255, alpha) if i % 2 == 0 else (100, 200, 255, alpha)
            draw.ellipse([8 - size, y, 8 + size, y + 4], fill=color)
        
        save_scaled(img, base_path, f"trail_{i}")
    
    print(f"✓ Created trails in {base_path}")

def create_bullets():
    """Create neon bullet trails"""
    base_path = "Effects/Bullets"
    os.makedirs(base_path, exist_ok=True)
    
    # Player bullet
    img = Image.new('RGBA', (16, 8), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    
    # Neon trail
    for x in range(4, 16):
        alpha = int(255 * (x - 4) / 12)
        draw.line([x, 4, x + 2, 4], fill=(0, 255, 255, alpha), width=2)
    
    # Head
    draw.ellipse([0, 2, 6, 6], fill=COLORS['neon_cyan'])
    
    save_scaled(img, base_path, "bullet_player")
    
    # Enemy bullet
    img2 = Image.new('RGBA', (16, 8), (0, 0, 0, 0))
    draw2 = ImageDraw.Draw(img2)
    
    for x in range(4, 16):
        alpha = int(255 * (x - 4) / 12)
        draw2.line([x, 4, x + 2, 4], fill=(255, 50, 50, alpha), width=2)
    
    draw2.ellipse([0, 2, 6, 6], fill=COLORS['neon_red'])
    
    save_scaled(img2, base_path, "bullet_enemy")
    
    # Missile
    img3 = Image.new('RGBA', (24, 12), (0, 0, 0, 0))
    draw3 = ImageDraw.Draw(img3)
    
    # Missile body
    draw3.rectangle([8, 4, 20, 8], fill=COLORS['metal_mid'], outline=COLORS['metal_light'])
    draw3.polygon([(20, 4), (24, 6), (20, 8)], fill=COLORS['neon_red'])
    
    # Trail
    for x in range(0, 8):
        alpha = int(200 * (1 - x / 8))
        draw3.ellipse([x, 5, x + 2, 7], fill=(255, 100, 50, alpha))
    
    save_scaled(img3, base_path, "bullet_missile")
    
    print(f"✓ Created bullets in {base_path}")

def create_shields():
    """Create shield/energy effects"""
    base_path = "Effects/Shields"
    os.makedirs(base_path, exist_ok=True)
    
    img = Image.new('RGBA', (64, 64), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    
    cx, cy = 32, 32
    
    # Shield bubble
    for r in range(30, 20, -2):
        alpha = int(100 * (30 - r) / 10)
        color = (0, 255, 255, alpha)
        draw.ellipse([cx - r, cy - r, cx + r, cy + r], outline=color, width=2)
    
    # Hexagon pattern overlay
    draw.polygon([
        (cx, cy - 25), (cx + 22, cy - 12), (cx + 22, cy + 12),
        (cx, cy + 25), (cx - 22, cy + 12), (cx - 22, cy - 12)
    ], outline=(*COLORS['neon_cyan'][:3], 150), width=2)
    
    save_scaled(img, base_path, "shield_energy")
    
    print(f"✓ Created shields in {base_path}")

def create_weather():
    """Create rain and weather effects"""
    base_path = "Effects/Weather"
    os.makedirs(base_path, exist_ok=True)
    
    # Rain overlay (tileable)
    img = Image.new('RGBA', (64, 64), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    
    for _ in range(30):
        import random
        x = random.randint(0, 64)
        y = random.randint(0, 64)
        length = random.randint(4, 8)
        draw.line([x, y, x - 2, y + length], fill=(150, 200, 255, 100), width=1)
    
    save_scaled(img, base_path, "rain_overlay")
    
    # Smoke
    img2 = Image.new('RGBA', (48, 48), (0, 0, 0, 0))
    draw2 = ImageDraw.Draw(img2)
    
    for r in range(20, 0, -3):
        alpha = int(150 * (r / 20))
        draw2.ellipse([24 - r, 24 - r, 24 + r, 24 + r], fill=(100, 100, 110, alpha))
    
    save_scaled(img2, base_path, "smoke")
    
    # Fire
    img3 = Image.new('RGBA', (32, 32), (0, 0, 0, 0))
    draw3 = ImageDraw.Draw(img3)
    
    for r in range(12, 0, -2):
        alpha = int(200 * (r / 12))
        color = (255, 100 + r * 10, 50, alpha)
        draw3.ellipse([16 - r, 16 - r, 16 + r, 16 + r], fill=color)
    
    save_scaled(img3, base_path, "fire")
    
    print(f"✓ Created weather effects in {base_path}")

# ==================== UI ====================

def create_hud():
    """Create HUD elements"""
    base_path = "UI/HUD"
    os.makedirs(base_path, exist_ok=True)
    
    # HUD frame corners
    img = Image.new('RGBA', (64, 64), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    
    # Corner piece
    draw.line([0, 16, 0, 0, 16, 0], fill=COLORS['neon_cyan'], width=3)
    draw.line([4, 16, 4, 4, 16, 4], fill=COLORS['neon_purple'], width=2)
    
    save_scaled(img, base_path, "hud_corner")
    
    # Health bar background
    img2 = Image.new('RGBA', (128, 24), (0, 0, 0, 0))
    draw2 = ImageDraw.Draw(img2)
    
    draw2.rectangle([0, 0, 128, 24], fill=(20, 20, 25, 200), outline=COLORS['metal_mid'])
    
    save_scaled(img2, base_path, "healthbar_bg")
    
    # Health bar fill
    img3 = Image.new('RGBA', (120, 16), (0, 0, 0, 0))
    draw3 = ImageDraw.Draw(img3)
    
    # Gradient from green to red
    for x in range(120):
        ratio = x / 120
        r = int(COLORS['neon_green'][0] * (1 - ratio) + COLORS['neon_red'][0] * ratio)
        g = int(COLORS['neon_green'][1] * (1 - ratio) + COLORS['neon_red'][1] * ratio)
        b = int(COLORS['neon_green'][2] * (1 - ratio) + COLORS['neon_red'][2] * ratio)
        draw3.line([x, 0, x, 16], fill=(r, g, b))
    
    save_scaled(img3, base_path, "healthbar_fill")
    
    print(f"✓ Created HUD in {base_path}")

def create_icons():
    """Create weapon and UI icons"""
    base_path = "UI/Icons"
    os.makedirs(base_path, exist_ok=True)
    
    # Machine gun icon
    img = Image.new('RGBA', (32, 32), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    
    draw.rectangle([8, 12, 24, 20], fill=COLORS['metal_mid'], outline=COLORS['neon_cyan'])
    draw.rectangle([20, 10, 26, 14], fill=COLORS['metal_light'])
    
    save_scaled(img, base_path, "icon_machinegun")
    
    # Missile icon
    img2 = Image.new('RGBA', (32, 32), (0, 0, 0, 0))
    draw2 = ImageDraw.Draw(img2)
    
    draw2.rectangle([10, 8, 18, 26], fill=COLORS['metal_mid'], outline=COLORS['neon_pink'])
    draw2.polygon([(14, 4), (18, 8), (10, 8)], fill=COLORS['neon_red'])
    
    save_scaled(img2, base_path, "icon_missile")
    
    # Health icon
    img3 = Image.new('RGBA', (32, 32), (0, 0, 0, 0))
    draw3 = ImageDraw.Draw(img3)
    
    # Simple cross/plus
    draw3.rectangle([12, 4, 20, 28], fill=COLORS['neon_green'])
    draw3.rectangle([4, 12, 28, 20], fill=COLORS['neon_green'])
    
    save_scaled(img3, base_path, "icon_health")
    
    print(f"✓ Created icons in {base_path}")

def create_buttons():
    """Create menu buttons"""
    base_path = "UI/Buttons"
    os.makedirs(base_path, exist_ok=True)
    
    # Button normal
    img = Image.new('RGBA', (128, 48), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    
    # Background
    draw.rectangle([0, 0, 128, 48], fill=(20, 25, 35, 220), outline=COLORS['neon_cyan'], width=2)
    
    # Corner accents
    draw.line([4, 12, 4, 4, 12, 4], fill=COLORS['neon_purple'], width=2)
    draw.line([116, 4, 124, 4, 124, 12], fill=COLORS['neon_purple'], width=2)
    draw.line([4, 36, 4, 44, 12, 44], fill=COLORS['neon_purple'], width=2)
    draw.line([116, 44, 124, 44, 124, 36], fill=COLORS['neon_purple'], width=2)
    
    save_scaled(img, base_path, "button_normal")
    
    # Button hover
    img2 = img.copy()
    draw2 = ImageDraw.Draw(img2)
    draw2.rectangle([2, 2, 126, 46], outline=COLORS['neon_pink'], width=2)
    
    save_scaled(img2, base_path, "button_hover")
    
    print(f"✓ Created buttons in {base_path}")

def create_minimap():
    """Create minimap graphics"""
    base_path = "UI"
    os.makedirs(base_path, exist_ok=True)
    
    # Minimap frame
    img = Image.new('RGBA', (96, 96), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    
    # Circular frame
    draw.ellipse([0, 0, 96, 96], fill=(15, 20, 30, 200), outline=COLORS['neon_cyan'], width=3)
    
    # Grid lines
    draw.line([48, 8, 48, 88], fill=(*COLORS['neon_cyan'][:3], 80), width=1)
    draw.line([8, 48, 88, 48], fill=(*COLORS['neon_cyan'][:3], 80), width=1)
    
    save_scaled(img, base_path, "minimap_frame")
    
    # Player blip
    img2 = Image.new('RGBA', (12, 12), (0, 0, 0, 0))
    draw2 = ImageDraw.Draw(img2)
    
    draw2.polygon([(6, 0), (12, 12), (6, 9), (0, 12)], fill=COLORS['neon_green'])
    
    save_scaled(img2, base_path, "minimap_player")
    
    # Enemy blip
    img3 = Image.new('RGBA', (10, 10), (0, 0, 0, 0))
    draw3 = ImageDraw.Draw(img3)
    
    draw3.rectangle([0, 0, 10, 10], fill=COLORS['neon_red'])
    
    save_scaled(img3, base_path, "minimap_enemy")
    
    print(f"✓ Created minimap in {base_path}")

# ==================== BACKGROUNDS ====================

def create_parallax():
    """Create parallax city layers"""
    base_path = "Backgrounds/Parallax"
    os.makedirs(base_path, exist_ok=True)
    
    # Distant skyline (silhouette)
    img = Image.new('RGBA', (256, 128), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    
    # Random building silhouettes
    import random
    random.seed(42)
    x = 0
    while x < 256:
        width = random.randint(20, 50)
        height = random.randint(40, 100)
        draw.rectangle([x, 128 - height, x + width, 128], fill=(15, 18, 28))
        x += width + random.randint(5, 15)
    
    save_scaled(img, base_path, "parallax_far")
    
    # Mid buildings
    img2 = Image.new('RGBA', (256, 160), (0, 0, 0, 0))
    draw2 = ImageDraw.Draw(img2)
    
    x = 0
    while x < 256:
        width = random.randint(30, 60)
        height = random.randint(60, 140)
        draw2.rectangle([x, 160 - height, x + width, 160], fill=(25, 30, 45))
        
        # Add some windows
        for wy in range(160 - height + 10, 150, 15):
            for wx in range(x + 5, x + width - 5, 10):
                if random.random() > 0.5:
                    draw2.rectangle([wx, wy, wx + 4, wy + 8], fill=COLORS['neon_cyan'])
        
        x += width + random.randint(10, 20)
    
    save_scaled(img2, base_path, "parallax_mid")
    
    # Foreground
    img3 = Image.new('RGBA', (256, 192), (0, 0, 0, 0))
    draw3 = ImageDraw.Draw(img3)
    
    x = 0
    while x < 256:
        width = random.randint(40, 80)
        height = random.randint(80, 180)
        draw3.rectangle([x, 192 - height, x + width, 192], fill=(35, 42, 58), outline=(50, 58, 75))
        
        # Neon signs
        if random.random() > 0.6:
            sign_y = 192 - height + 20
            draw3.rectangle([x + 10, sign_y, x + width - 10, sign_y + 15], 
                          fill=random.choice([COLORS['neon_pink'], COLORS['neon_purple'], COLORS['neon_cyan']]))
        
        x += width + random.randint(5, 15)
    
    save_scaled(img3, base_path, "parallax_near")
    
    print(f"✓ Created parallax layers in {base_path}")

def create_skies():
    """Create sky gradients"""
    base_path = "Backgrounds/Skies"
    os.makedirs(base_path, exist_ok=True)
    
    # Night sky
    img = Image.new('RGBA', (64, 256), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    
    for y in range(256):
        ratio = y / 256
        r = int(5 + ratio * 15)
        g = int(8 + ratio * 20)
        b = int(20 + ratio * 30)
        draw.line([0, y, 64, y], fill=(r, g, b))
    
    save_scaled(img, base_path, "sky_night")
    
    # Dusk sky
    img2 = Image.new('RGBA', (64, 256), (0, 0, 0, 0))
    draw2 = ImageDraw.Draw(img2)
    
    for y in range(256):
        ratio = y / 256
        r = int(40 + ratio * 60)
        g = int(20 + ratio * 30)
        b = int(60 + ratio * 40)
        draw2.line([0, y, 64, y], fill=(r, g, b))
    
    save_scaled(img2, base_path, "sky_dusk")
    
    # Storm sky
    img3 = Image.new('RGBA', (64, 256), (0, 0, 0, 0))
    draw3 = ImageDraw.Draw(img3)
    
    for y in range(256):
        ratio = y / 256
        r = int(15 + ratio * 25)
        g = int(18 + ratio * 27)
        b = int(25 + ratio * 35)
        draw3.line([0, y, 64, y], fill=(r, g, b))
    
    save_scaled(img3, base_path, "sky_storm")
    
    print(f"✓ Created skies in {base_path}")

def create_decorations():
    """Create flying cars and decorations"""
    base_path = "Backgrounds/Decorations"
    os.makedirs(base_path, exist_ok=True)
    
    # Flying car 1
    img = Image.new('RGBA', (32, 16), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    
    # Car body
    draw.ellipse([0, 4, 32, 12], fill=COLORS['metal_dark'], outline=COLORS['metal_mid'])
    # Cockpit
    draw.ellipse([8, 2, 24, 8], fill=COLORS['glass'])
    # Lights
    draw.ellipse([28, 5, 32, 9], fill=COLORS['neon_red'])
    draw.ellipse([0, 5, 4, 9], fill=COLORS['neon_cyan'])
    
    save_scaled(img, base_path, "flying_car_1")
    
    # Flying car 2
    img2 = Image.new('RGBA', (40, 20), (0, 0, 0, 0))
    draw2 = ImageDraw.Draw(img2)
    
    draw2.rectangle([4, 6, 36, 14], fill=COLORS['metal_dark'], outline=COLORS['metal_mid'])
    draw2.rectangle([12, 4, 28, 10], fill=COLORS['glass'])
    draw2.ellipse([36, 7, 40, 11], fill=COLORS['neon_pink'])
    draw2.ellipse([0, 7, 4, 11], fill=COLORS['neon_purple'])
    
    save_scaled(img2, base_path, "flying_car_2")
    
    # Cloud/Smog
    img3 = Image.new('RGBA', (128, 64), (0, 0, 0, 0))
    draw3 = ImageDraw.Draw(img3)
    
    for i in range(5):
        import random
        random.seed(i)
        x = random.randint(10, 100)
        y = random.randint(10, 50)
        r = random.randint(15, 30)
        draw3.ellipse([x - r, y - r, x + r, y + r], fill=(80, 85, 100, 60))
    
    save_scaled(img3, base_path, "smog_cloud")
    
    print(f"✓ Created decorations in {base_path}")

# ==================== MAIN ====================

def main():
    """Generate all art assets"""
    print("=" * 60)
    print("Cyber Strike Art Asset Generator")
    print("=" * 60)
    print()
    
    # Change to assets directory
    os.chdir('/root/.openclaw/workspace/Cyber_Strike/Assets')
    
    # Player
    create_player_helicopter()
    create_engine_effects()
    
    # Enemies
    create_enemy_helicopters()
    create_enemy_tanks()
    create_turrets()
    create_drones()
    create_boss()
    
    # Environment
    create_buildings()
    create_roads()
    create_rooftops()
    create_bridges()
    create_slums()
    
    # Effects
    create_muzzle_flashes()
    create_explosions()
    create_trails()
    create_bullets()
    create_shields()
    create_weather()
    
    # UI
    create_hud()
    create_icons()
    create_buttons()
    create_minimap()
    
    # Backgrounds
    create_parallax()
    create_skies()
    create_decorations()
    
    print()
    print("=" * 60)
    print("All assets generated successfully!")
    print("=" * 60)

if __name__ == "__main__":
    main()
