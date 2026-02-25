#!/usr/bin/env python3
"""
Cyber Strike - Top-Down Asset Generator
Generates TRUE top-down view assets (90 degree overhead) like Desert Strike/Jungle Strike
"""

from PIL import Image, ImageDraw
import math
import os

# Cyberpunk color palette
COLORS = {
    'bg': (15, 15, 25),           # Deep dark blue-black
    'bg_light': (25, 25, 40),     # Slightly lighter bg
    'cyan': (0, 255, 255),        # Neon cyan
    'cyan_dark': (0, 180, 200),   # Darker cyan
    'pink': (255, 0, 128),        # Hot pink
    'pink_dark': (200, 0, 100),   # Darker pink
    'purple': (180, 0, 255),      # Purple
    'purple_dark': (120, 0, 180), # Dark purple
    'green': (0, 255, 100),       # Neon green
    'yellow': (255, 220, 0),      # Yellow
    'orange': (255, 140, 0),      # Orange
    'red': (255, 50, 50),         # Red
    'red_dark': (180, 30, 30),    # Dark red
    'white': (255, 255, 255),     # White
    'gray': (120, 120, 130),      # Gray
    'gray_dark': (60, 60, 70),    # Dark gray
    'gray_light': (180, 180, 190),# Light gray
    'building': (40, 45, 60),     # Building base
    'building_dark': (25, 30, 45),# Dark building
    'window': (100, 220, 255),    # Lit window
    'window_dark': (40, 50, 70),  # Unlit window
    'metal': (80, 85, 95),        # Metal
    'metal_dark': (50, 55, 65),   # Dark metal
}

def create_image(size, bg_color=None):
    """Create a new image with transparent background"""
    if bg_color is None:
        return Image.new('RGBA', size, (0, 0, 0, 0))
    return Image.new('RGBA', size, bg_color)

def draw_glow_circle(draw, center, radius, color, glow_radius):
    """Draw a circle with glow effect"""
    cx, cy = center
    # Glow layers
    for i in range(glow_radius, 0, -2):
        alpha = int(30 * (1 - i / glow_radius))
        glow_color = (*color[:3], alpha)
        draw.ellipse([cx-radius-i, cy-radius-i, cx+radius+i, cy+radius+i], fill=glow_color)
    # Core
    draw.ellipse([cx-radius, cy-radius, cx+radius, cy+radius], fill=color)

def draw_rotor_disc(draw, center, radius, color):
    """Draw a helicopter rotor disc from top-down view (oval/circle)"""
    cx, cy = center
    # Rotor disc is slightly oval when viewed from above due to perspective
    # Main rotor disc
    for i in range(8, 0, -1):
        alpha = int(40 - i * 4)
        glow_color = (*color[:3], alpha)
        draw.ellipse([cx-radius-i, cy-radius//2-i, cx+radius+i, cy+radius//2+i], fill=glow_color)
    # Core disc
    draw.ellipse([cx-radius, cy-radius//2, cx+radius, cy+radius//2], fill=(*color[:3], 60))
    # Rotor hub
    draw.ellipse([cx-4, cy-4, cx+4, cy+4], fill=COLORS['gray'])

def draw_helicopter_topdown(size, base_color, accent_color, state='idle'):
    """
    Draw a helicopter from TRUE top-down view (90 degree overhead)
    Like Desert Strike/Jungle Strike - you see the ROTOR DISC from above
    """
    img = create_image(size)
    draw = ImageDraw.Draw(img)
    cx, cy = size[0] // 2, size[1] // 2
    
    # Banking tilt effect (slight rotation of visual elements)
    tilt_x = 0
    if state == 'bank_left':
        tilt_x = -3
    elif state == 'bank_right':
        tilt_x = 3
    
    # Main rotor disc (seen as oval/circle from above)
    rotor_color = accent_color
    draw_rotor_disc(draw, (cx + tilt_x, cy - 8), 28, rotor_color)
    
    # Tail boom (extends backward from center)
    tail_points = [
        (cx - 4 + tilt_x, cy + 5),
        (cx + 4 + tilt_x, cy + 5),
        (cx + 3 + tilt_x//2, cy + 35),
        (cx - 3 + tilt_x//2, cy + 35),
    ]
    draw.polygon(tail_points, fill=base_color, outline=COLORS['gray_dark'])
    
    # Tail rotor (seen as small circle/oval from above)
    draw.ellipse([cx-6+tilt_x//2, cy+32, cx+6+tilt_x//2, cy+40], fill=COLORS['gray'])
    draw.ellipse([cx-3+tilt_x//2, cy+34, cx+3+tilt_x//2, cy+38], fill=COLORS['gray_light'])
    
    # Main fuselage (seen from above - elongated shape)
    body_points = [
        (cx - 12 + tilt_x, cy - 15),  # Nose left
        (cx + 12 + tilt_x, cy - 15),  # Nose right
        (cx + 14 + tilt_x, cy + 5),   # Mid right
        (cx + 8 + tilt_x//2, cy + 20), # Tail connection right
        (cx - 8 + tilt_x//2, cy + 20), # Tail connection left
        (cx - 14 + tilt_x, cy + 5),   # Mid left
    ]
    draw.polygon(body_points, fill=base_color, outline=accent_color)
    
    # Cockpit (glass canopy seen from above)
    draw.ellipse([cx-8+tilt_x, cy-12, cx+8+tilt_x, cy+2], fill=COLORS['cyan_dark'])
    draw.ellipse([cx-6+tilt_x, cy-10, cx+6+tilt_x, cy], fill=COLORS['cyan'])
    
    # Engine/exhaust area
    draw.rectangle([cx-6+tilt_x, cy+5, cx+6+tilt_x, cy+12], fill=COLORS['metal_dark'])
    # Engine glow
    if state != 'damaged':
        draw_glow_circle(draw, (cx+tilt_x, cy+8), 3, accent_color, 6)
    else:
        # Damaged - flickering red
        draw_glow_circle(draw, (cx+tilt_x, cy+8), 3, COLORS['red'], 4)
    
    # Landing skids (seen as lines underneath)
    skid_y1, skid_y2 = cy + 15, cy + 18
    # Left skid
    draw.line([(cx-12+tilt_x, skid_y1), (cx-8+tilt_x//2, skid_y2)], fill=COLORS['metal'], width=2)
    draw.line([(cx-8+tilt_x//2, skid_y2), (cx+2+tilt_x//2, skid_y2)], fill=COLORS['metal'], width=2)
    # Right skid
    draw.line([(cx+12+tilt_x, skid_y1), (cx+8+tilt_x//2, skid_y2)], fill=COLORS['metal'], width=2)
    draw.line([(cx+8+tilt_x//2, skid_y2), (cx-2+tilt_x//2, skid_y2)], fill=COLORS['metal'], width=2)
    
    # Weapon mounts
    draw.rectangle([cx-16+tilt_x, cy-2, cx-12+tilt_x, cy+6], fill=COLORS['metal_dark'])
    draw.rectangle([cx+12+tilt_x, cy-2, cx+16+tilt_x, cy+6], fill=COLORS['metal_dark'])
    
    # Detail lines
    draw.line([(cx+tilt_x, cy-10), (cx+tilt_x, cy+15)], fill=accent_color, width=1)
    
    # Damage marks if damaged
    if state == 'damaged':
        draw.line([(cx-8+tilt_x, cy-5), (cx-2+tilt_x, cy+5)], fill=COLORS['red'], width=2)
        draw.line([(cx+5+tilt_x, cy-8), (cx+10+tilt_x, cy-2)], fill=COLORS['red'], width=2)
        draw.ellipse([cx-3+tilt_x, cy+10, cx+3+tilt_x, cy+16], fill=COLORS['orange'])
    
    return img

def draw_tank_topdown(size, tank_type='basic'):
    """Draw a tank from TRUE top-down view"""
    img = create_image(size)
    draw = ImageDraw.Draw(img)
    cx, cy = size[0] // 2, size[1] // 2
    
    if tank_type == 'basic':
        body_color = COLORS['gray_dark']
        turret_color = COLORS['gray']
        accent = COLORS['red']
    else:  # heavy
        body_color = COLORS['building_dark']
        turret_color = COLORS['metal_dark']
        accent = COLORS['orange']
    
    # Tank body (rectangle from above)
    body_w, body_h = 28, 36
    draw.rectangle([cx-body_w//2, cy-body_h//2, cx+body_w//2, cy+body_h//2], 
                   fill=body_color, outline=COLORS['gray'])
    
    # Treads (visible as tracks on sides)
    tread_w = 4
    # Left tread
    draw.rectangle([cx-body_w//2-2, cy-body_h//2, cx-body_w//2+tread_w, cy+body_h//2],
                   fill=COLORS['metal_dark'], outline=COLORS['gray'])
    # Right tread
    draw.rectangle([cx+body_w//2-tread_w, cy-body_h//2, cx+body_w//2+2, cy+body_h//2],
                   fill=COLORS['metal_dark'], outline=COLORS['gray'])
    
    # Tread details (lines)
    for i in range(-14, 15, 4):
        draw.line([(cx-body_w//2-2, cy+i), (cx-body_w//2+tread_w, cy+i)], fill=COLORS['gray'], width=1)
        draw.line([(cx+body_w//2-tread_w, cy+i), (cx+body_w//2+2, cy+i)], fill=COLORS['gray'], width=1)
    
    # Turret (seen as rectangle/circle from above)
    turret_size = 14 if tank_type == 'basic' else 18
    draw.ellipse([cx-turret_size, cy-turret_size, cx+turret_size, cy+turret_size],
                 fill=turret_color, outline=accent)
    
    # Gun barrel (pointing up/north in default orientation)
    barrel_w = 4 if tank_type == 'basic' else 6
    barrel_l = 16 if tank_type == 'basic' else 22
    draw.rectangle([cx-barrel_w//2, cy-turret_size-barrel_l, cx+barrel_w//2, cy-turret_size],
                   fill=COLORS['metal'], outline=COLORS['gray_dark'])
    
    # Barrel tip glow
    draw.rectangle([cx-2, cy-turret_size-barrel_l-3, cx+2, cy-turret_size-barrel_l],
                   fill=accent)
    
    # Turret details
    draw.ellipse([cx-6, cy-6, cx+6, cy+6], fill=COLORS['metal_dark'])
    draw.ellipse([cx-3, cy-3, cx+3, cy+3], fill=accent)
    
    # Heavy tank extra details
    if tank_type == 'heavy':
        # Extra armor plates
        draw.rectangle([cx-10, cy+5, cx+10, cy+12], fill=COLORS['metal_dark'], outline=COLORS['gray'])
        # Second smaller gun
        draw.rectangle([cx+8, cy-5, cx+14, cy-2], fill=COLORS['metal'], outline=COLORS['gray_dark'])
    
    return img

def draw_turret_topdown(size):
    """Draw anti-air turret from top-down view"""
    img = create_image(size)
    draw = ImageDraw.Draw(img)
    cx, cy = size[0] // 2, size[1] // 2
    
    # Base (circular platform)
    base_r = 22
    draw.ellipse([cx-base_r, cy-base_r, cx+base_r, cy+base_r],
                 fill=COLORS['metal_dark'], outline=COLORS['gray'])
    
    # Inner base detail
    draw.ellipse([cx-base_r+4, cy-base_r+4, cx+base_r-4, cy+base_r-4],
                 fill=COLORS['building_dark'], outline=COLORS['gray_dark'])
    
    # Rotating mount (cross shape from above)
    mount_w = 8
    mount_l = 18
    # Horizontal bar
    draw.rectangle([cx-mount_l, cy-mount_w//2, cx+mount_l, cy+mount_w//2],
                   fill=COLORS['metal'], outline=COLORS['cyan'])
    # Vertical bar
    draw.rectangle([cx-mount_w//2, cy-mount_l, cx+mount_w//2, cy+mount_l],
                   fill=COLORS['metal'], outline=COLORS['cyan'])
    
    # Center hub
    draw.ellipse([cx-8, cy-8, cx+8, cy+8], fill=COLORS['gray_dark'], outline=COLORS['cyan'])
    draw.ellipse([cx-4, cy-4, cx+4, cy+4], fill=COLORS['cyan'])
    
    # Gun barrels (4 directions)
    barrel_l = 14
    barrel_w = 3
    for angle in [0, 90, 180, 270]:
        rad = math.radians(angle)
        x1 = cx + math.cos(rad) * 8
        y1 = cy + math.sin(rad) * 8
        x2 = cx + math.cos(rad) * (8 + barrel_l)
        y2 = cy + math.sin(rad) * (8 + barrel_l)
        
        # Draw barrel
        bx = (x1 + x2) / 2
        by = (y1 + y2) / 2
        draw.line([(x1, y1), (x2, y2)], fill=COLORS['metal'], width=barrel_w)
        # Barrel tip
        draw.ellipse([x2-3, y2-3, x2+3, y2+3], fill=COLORS['red'])
    
    return img

def draw_drone_topdown(size):
    """Draw small quadcopter drone from top-down"""
    img = create_image(size)
    draw = ImageDraw.Draw(img)
    cx, cy = size[0] // 2, size[1] // 2
    
    # Drone body (small circle)
    body_r = 6
    draw.ellipse([cx-body_r, cy-body_r, cx+body_r, cy+body_r],
                 fill=COLORS['gray_dark'], outline=COLORS['pink'])
    
    # Center glow
    draw.ellipse([cx-3, cy-3, cx+3, cy+3], fill=COLORS['pink'])
    
    # Four arms extending to rotors
    arm_l = 12
    rotor_positions = [
        (cx - arm_l, cy - arm_l),
        (cx + arm_l, cy - arm_l),
        (cx - arm_l, cy + arm_l),
        (cx + arm_l, cy + arm_l),
    ]
    
    # Draw arms
    for rx, ry in rotor_positions:
        draw.line([(cx, cy), (rx, ry)], fill=COLORS['gray'], width=2)
    
    # Rotors (small circles)
    for rx, ry in rotor_positions:
        # Rotor disc
        draw.ellipse([rx-5, ry-5, rx+5, ry+5], fill=(*COLORS['pink'][:3], 80))
        # Rotor center
        draw.ellipse([rx-2, ry-2, rx+2, ry+2], fill=COLORS['pink'])
    
    return img

def draw_boss_gunship_topdown(size):
    """Draw large boss gunship from top-down"""
    img = create_image(size)
    draw = ImageDraw.Draw(img)
    cx, cy = size[0] // 2, size[1] // 2
    
    # Dual rotor system - two large rotor discs
    # Left rotor
    draw_rotor_disc(draw, (cx-25, cy-10), 22, COLORS['red'])
    # Right rotor
    draw_rotor_disc(draw, (cx+25, cy-10), 22, COLORS['red'])
    
    # Main body (large, bulky)
    body_points = [
        (cx - 35, cy - 20),
        (cx + 35, cy - 20),
        (cx + 40, cy + 10),
        (cx + 30, cy + 40),
        (cx - 30, cy + 40),
        (cx - 40, cy + 10),
    ]
    draw.polygon(body_points, fill=COLORS['building_dark'], outline=COLORS['red'])
    
    # Central fuselage
    draw.ellipse([cx-15, cy-15, cx+15, cy+25], fill=COLORS['metal_dark'], outline=COLORS['red'])
    
    # Cockpit
    draw.ellipse([cx-10, cy-10, cx+10, cy+8], fill=COLORS['red_dark'])
    draw.ellipse([cx-6, cy-6, cx+6, cy+4], fill=COLORS['red'])
    
    # Weapon pods (left and right)
    for offset in [-28, 28]:
        draw.rectangle([cx+offset-8, cy+5, cx+offset+8, cy+25],
                       fill=COLORS['metal_dark'], outline=COLORS['orange'])
        # Missile tubes
        for i in range(3):
            tube_y = cy + 8 + i * 5
            draw.ellipse([cx+offset-4, tube_y-2, cx+offset+4, tube_y+2],
                        fill=COLORS['orange'])
    
    # Tail section
    tail_points = [
        (cx - 20, cy + 35),
        (cx + 20, cy + 35),
        (cx + 15, cy + 55),
        (cx - 15, cy + 55),
    ]
    draw.polygon(tail_points, fill=COLORS['metal_dark'], outline=COLORS['red'])
    
    # Tail rotors
    draw.ellipse([cx-20, cy+50, cx-10, cy+60], fill=COLORS['gray'])
    draw.ellipse([cx+10, cy+50, cx+20, cy+60], fill=COLORS['gray'])
    
    # Engine exhausts (multiple)
    for offset in [-15, 0, 15]:
        draw_glow_circle(draw, (cx+offset, cy+30), 4, COLORS['orange'], 8)
    
    return img

def draw_building_topdown(size, building_type='small'):
    """Draw building roof from top-down view"""
    img = create_image(size)
    draw = ImageDraw.Draw(img)
    cx, cy = size[0] // 2, size[1] // 2
    
    if building_type == 'small':
        w, h = 50, 50
        roof_color = COLORS['building']
        window_color = COLORS['window']
    elif building_type == 'tall':
        w, h = 60, 60
        roof_color = COLORS['building_dark']
        window_color = COLORS['cyan']
    elif building_type == 'corp':
        w, h = 70, 70
        roof_color = COLORS['metal_dark']
        window_color = COLORS['purple']
    else:  # slum
        w, h = 55, 45
        roof_color = COLORS['gray_dark']
        window_color = COLORS['yellow']
    
    # Main roof
    if building_type == 'slum':
        # Irregular shape for slum
        points = [
            (cx - w//2, cy - h//2),
            (cx + w//2 - 5, cy - h//2 + 3),
            (cx + w//2, cy + h//2 - 5),
            (cx - w//2 + 8, cy + h//2),
        ]
        draw.polygon(points, fill=roof_color, outline=COLORS['gray'])
    else:
        draw.rectangle([cx-w//2, cy-h//2, cx+w//2, cy+h//2],
                       fill=roof_color, outline=COLORS['gray'])
    
    # Roof details based on type
    if building_type == 'small':
        # AC unit
        draw.rectangle([cx-8, cy-8, cx+8, cy+8], fill=COLORS['metal_dark'])
        draw.rectangle([cx-6, cy-10, cx+6, cy-8], fill=COLORS['gray'])
        # Vent
        draw.rectangle([cx-15, cy+10, cx-5, cy+18], fill=COLORS['gray_dark'])
        
    elif building_type == 'tall':
        # Multiple AC units
        draw.rectangle([cx-20, cy-20, cx-5, cy-5], fill=COLORS['metal_dark'])
        draw.rectangle([cx+5, cy-20, cx+20, cy-5], fill=COLORS['metal_dark'])
        # Antenna
        draw.line([(cx, cy-30), (cx, cy-h//2)], fill=COLORS['gray'], width=2)
        draw.ellipse([cx-3, cy-33, cx+3, cy-27], fill=COLORS['red'])
        # Helipad marking (H)
        draw.line([(cx-8, cy+10), (cx-8, cy+25)], fill=COLORS['yellow'], width=3)
        draw.line([(cx+8, cy+10), (cx+8, cy+25)], fill=COLORS['yellow'], width=3)
        draw.line([(cx-8, cy+17), (cx+8, cy+17)], fill=COLORS['yellow'], width=3)
        
    elif building_type == 'corp':
        # Helipad circle
        draw.ellipse([cx-15, cy-15, cx+15, cy+15], outline=COLORS['yellow'], width=2)
        draw.line([(cx-8, cy), (cx+8, cy)], fill=COLORS['yellow'], width=2)
        draw.line([(cx, cy-8), (cx, cy+8)], fill=COLORS['yellow'], width=2)
        # Communication array
        for angle in [0, 72, 144, 216, 288]:
            rad = math.radians(angle)
            x = cx + math.cos(rad) * 20
            y = cy + math.sin(rad) * 20
            draw.line([(cx, cy), (x, y)], fill=COLORS['gray'], width=1)
            draw.ellipse([x-2, y-2, x+2, y+2], fill=COLORS['red'])
        # Satellite dish
        draw.ellipse([cx+15, cy-25, cx+25, cy-15], fill=COLORS['metal'])
        draw.line([(cx+20, cy-20), (cx+20, cy-30)], fill=COLORS['gray'], width=2)
        
    else:  # slum
        # Random junk on roof
        draw.rectangle([cx-10, cy-5, cx-2, cy+5], fill=COLORS['gray'])
        draw.rectangle([cx+5, cy-10, cx+15, cy-2], fill=COLORS['metal_dark'])
        # Pipes
        draw.line([(cx-w//2+5, cy-h//2+10), (cx+w//2-10, cy+h//2-5)], 
                  fill=COLORS['gray_dark'], width=3)
    
    # Edge glow for cyberpunk feel
    if building_type in ['tall', 'corp']:
        draw.rectangle([cx-w//2, cy-h//2, cx-w//2+2, cy+h//2], fill=window_color)
        draw.rectangle([cx+w//2-2, cy-h//2, cx+w//2, cy+h//2], fill=window_color)
    
    return img

def draw_road_topdown(size, road_type='straight'):
    """Draw road from top-down view"""
    img = create_image(size)
    draw = ImageDraw.Draw(img)
    cx, cy = size[0] // 2, size[1] // 2
    
    # Road base
    road_color = (35, 35, 45)
    line_color = COLORS['yellow']
    
    if road_type == 'straight':
        # Road surface
        draw.rectangle([cx-20, 0, cx+20, size[1]], fill=road_color)
        # Center line
        for y in range(0, size[1], 20):
            draw.rectangle([cx-2, y, cx+2, y+10], fill=line_color)
        # Edge lines
        draw.line([(cx-20, 0), (cx-20, size[1])], fill=COLORS['white'], width=1)
        draw.line([(cx+20, 0), (cx+20, size[1])], fill=COLORS['white'], width=1)
        
    elif road_type == 'intersection':
        # Cross roads
        draw.rectangle([cx-20, 0, cx+20, size[1]], fill=road_color)
        draw.rectangle([0, cy-20, size[0], cy+20], fill=road_color)
        # Center
        draw.ellipse([cx-5, cy-5, cx+5, cy+5], fill=COLORS['yellow'])
    
    return img

def draw_bridge_topdown(size):
    """Draw bridge from top-down view"""
    img = create_image(size)
    draw = ImageDraw.Draw(img)
    cx, cy = size[0] // 2, size[1] // 2
    
    # Bridge deck (narrower than road)
    draw.rectangle([cx-12, 0, cx+12, size[1]], fill=COLORS['metal_dark'])
    
    # Support beams visible from above
    for y in range(20, size[1], 40):
        draw.line([(cx-15, y), (cx-12, y)], fill=COLORS['gray'], width=2)
        draw.line([(cx+12, y), (cx+15, y)], fill=COLORS['gray'], width=2)
    
    # Center line
    for y in range(0, size[1], 15):
        draw.rectangle([cx-1, y, cx+1, y+7], fill=COLORS['yellow'])
    
    return img

def draw_rooftop_detail(size, detail_type='ac_unit'):
    """Draw rooftop details from top-down"""
    img = create_image(size)
    draw = ImageDraw.Draw(img)
    cx, cy = size[0] // 2, size[1] // 2
    
    if detail_type == 'ac_unit':
        # AC unit box
        draw.rectangle([cx-10, cy-8, cx+10, cy+8], fill=COLORS['metal_dark'], outline=COLORS['gray'])
        # Fan visible from above
        draw.ellipse([cx-6, cy-4, cx+6, cy+4], fill=COLORS['gray'])
        draw.line([(cx-6, cy), (cx+6, cy)], fill=COLORS['metal'], width=1)
        draw.line([(cx, cy-4), (cx, cy+4)], fill=COLORS['metal'], width=1)
        # Vent pipe
        draw.rectangle([cx-3, cy-12, cx+3, cy-8], fill=COLORS['gray'])
        
    elif detail_type == 'antenna':
        # Base
        draw.rectangle([cx-4, cy-4, cx+4, cy+4], fill=COLORS['metal_dark'])
        # Mast
        draw.line([(cx, cy), (cx, cy-25)], fill=COLORS['gray'], width=2)
        # Antenna elements
        for y in [cy-8, cy-15, cy-22]:
            draw.line([(cx-6, y), (cx+6, y)], fill=COLORS['gray'], width=1)
        # Tip light
        draw.ellipse([cx-2, cy-27, cx+2, cy-23], fill=COLORS['red'])
    
    return img

def draw_explosion_topdown(size, explosion_type='small'):
    """Draw explosion from top-down (circular burst)"""
    img = create_image(size)
    draw = ImageDraw.Draw(img)
    cx, cy = size[0] // 2, size[1] // 2
    
    if explosion_type == 'small':
        max_r = 15
        colors = [COLORS['white'], COLORS['yellow'], COLORS['orange'], COLORS['red']]
    elif explosion_type == 'medium':
        max_r = 25
        colors = [COLORS['white'], COLORS['yellow'], COLORS['orange'], COLORS['red'], COLORS['red_dark']]
    else:  # large
        max_r = 40
        colors = [COLORS['white'], COLORS['yellow'], COLORS['orange'], COLORS['red'], COLORS['red_dark'], COLORS['purple']]
    
    # Concentric burst circles
    for i, color in enumerate(colors):
        r = max_r - i * (max_r // len(colors))
        alpha = 200 - i * 30
        rgba = (*color[:3], alpha)
        # Create overlay for transparency
        overlay = Image.new('RGBA', size, (0, 0, 0, 0))
        overlay_draw = ImageDraw.Draw(overlay)
        overlay_draw.ellipse([cx-r, cy-r, cx+r, cy+r], fill=rgba)
        img = Image.alpha_composite(img, overlay)
        draw = ImageDraw.Draw(img)
    
    # Sparks/debris
    for angle in range(0, 360, 30):
        rad = math.radians(angle)
        x1 = cx + math.cos(rad) * (max_r // 3)
        y1 = cy + math.sin(rad) * (max_r // 3)
        x2 = cx + math.cos(rad) * max_r
        y2 = cy + math.sin(rad) * max_r
        draw.line([(x1, y1), (x2, y2)], fill=COLORS['yellow'], width=2)
    
    return img

def draw_muzzle_flash_topdown(size, weapon_type='machinegun'):
    """Draw muzzle flash from top-down"""
    img = create_image(size)
    draw = ImageDraw.Draw(img)
    cx, cy = size[0] // 2, size[1] // 2
    
    if weapon_type == 'machinegun':
        # Small burst
        for angle in [-20, 0, 20]:
            rad = math.radians(angle - 90)  # Point up
            x2 = cx + math.cos(rad) * 12
            y2 = cy + math.sin(rad) * 12
            draw.line([(cx, cy-5), (x2, y2)], fill=COLORS['yellow'], width=2)
        draw.ellipse([cx-4, cy-6, cx+4, cy+2], fill=COLORS['orange'])
        
    elif weapon_type == 'missile':
        # Larger burst with smoke
        for angle in range(-30, 31, 10):
            rad = math.radians(angle - 90)
            x2 = cx + math.cos(rad) * 18
            y2 = cy + math.sin(rad) * 18
            draw.line([(cx, cy-5), (x2, y2)], fill=COLORS['orange'], width=3)
        draw.ellipse([cx-6, cy-8, cx+6, cy+4], fill=COLORS['red'])
        draw.ellipse([cx-3, cy-5, cx+3, cy+1], fill=COLORS['yellow'])
    
    return img

def draw_bullet_topdown(size, bullet_type='player'):
    """Draw bullet/projectile from top-down"""
    img = create_image(size)
    draw = ImageDraw.Draw(img)
    cx, cy = size[0] // 2, size[1] // 2
    
    if bullet_type == 'player':
        color = COLORS['cyan']
        # Small dot with trail
        draw.ellipse([cx-2, cy-2, cx+2, cy+2], fill=color)
        draw.line([(cx, cy), (cx, cy+6)], fill=(*color[:3], 150), width=2)
    elif bullet_type == 'enemy':
        color = COLORS['red']
        draw.ellipse([cx-2, cy-2, cx+2, cy+2], fill=color)
        draw.line([(cx, cy), (cx, cy+6)], fill=(*color[:3], 150), width=2)
    elif bullet_type == 'missile':
        color = COLORS['orange']
        # Elongated shape
        draw.ellipse([cx-3, cy-6, cx+3, cy+6], fill=color)
        draw.line([(cx, cy+4), (cx, cy+10)], fill=COLORS['red'], width=2)
    
    return img

def draw_engine_exhaust_topdown(size, frame=0):
    """Draw engine exhaust smoke from top-down"""
    img = create_image(size)
    draw = ImageDraw.Draw(img)
    cx, cy = size[0] // 2, size[1] // 2
    
    # Smoke puffs
    offsets = [
        (0, 5 + frame * 3),
        (-3, 10 + frame * 4),
        (3, 12 + frame * 3),
        (0, 18 + frame * 5),
    ]
    
    for i, (ox, oy) in enumerate(offsets):
        r = 4 + i * 2
        alpha = 150 - i * 30 - frame * 20
        if alpha > 0:
            rgba = (180, 180, 190, alpha)
            overlay = Image.new('RGBA', size, (0, 0, 0, 0))
            overlay_draw = ImageDraw.Draw(overlay)
            overlay_draw.ellipse([cx+ox-r, cy+oy-r, cx+ox+r, cy+oy+r], fill=rgba)
            img = Image.alpha_composite(img, overlay)
    
    return img

def draw_trail_topdown(size, frame=0):
    """Draw engine trail from top-down"""
    img = create_image(size)
    draw = ImageDraw.Draw(img)
    cx, cy = size[0] // 2, size[1] // 2
    
    colors = [COLORS['cyan'], COLORS['pink'], COLORS['purple'], COLORS['green']]
    color = colors[frame % len(colors)]
    
    # Fading line trail
    for i in range(5):
        alpha = 150 - i * 30
        r = 3 - i // 2
        rgba = (*color[:3], alpha)
        overlay = Image.new('RGBA', size, (0, 0, 0, 0))
        overlay_draw = ImageDraw.Draw(overlay)
        overlay_draw.ellipse([cx-r, cy+i*4, cx+r, cy+i*4+r*2], fill=rgba)
        img = Image.alpha_composite(img, overlay)
    
    return img

def draw_ui_element(size, element_type='button'):
    """Draw UI elements"""
    img = create_image(size)
    draw = ImageDraw.Draw(img)
    cx, cy = size[0] // 2, size[1] // 2
    
    if element_type == 'button':
        # Rounded rectangle button
        draw.rounded_rectangle([4, 4, size[0]-4, size[1]-4], radius=8,
                              fill=COLORS['metal_dark'], outline=COLORS['cyan'], width=2)
        # Inner glow
        draw.rounded_rectangle([8, 8, size[0]-8, size[1]-8], radius=6,
                              outline=(*COLORS['cyan'][:3], 100), width=1)
    
    elif element_type == 'button_hover':
        draw.rounded_rectangle([4, 4, size[0]-4, size[1]-4], radius=8,
                              fill=COLORS['cyan_dark'], outline=COLORS['cyan'], width=3)
        draw.rounded_rectangle([6, 6, size[0]-6, size[1]-6], radius=6,
                              outline=COLORS['white'], width=1)
    
    elif element_type == 'healthbar_bg':
        draw.rectangle([0, 0, size[0], size[1]], fill=COLORS['building_dark'])
        draw.rectangle([0, 0, size[0], size[1]], outline=COLORS['gray'], width=1)
    
    elif element_type == 'healthbar_fill':
        draw.rectangle([0, 0, size[0], size[1]], fill=COLORS['green'])
        # Gradient effect
        for i in range(0, size[1], 2):
            draw.line([(0, i), (size[0], i)], fill=(*COLORS['green'][:3], 150), width=1)
    
    elif element_type == 'hud_corner':
        # Cyberpunk corner piece
        draw.line([(0, size[1]-1), (15, size[1]-1)], fill=COLORS['cyan'], width=2)
        draw.line([(0, size[1]-1), (0, size[1]-15)], fill=COLORS['cyan'], width=2)
        draw.line([(size[0]-15, 0), (size[0]-1, 0)], fill=COLORS['cyan'], width=2)
        draw.line([(size[0]-1, 0), (size[0]-1, 15)], fill=COLORS['cyan'], width=2)
    
    elif element_type == 'minimap_frame':
        draw.rectangle([0, 0, size[0]-1, size[1]-1], outline=COLORS['cyan'], width=2)
        draw.rectangle([2, 2, size[0]-3, size[1]-3], outline=COLORS['cyan_dark'], width=1)
    
    elif element_type == 'minimap_player':
        # Triangle pointing up
        draw.polygon([(cx, cy-6), (cx-5, cy+4), (cx+5, cy+4)], fill=COLORS['cyan'])
        draw.polygon([(cx, cy-4), (cx-3, cy+2), (cx+3, cy+2)], fill=COLORS['white'])
    
    elif element_type == 'minimap_enemy':
        draw.ellipse([cx-4, cy-4, cx+4, cy+4], fill=COLORS['red'])
        draw.ellipse([cx-2, cy-2, cx+2, cy+2], fill=COLORS['white'])
    
    elif element_type == 'icon_health':
        draw.ellipse([cx-8, cy-2, cx+8, cy+14], fill=COLORS['red'])
        draw.polygon([(cx, cy-10), (cx-6, cy-2), (cx+6, cy-2)], fill=COLORS['red'])
    
    elif element_type == 'icon_missile':
        draw.rectangle([cx-3, cy-8, cx+3, cy+8], fill=COLORS['orange'])
        draw.polygon([(cx, cy-12), (cx-4, cy-6), (cx+4, cy-6)], fill=COLORS['orange'])
        draw.line([(cx, cy+8), (cx, cy+12)], fill=COLORS['red'], width=2)
    
    elif element_type == 'icon_machinegun':
        # Bullet shape
        draw.rectangle([cx-2, cy-8, cx+2, cy+8], fill=COLORS['yellow'])
        draw.ellipse([cx-2, cy-10, cx+2, cy-6], fill=COLORS['yellow'])
    
    return img

def draw_shield_topdown(size):
    """Draw energy shield effect"""
    img = create_image(size)
    
    # Concentric circles with glow
    for i in range(3):
        r = 20 - i * 5
        alpha = 100 - i * 30
        overlay = Image.new('RGBA', size, (0, 0, 0, 0))
        overlay_draw = ImageDraw.Draw(overlay)
        cx, cy = size[0] // 2, size[1] // 2
        overlay_draw.ellipse([cx-r, cy-r, cx+r, cy+r], 
                            fill=(*COLORS['cyan'][:3], alpha),
                            outline=COLORS['cyan'], width=1)
        img = Image.alpha_composite(img, overlay)
    
    return img

def draw_parallax_layer(size, layer='far'):
    """Draw parallax background layer"""
    img = create_image(size, COLORS['bg'])
    draw = ImageDraw.Draw(img)
    
    if layer == 'far':
        # Distant city silhouette
        for i in range(0, size[0], 40):
            h = 30 + (i % 60)
            draw.rectangle([i, size[1]-h, i+35, size[1]], fill=(20, 20, 35))
    elif layer == 'mid':
        # Mid buildings
        for i in range(0, size[0], 60):
            h = 50 + (i % 80)
            draw.rectangle([i, size[1]-h, i+50, size[1]], fill=(25, 25, 40))
            # Windows
            for wy in range(size[1]-h+10, size[1]-10, 15):
                if (i + wy) % 3 == 0:
                    draw.rectangle([i+5, wy, i+15, wy+8], fill=COLORS['window_dark'])
    else:  # near
        # Close buildings with neon
        for i in range(0, size[0], 80):
            h = 80 + (i % 100)
            draw.rectangle([i, size[1]-h, i+70, size[1]], fill=(30, 30, 50))
            # Neon edge
            draw.line([(i, size[1]-h), (i, size[1])], fill=COLORS['purple'], width=2)
    
    return img

def draw_sky(size, sky_type='night'):
    """Draw sky background"""
    img = create_image(size)
    draw = ImageDraw.Draw(img)
    
    if sky_type == 'night':
        color_top = (5, 5, 20)
        color_bot = (20, 20, 45)
    elif sky_type == 'dusk':
        color_top = (40, 20, 60)
        color_bot = (120, 60, 80)
    else:  # storm
        color_top = (15, 20, 25)
        color_bot = (40, 45, 55)
    
    # Gradient
    for y in range(size[1]):
        ratio = y / size[1]
        r = int(color_top[0] + (color_bot[0] - color_top[0]) * ratio)
        g = int(color_top[1] + (color_bot[1] - color_top[1]) * ratio)
        b = int(color_top[2] + (color_bot[2] - color_top[2]) * ratio)
        draw.line([(0, y), (size[0], y)], fill=(r, g, b))
    
    return img

def draw_weather_effect(size, effect_type='smoke'):
    """Draw weather/environmental effects"""
    img = create_image(size)
    draw = ImageDraw.Draw(img)
    cx, cy = size[0] // 2, size[1] // 2
    
    if effect_type == 'smoke':
        # Smoke cloud
        for i in range(5):
            ox = (i - 2) * 8
            oy = (i % 3) * 5
            r = 12 + i * 3
            alpha = 100 - i * 15
            overlay = Image.new('RGBA', size, (0, 0, 0, 0))
            overlay_draw = ImageDraw.Draw(overlay)
            overlay_draw.ellipse([cx+ox-r, cy+oy-r, cx+ox+r, cy+oy+r], 
                                fill=(100, 100, 110, alpha))
            img = Image.alpha_composite(img, overlay)
    
    elif effect_type == 'fire':
        # Fire animation frames
        for i in range(3):
            oy = i * 6
            r = 8 - i * 2
            color = COLORS['yellow'] if i == 0 else (COLORS['orange'] if i == 1 else COLORS['red'])
            draw.ellipse([cx-r, cy-oy-r, cx+r, cy-oy+r], fill=color)
    
    elif effect_type == 'rain':
        # Rain overlay
        for i in range(0, size[0], 10):
            for j in range(0, size[1], 15):
                draw.line([(i, j), (i-3, j+8)], fill=(*COLORS['cyan'][:3], 80), width=1)
    
    return img

def draw_flying_car(size, car_type=1):
    """Draw flying car for background decoration"""
    img = create_image(size)
    draw = ImageDraw.Draw(img)
    cx, cy = size[0] // 2, size[1] // 2
    
    if car_type == 1:
        # Sleek car
        draw.ellipse([cx-20, cy-6, cx+20, cy+6], fill=COLORS['metal_dark'])
        draw.ellipse([cx-15, cy-4, cx+15, cy+4], fill=COLORS['cyan_dark'])
        # Lights
        draw.ellipse([cx-18, cy-3, cx-12, cy+3], fill=COLORS['red'])
        draw.ellipse([cx+12, cy-3, cx+18, cy+3], fill=COLORS['cyan'])
    else:
        # Boxy car
        draw.rectangle([cx-18, cy-8, cx+18, cy+8], fill=COLORS['metal_dark'])
        draw.rectangle([cx-12, cy-5, cx+12, cy+5], fill=COLORS['purple_dark'])
        draw.ellipse([cx-16, cy-2, cx-10, cy+2], fill=COLORS['yellow'])
        draw.ellipse([cx+10, cy-2, cx+16, cy+2], fill=COLORS['green'])
    
    return img

def save_scaled(img, base_path, sizes={'': 1, '@2x': 2, '@3x': 3}):
    """Save image at multiple scales"""
    base_w, base_h = img.size
    for suffix, scale in sizes.items():
        new_size = (base_w * scale, base_h * scale)
        scaled = img.resize(new_size, Image.Resampling.NEAREST)
        scaled.save(f"{base_path}{suffix}.png")

def main():
    """Generate all Cyber Strike top-down assets"""
    base_dir = "/root/.openclaw/workspace/Cyber_Strike/Assets_TopDown"
    
    # Create directory structure
    dirs = [
        "Player/Helicopter", "Player/Effects",
        "Enemies/Helicopters", "Enemies/Tanks", "Enemies/Turrets", 
        "Enemies/Drones", "Enemies/Boss",
        "Environment/Buildings", "Environment/Roads", "Environment/Bridges",
        "Environment/Rooftops", "Environment/Slums",
        "Effects/Explosions", "Effects/MuzzleFlashes", "Effects/Bullets",
        "Effects/Trails", "Effects/Shields", "Effects/Weather",
        "Backgrounds/Parallax", "Backgrounds/Skies", "Backgrounds/Decorations",
        "UI/Buttons", "UI/HUD", "UI/Icons",
    ]
    
    for d in dirs:
        os.makedirs(f"{base_dir}/{d}", exist_ok=True)
    
    print("Generating Player Helicopter assets...")
    # Player helicopter states
    for state in ['idle', 'bank_left', 'bank_right', 'damaged']:
        img = draw_helicopter_topdown((64, 64), COLORS['metal'], COLORS['cyan'], state)
        save_scaled(img, f"{base_dir}/Player/Helicopter/helicopter_{state}")
    
    print("Generating Engine Exhaust...")
    for frame in range(4):
        img = draw_engine_exhaust_topdown((32, 32), frame)
        save_scaled(img, f"{base_dir}/Player/Effects/engine_exhaust_{frame}")
    
    print("Generating Enemy Helicopters...")
    # Scout chopper
    img = draw_helicopter_topdown((48, 48), COLORS['gray_dark'], COLORS['pink'], 'idle')
    save_scaled(img, f"{base_dir}/Enemies/Helicopters/enemy_scout")
    # Gunship
    img = draw_helicopter_topdown((56, 56), COLORS['building_dark'], COLORS['red'], 'idle')
    save_scaled(img, f"{base_dir}/Enemies/Helicopters/enemy_gunship")
    
    print("Generating Tanks...")
    img = draw_tank_topdown((48, 48), 'basic')
    save_scaled(img, f"{base_dir}/Enemies/Tanks/tank_basic")
    img = draw_tank_topdown((56, 56), 'heavy')
    save_scaled(img, f"{base_dir}/Enemies/Tanks/tank_heavy")
    
    print("Generating Turrets...")
    img = draw_turret_topdown((48, 48))
    save_scaled(img, f"{base_dir}/Enemies/Turrets/turret_aa")
    
    print("Generating Drones...")
    img = draw_drone_topdown((32, 32))
    save_scaled(img, f"{base_dir}/Enemies/Drones/drone_small")
    
    print("Generating Boss...")
    img = draw_boss_gunship_topdown((96, 96))
    save_scaled(img, f"{base_dir}/Enemies/Boss/boss_gunship")
    
    print("Generating Buildings...")
    for btype in ['small', 'tall', 'corp', 'slum']:
        img = draw_building_topdown((80, 80), btype)
        save_scaled(img, f"{base_dir}/Environment/Buildings/building_{btype}")
    
    print("Generating Environment...")
    img = draw_road_topdown((64, 64), 'straight')
    save_scaled(img, f"{base_dir}/Environment/Roads/road_straight")
    img = draw_road_topdown((64, 64), 'intersection')
    save_scaled(img, f"{base_dir}/Environment/Roads/road_intersection")
    img = draw_bridge_topdown((64, 64))
    save_scaled(img, f"{base_dir}/Environment/Bridges/bridge_section")
    
    print("Generating Rooftop Details...")
    img = draw_rooftop_detail((32, 32), 'ac_unit')
    save_scaled(img, f"{base_dir}/Environment/Rooftops/ac_unit")
    img = draw_rooftop_detail((32, 32), 'antenna')
    save_scaled(img, f"{base_dir}/Environment/Rooftops/antenna")
    
    print("Generating Effects...")
    # Explosions
    for etype in ['small', 'medium', 'large']:
        for frame in range(4):
            img = draw_explosion_topdown((48 if etype=='small' else 64 if etype=='medium' else 96, 
                                         48 if etype=='small' else 64 if etype=='medium' else 96), etype)
            save_scaled(img, f"{base_dir}/Effects/Explosions/explosion_{etype}_{frame}")
    
    # Muzzle flashes
    for wtype in ['machinegun', 'missile']:
        for frame in range(3):
            img = draw_muzzle_flash_topdown((32, 32), wtype)
            save_scaled(img, f"{base_dir}/Effects/MuzzleFlashes/muzzle_{wtype}_{frame}")
    
    # Bullets
    for btype in ['player', 'enemy', 'missile']:
        img = draw_bullet_topdown((16, 16), btype)
        save_scaled(img, f"{base_dir}/Effects/Bullets/bullet_{btype}")
    
    # Trails
    for frame in range(4):
        img = draw_trail_topdown((32, 32), frame)
        save_scaled(img, f"{base_dir}/Effects/Trails/trail_{frame}")
    
    # Shield
    img = draw_shield_topdown((64, 64))
    save_scaled(img, f"{base_dir}/Effects/Shields/shield_energy")
    
    # Weather
    for wtype in ['smoke', 'fire', 'rain']:
        img = draw_weather_effect((64, 64), wtype)
        save_scaled(img, f"{base_dir}/Effects/Weather/{wtype}")
    
    print("Generating Backgrounds...")
    # Parallax layers
    for layer in ['far', 'mid', 'near']:
        img = draw_parallax_layer((256, 256), layer)
        save_scaled(img, f"{base_dir}/Backgrounds/Parallax/parallax_{layer}")
    
    # Skies
    for stype in ['night', 'dusk', 'storm']:
        img = draw_sky((256, 256), stype)
        save_scaled(img, f"{base_dir}/Backgrounds/Skies/sky_{stype}")
    
    # Flying cars
    for i in [1, 2]:
        img = draw_flying_car((64, 32), i)
        save_scaled(img, f"{base_dir}/Backgrounds/Decorations/flying_car_{i}")
    
    # Smog cloud
    img = draw_weather_effect((64, 64), 'smoke')
    save_scaled(img, f"{base_dir}/Backgrounds/Decorations/smog_cloud")
    
    print("Generating UI...")
    # Buttons
    img = draw_ui_element((96, 48), 'button')
    save_scaled(img, f"{base_dir}/UI/Buttons/button_normal")
    img = draw_ui_element((96, 48), 'button_hover')
    save_scaled(img, f"{base_dir}/UI/Buttons/button_hover")
    
    # HUD
    img = draw_ui_element((128, 16), 'healthbar_bg')
    save_scaled(img, f"{base_dir}/UI/HUD/healthbar_bg")
    img = draw_ui_element((128, 16), 'healthbar_fill')
    save_scaled(img, f"{base_dir}/UI/HUD/healthbar_fill")
    img = draw_ui_element((32, 32), 'hud_corner')
    save_scaled(img, f"{base_dir}/UI/HUD/hud_corner")
    
    # Minimap
    img = draw_ui_element((64, 64), 'minimap_frame')
    save_scaled(img, f"{base_dir}/UI/minimap_frame")
    img = draw_ui_element((16, 16), 'minimap_player')
    save_scaled(img, f"{base_dir}/UI/minimap_player")
    img = draw_ui_element((16, 16), 'minimap_enemy')
    save_scaled(img, f"{base_dir}/UI/minimap_enemy")
    
    # Icons
    for icon in ['health', 'missile', 'machinegun']:
        img = draw_ui_element((32, 32), f'icon_{icon}')
        save_scaled(img, f"{base_dir}/UI/Icons/icon_{icon}")
    
    print(f"\n✅ All assets generated successfully in {base_dir}")
    print(f"Total files created: ~{len(dirs) * 10}")

if __name__ == "__main__":
    main()
