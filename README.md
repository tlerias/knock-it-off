# Knock It Off! 🐱🐶

A casual tap game for kids built with Godot 4.6. You're a cat on a kitchen counter — knock food down to your dog friend below, and avoid hitting them with non-food items!

## Gameplay

- **Tap items** on the counter to swipe them off the edge
- **Feed the dog** — food items that hit the dog mid-air earn **+25 points**
- **Floor food** — food that lands on the floor can still be picked up by the dog for **+1 point**
- **Don't hurt the dog** — non-food items (books, vases, plants) hitting the dog cost **-15 points**
- The dog will yelp and run off-screen if hit with non-food, then return after a few seconds
- **45 seconds** to rack up the highest score you can!

## Controls

| Action | Input |
|---|---|
| Swipe item | Tap / left-click on item |
| Mute music | ♫ button (bottom-right corner) |

## Screens

1. **Start Screen** — choose your cat (Waffles or Prince), then press Play
2. **Game** — tap items on the counter to feed the dog
3. **End Screen** — see your final score and play again

## Scoring

| Event | Points |
|---|---|
| Food hits dog (mid-air) | +25 |
| Food picked up off floor | +1 |
| Non-food hits dog | -15 |
| Non-food hits floor | 0 |
| Missed item (expired) | 0 |

## Project Structure

```
scenes/
  main.tscn           — main game scene
  cat.tscn            — cat character
  item.tscn           — spawnable counter items
  dog.tscn            — dog character
  ui/
    hud.tscn          — in-game score + timer overlay
    start_screen.tscn — cat picker + play button
    end_screen.tscn   — final score + play again

scripts/
  main.gd             — game loop, tap routing, score popups
  cat.gd              — snap + swipe animation
  item.gd             — lifetime, shake, floor detection
  item_spawner.gd     — timed item spawning with placement logic
  dog.gd              — patrol, reactions, floor food pickup
  score_manager.gd    — autoload: score state + signals
  game_state.gd       — autoload: cat selection + final score
  game_timer.gd       — 45s countdown
  music_manager.gd    — autoload: looping bg music + mute button
  hud.gd              — score/timer display + hint labels
  start_screen.gd     — cat selection UI
  end_screen.gd       — results display

assets/
  sprites/            — pixel art sprites (cats, dog, items, backgrounds, UI)
  sound/              — background music (OGG)
```

## Built With

- [Godot 4.6](https://godotengine.org/) — GL Compatibility renderer
- Target: Web (HTML5) + iPad (landscape 1920×1080)
- Font: Love Ya Like A Sister
