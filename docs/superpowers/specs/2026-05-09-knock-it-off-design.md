# Knock It Off! — Game Design Spec

**Date:** 2026-05-09
**Platform:** Web (Godot HTML5 export), mobile/tablet first (iPad)
**Orientation:** Landscape (1920×1080, scaled)

---

## Overview

A casual tap game for kids. The player controls a cat on a kitchen counter. Tap items to have the cat swipe them off the edge. A dog patrols below — hitting it with a falling item earns bonus points. After 60 seconds the human comes home and the game ends.

---

## Scene Layout

Side-view kitchen in landscape orientation.

- **Counter** runs horizontally across the upper ~60% of the screen
- **Floor** sits at the bottom of the screen
- **Left edge of counter** is the fall-off point — items slide left and drop here
- **Cat** sits on the counter; snaps to tapped item's x-position and swipes
- **Dog** patrols left-right across the floor beneath the counter
- **HUD** overlaid on top: score (top-left), countdown timer (top-right)

---

## Core Mechanics

### Items
- Spawn at the right edge of the counter every 1–2 seconds (randomized, tunable)
- Slide left at constant speed (tunable)
- Two categories:
  - **Food:** bowl, cup, chicken, steak, fish
  - **Non-food:** vase, phone
- If tapped: cat snaps to item, swipe animation plays, item becomes a falling RigidBody2D
- If not tapped: item slides off the left edge unscored, no penalty

### Cat
- Sits on the counter at all times
- On `item_tapped` signal: snaps instantly to item's x-position, plays swipe animation
- Idle animation when not swiping
- Two variants: Waffles and Prince, chosen on the start screen
- Selection stored as integer (0/1), passed to main scene

### Dog
- Patrols left-right across the floor at constant speed (tunable)
- When hit by a food item: catches it happily, player scores big points
- When hit by a non-food item: yelps, runs off the right edge of screen, returns after a few seconds
- No health or lives — a friend to feed, not an enemy

### Scoring
- Food hits dog: big points (tunable, default 25)
- Food hits floor: small points (tunable, default 10)
- Non-food hits dog: point penalty (tunable, default -15)
- Non-food hits floor: no points, no penalty
- No penalty for missed items (slide off counter unswatted)

### Timer
- 60-second countdown (tunable)
- Displayed in HUD
- On expiry: `time_up` signal → game over → end screen

---

## Input

- Touch/tap primary (mobile/tablet)
- Mouse click also works (desktop testing)
- Tapping an item triggers `item_tapped(item)` signal from that item node
- Tapping empty space does nothing

---

## Signal Architecture (Option A — Items own their input)

```
Item          → emits: item_tapped(item), item_hit_floor, item_hit_dog
Cat           → listens: item_tapped → snap + swipe
ScoreManager  → listens: item_hit_floor, item_hit_dog → update score, emit score_changed
GameTimer     → emits: time_up
GameState     → listens: time_up → trigger end screen
HUD           → listens: score_changed → update display
```

---

## Scripts & Scenes

| Script | Node | Responsibility |
|---|---|---|
| `cat.gd` | `cat.tscn` root | Snap to position, swipe animation |
| `item.gd` | `item.tscn` root | Slide, detect tap, emit signals, physics fall |
| `item_spawner.gd` | Node in `main.tscn` | Timer-based item instantiation |
| `dog.gd` | `dog.tscn` root | Patrol, react to hit, run off + return |
| `score_manager.gd` | Autoload singleton | Track score, emit score_changed |
| `game_timer.gd` | Node in `main.tscn` | 60s countdown, emit time_up |
| `game_state.gd` | Autoload singleton | Game phase: start / playing / end |

### Project structure

```
res://
├── PLAN.md
├── SETUP_phase0.md, SETUP_phase1.md, ...
├── scenes/
│   ├── main.tscn
│   ├── cat.tscn
│   ├── item.tscn
│   ├── dog.tscn
│   └── ui/
│       ├── hud.tscn
│       ├── start_screen.tscn
│       └── end_screen.tscn
├── scripts/
│   ├── cat.gd
│   ├── item.gd
│   ├── item_spawner.gd
│   ├── dog.gd
│   ├── score_manager.gd
│   ├── game_timer.gd
│   └── game_state.gd
└── assets/
    ├── sprites/
    └── sounds/
```

---

## Screens

### Start Screen
- Title: "Knock It Off!"
- Cat picker: Waffles and Prince shown as sprites, tap to select
- Play button

### HUD (in-game)
- Score: top-left
- Countdown timer: top-right

### End Screen
- "Time's up! The human is home."
- Final score displayed
- Play Again button (returns to start screen)

---

## Build Phases

| Phase | What Gets Built |
|---|---|
| 0 | Project setup, static scene: counter + floor + placeholder art visible |
| 1 | Cat + items: spawning, sliding, tap-to-swipe, falling physics |
| 2 | Dog: patrol, collision, run-off behavior |
| 3 | Scoring, HUD, timer, game over flow |
| 4 | Start screen with cat picker |
| 5 | End screen + Play Again |
| 6 | Polish: sounds, visual juice, web export — includes background music (`assets/sounds/music_bg.ogg`, OGG Vorbis, looping) |

---

## Tunable Values (@export)

| Variable | Default | Location |
|---|---|---|
| Spawn interval min/max | 1.0s / 2.0s | `item_spawner.gd` |
| Item slide speed | 120 px/s | `item.gd` |
| Game duration | 60s | `game_timer.gd` |
| Dog patrol speed | 80 px/s | `dog.gd` |
| Dog return delay | 3s | `dog.gd` |
| Food hits floor score | 10 | `score_manager.gd` |
| Food hits dog score | 25 | `score_manager.gd` |
| Non-food hits dog penalty | -15 | `score_manager.gd` |
