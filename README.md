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
| **Shape** | Shape moiré — compressed text revealed through a horizontal grating ([Wikipedia](https://en.wikipedia.org/wiki/Shape_moir%C3%A9)) |
| **Eye** | Two large eyes with pupils that appear to move when the vertical stripe overlay is dragged |

## Features

- **Eight Pattern Modes** with mode-specific controls and presets
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
- **MoireCanvasView.swift** — Canvas rendering with pattern layers (`LinePatternLayer`, `CirclePatternLayer`, `GridPatternLayer`, `RadialPatternLayer`, `DotPatternLayer`, `CheckerboardPatternLayer`, `ShapeBaseLayer`, `ShapeRevealLayer`, `EyeBaseLayer`, `EyeRevealLayer`) and drag gesture handling
- **ControlPanelView.swift** — Parameter controls, pattern mode picker, and presets
- **MoireViewModel.swift** — Shared state management via `ObservableObject`

Patterns are rendered using SwiftUI's `Canvas` view for efficient drawing. The overlay uses `.blendMode(.darken)` to simulate transparent superposition.

### Shape Moiré

Shape moiré demonstrates **moiré magnification**. A base layer contains user-specified text compressed vertically and tiled at period *pb*. A revealing layer (horizontal grating with thin transparent slits at period *pr*) is overlaid with darken blend mode. When *pr ≈ pb*, the moiré effect reconstructs the text at readable proportions. Dragging the reveal layer vertically causes the text to scroll at magnified speed. Enter any text string — including CJK characters — in the control panel.

### Eye Moiré

Eye moiré uses the same **moiré magnification** principle as Shape moiré, but in the horizontal direction with a custom eye graphic. The base layer draws two large eyes with horizontally-compressed, tiled pupils inside each eye socket. The overlay is a vertical grating (thin transparent slits). When the stripe overlay is dragged left or right, the pupils appear to shift — creating the illusion that the eyes are following the motion. The closer *pr* is to *pb*, the slower and more dramatic the pupil movement.
