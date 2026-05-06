# Moiré Patterns

A macOS app demonstrating **Moiré patterns** — the visual interference patterns that appear when two layers of correlated opaque patterns are superimposed.

## What is Moiré?

Moiré patterns appear when superposing two transparent layers containing correlated opaque patterns. When moving one layer relative to the other, the moiré patterns transform or move at a faster speed — an effect called **optical moiré speedup**.

## Pattern Modes

| Mode | Description |
|------|-------------|
| **Lines** | Parallel lines — the classic line moiré |
| **Circles** | Concentric rings radiating from a center point |
| **Grid** | Orthogonal grid (horizontal + vertical lines) |
| **Radial** | Rays radiating from a center point (sunburst) |
| **Dots** | Regular grid of filled circles |
| **Checkerboard** | Alternating filled squares |

## Features

- **Six Pattern Modes** with mode-specific controls and presets
- **Interactive Canvas**: Drag to move the active layer and observe moiré pattern formation in real-time
- **Dual Layer Control**: Independently configure each layer's parameters
- **Drag Modes**: Switch between translation and rotation (for patterns that support angle)
- **Presets**: 4 presets per pattern mode for quick demonstrations
- **Layer Visibility**: Toggle layers on/off to understand the composition
- **Color Customization**: Change pattern colors for each layer

## How to Use

1. Open the app — you'll see two superimposed pattern layers on white
2. Use the **Pattern** dropdown to choose a mode
3. **Drag on the canvas** to move the active layer (Layer 2 by default)
4. Notice how the moiré pattern moves much faster than your drag — this is the optical speedup effect
5. Use the **control panel** on the right to adjust parameters and try presets

## Requirements

- macOS 14.0+
- Xcode 15.0+

## Building

1. Open `MoirePatterns/MoirePatterns.xcodeproj` in Xcode
2. Select the "MoirePatterns" scheme
3. Build and run (⌘R)

## Architecture

- **MoirePatternsApp.swift** — App entry point
- **ContentView.swift** — Main split view layout
- **MoireCanvasView.swift** — Canvas rendering with pattern layers (`LinePatternLayer`, `CirclePatternLayer`, `GridPatternLayer`, `RadialPatternLayer`, `DotPatternLayer`, `CheckerboardPatternLayer`) and drag gesture handling
- **ControlPanelView.swift** — Parameter controls, pattern mode picker, and presets
- **MoireViewModel.swift** — Shared state management via `ObservableObject`

Patterns are rendered using SwiftUI's `Canvas` view for efficient drawing. The overlay uses `.blendMode(.darken)` to simulate transparent superposition.
