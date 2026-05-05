# Moiré Patterns

A macOS app demonstrating **Line Moiré** patterns — the visual interference patterns that appear when two layers of parallel lines are superimposed.

## What is Line Moiré?

Line moiré is a type of moiré pattern that appears when superposing two transparent layers containing correlated opaque patterns of straight or curved lines. When moving one layer relative to the other, the moiré patterns transform or move at a faster speed — an effect called **optical moiré speedup**.

## Features

- **Interactive Canvas**: Drag to move the active layer and observe moiré pattern formation in real-time
- **Dual Layer Control**: Independently configure each layer's line spacing, thickness, and angle
- **Drag Modes**: Switch between translation and rotation modes
- **Presets**: Quick-access presets demonstrating different moiré effects:
  - **Classic**: Standard moiré with slightly different spacing
  - **Fine**: Dense line patterns with subtle spacing differences
  - **Angled**: Same spacing but slightly rotated layers
  - **Wide**: Bold lines with visible interference bands
- **Layer Visibility**: Toggle layers on/off to understand the composition
- **Color Customization**: Change line colors for each layer

## How to Use

1. Open the app — you'll see two superimposed layers of black lines on white
2. **Drag on the canvas** to move the active layer (Layer 2 by default)
3. Notice how the moiré pattern moves much faster than your drag — this is the optical speedup effect
4. Use the **control panel** on the right to:
   - Switch which layer responds to dragging
   - Adjust line spacing, thickness, and angle
   - Try different presets
   - Toggle layer visibility

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
- **MoireCanvasView.swift** — Canvas rendering with `Canvas` API and drag gesture handling
- **ControlPanelView.swift** — Parameter controls and presets
- **MoireViewModel.swift** — Shared state management via `ObservableObject`

The line patterns are rendered using SwiftUI's `Canvas` view for efficient drawing. Each layer renders parallel lines with configurable spacing, thickness, and rotation. The overlay uses `.blendMode(.darken)` to simulate transparent superposition.
