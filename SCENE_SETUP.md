# Scene Setup Guide

## Main World Scene (scenes/world/main_world.tscn)

### Node Structure:
```
MainWorld (Node2D) - world_generator.gd
├── Ground (TileMapLayer)
├── Buildings (Node2D)
├── Trees (Node2D)
├── Items (Node2D)
├── Zombies (Node2D)
├── ZombieSpawner (Node2D) - zombie_spawner.gd
├── Player (CharacterBody2D) - player.gd
│   ├── CollisionShape2D
│   ├── Sprite2D
│   ├── AttackArea (Area2D)
│   │   └── CollisionShape2D
│   ├── Inventory (Node) - inventory.gd
│   ├── EquipmentManager (Node) - equipment_manager.gd
│   ├── EquipmentSprites (Node2D)
│   ├── AnimationPlayer
│   └── Camera2D
└── HUD (CanvasLayer) - hud.gd
    ├── HealthBar (ProgressBar)
    ├── StaminaBar (ProgressBar)
    ├── HungerBar (ProgressBar)
    ├── ThirstBar (ProgressBar)
    ├── TimeLabel (Label)
    ├── DayLabel (Label)
    └── EquippedItemLabel (Label)
```

## Main Menu Scene (scenes/ui/menu/main_menu.tscn)

### Node Structure:
```
MainMenu (Control) - main_menu.gd
├── Background (TextureRect)
├── Panel (Panel)
│   ├── TitleLabel (Label)
│   ├── SubtitleLabel (Label)
│   ├── VBoxContainer
│   │   ├── ContinueButton (Button)
│   │   ├── NewGameButton (Button)
│   │   ├── LoadGameButton (Button)
│   │   ├── SettingsButton (Button)
│   │   └── QuitButton (Button)
│   └── VersionLabel (Label)
├── SaveLoadUI (Control) - save_load.ui.gd
└── SettingsMenu (Control) - settings_menu.gd
```

## Settings Menu Scene (scenes/ui/settings/settings_menu.tscn)

### Node Structure:
```
SettingsMenu (Control) - settings_menu.gd
└── Panel (Panel)
    ├── TitleLabel (Label)
    ├── TabContainer
    │   ├── Graphics (VBoxContainer)
    │   │   ├── ResolutionOption (OptionButton)
    │   │   ├── FullscreenCheck (CheckBox)
    │   │   └── VsyncCheck (CheckBox)
    │   ├── Audio (VBoxContainer)
    │   │   ├── MasterVolumeSlider (HSlider)
    │   │   ├── MusicVolumeSlider (HSlider)
    │   │   ├── SFXVolumeSlider (HSlider)
    │   │   └── AmbientVolumeSlider (HSlider)
    │   └── Gameplay (VBoxContainer)
    │       ├── DifficultyOption (OptionButton)
    │       ├── AutoSaveCheck (CheckBox)
    │       └── ShowHUDCheck (CheckBox)
    ├── ApplyButton (Button)
    ├── CancelButton (Button)
    └── ResetButton (Button)
```

## Save/Load UI Scene (scenes/ui/menu/save_load_ui.tscn)

### Node Structure:
```
SaveLoadUI (Control) - save_load_ui.gd
└── Panel (Panel)
    ├── TitleLabel (Label)
    ├── SaveSlots (VBoxContainer)
    │   └── [5 x HBoxContainer]
    │       ├── Label (Slot number)
    │       ├── InfoLabel (Save info)
    │       └── Button (Select)
    └── BackButton (Button)
```

## NPC Scene (scenes/npc/npc.tscn)

### Node Structure:
```
NPC (CharacterBody2D) - npc.gd
├── Sprite2D
├── CollisionShape2D
├── DetectionArea (Area2D)
│   └── CollisionShape2D
└── AttackArea (Area2D)
    └── CollisionShape2D
```

## Zombie Scene (scenes/zombie/zombie.tscn)

### Node Structure:
```
Zombie (CharacterBody2D) - zombie.gd
├── Sprite2D
├── CollisionShape2D
├── AttackArea (Area2D)
│   └── CollisionShape2D
├── DetectionArea (Area2D)
│   └── CollisionShape2D
└── AnimationPlayer
```

## Vehicle Scene (scenes/vehicles/vehicle.tscn)

### Node Structure:
```
Vehicle (CharacterBody2D) - vehicle.gd
├── Sprite2D
├── CollisionShape2D
└── ExhaustParticles (CPUParticles2D)
```

## Trailer Scene (scenes/vehicles/trailer.tscn)

### Node Structure:
```
Trailer (CharacterBody2D) - trailer.gd
├── Sprite2D
└── CollisionShape2D
```

## Furniture Scene (scenes/furniture/furniture.tscn)

### Node Structure:
```
Furniture (Node2D) - furniture.gd
├── Sprite2D
└── InteractionArea (Area2D)
    └── CollisionShape2D
```

## Farming Spot Scene (scenes/farming/plantable_spot.tscn)

### Node Structure:
```
PlantableSpot (StaticBody2D) - plantable_spot.gd
├── Sprite2D
├── CollisionShape2D
├── WaterBar (ProgressBar)
└── GrowthTimer (Timer)
```

## Building Scenes (scenes/buildings/*.tscn)

### Wall Scene:
```
Wall (StaticBody2D) - wall.gd
├── Sprite2D
├── CollisionShape2D
└── HealthBar (ProgressBar)
```

### Door Scene:
```
Door (StaticBody2D) - door.gd
├── Sprite2D
├── CollisionShape2D
└── HealthBar (ProgressBar)
```

### Foundation Scene:
```
Foundation (StaticBody2D) - foundation.gd
├── Sprite2D
├── CollisionShape2D
└── HealthBar (ProgressBar)
```

### Storage Scene:
```
Storage (StaticBody2D) - storage_box.gd
├── Sprite2D
├── CollisionShape2D
└── HealthBar (ProgressBar)
```

## UI Scenes

### Inventory UI (scenes/ui/bag_ui.tscn)
### Building Menu (scenes/ui/building_menu.tscn)
### Character Creation (scenes/ui/character_creation.tscn)
### Skills Display (scenes/ui/skills_display.tscn)
### Mutation Display (scenes/ui/mutation_display.tscn)
### Dialogue UI (scenes/ui/npc/dialogue_ui.tscn)
### Trade UI (scenes/ui/npc/trade_ui.tscn)
### Squad UI (scenes/ui/squad/squad_ui.tscn)
### Vehicle Trunk UI (scenes/ui/vehicle_trunk_ui.tscn)
### Vehicle Repair UI (scenes/ui/vehicle_repair_ui.tscn)
### Furniture Storage UI (scenes/ui/furniture_storage_ui.tscn)
### Minimap HUD (scenes/ui/map/minimap_hud.tscn)
### World Map (scenes/ui/map/world_map.tscn)

## Audio Manager Scene (scenes/audio/audio_manager.tscn)

### Node Structure:
```
AudioManager (Node) - audio_manager.gd
├── MusicPlayer (AudioStreamPlayer)
├── AmbientPlayer (AudioStreamPlayer)
├── SFXPlayer (AudioStreamPlayer)
└── UIPlayer (AudioStreamPlayer)
```

## Autoloads (project.godot)

```
GameManager - scripts/core/game_manager.gd
EventManager - scripts/core/event_manager.gd
SaveManager - scripts/core/save_manager.gd
FarmingManager - scripts/farming/farming_manager.gd
BuildingManager - scripts/buildings/building_manager.gd
NPCManager - scripts/npc/npc_manager.gd
FactionManager - scripts/npc/factions/faction_manager.gd
QuestManager - scripts/npc/quests/quest_manager.gd
SquadManager - scripts/squad/squad_manager.gd
AudioManager - scripts/audio/audio_manager.gd
DayNightCycle - scripts/world/day_night_cycle.gd
WeatherSystem - scripts/weather/weather_system.gd
```

## Common Issues and Fixes

### 1. Missing Nodes
If a script references a node that doesn't exist in the scene:
- Add the missing node to the scene
- Or update the script to use `has_node()` checks

### 2. Signal Connections
If signals aren't connecting:
- Verify the signal exists in the script
- Check that the node paths are correct
- Use `connect()` with proper method references

### 3. Autoload Issues
If autoloads aren't working:
- Check project.godot for correct paths
- Verify scripts don't have syntax errors
- Ensure autoloads are initialized in correct order

### 4. Scene References
If scenes can't find resources:
- Verify all resource paths are correct
- Check that all scripts exist
- Ensure all textures/sprites are in the right locations
