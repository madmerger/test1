import SwiftUI
import Combine

class MoireViewModel: ObservableObject {
    // Pattern mode
    @Published var patternMode: PatternMode = .lines

    // Layer 1 (base layer) parameters
    @Published var layer1Spacing: Double = 8.0
    @Published var layer1Thickness: Double = 3.0
    @Published var layer1Angle: Double = 0.0
    @Published var layer1Offset: CGSize = .zero

    // Layer 2 (overlay layer) parameters
    @Published var layer2Spacing: Double = 8.5
    @Published var layer2Thickness: Double = 3.0
    @Published var layer2Angle: Double = 0.0
    @Published var layer2Offset: CGSize = .zero

    // Shape Moiré specific
    @Published var shapeText: String = "Hello"
    @Published var shapeFontSize: Double = 80.0

    // Display options
    @Published var layer1Color: Color = .black
    @Published var layer2Color: Color = .black
    @Published var backgroundColor: Color = .white
    @Published var showLayer1: Bool = true
    @Published var showLayer2: Bool = true

    // Interaction state
    @Published var activeLayer: Int = 2
    @Published var dragMode: DragMode = .translate

    enum PatternMode: String, CaseIterable {
        case lines = "Lines"
        case circles = "Circles"
        case grid = "Grid"
        case radial = "Radial"
        case dots = "Dots"
        case checkerboard = "Checker"
        case shapeMoire = "Shape"
    }

    enum DragMode: String, CaseIterable {
        case translate = "Move"
        case rotate = "Rotate"
    }

    var supportsAngle: Bool {
        switch patternMode {
        case .lines, .grid, .dots, .checkerboard:
            return true
        case .circles, .radial, .shapeMoire:
            return false
        }
    }

    func reset() {
        layer1Angle = 0.0
        layer1Offset = .zero
        layer2Angle = 0.0
        layer2Offset = .zero
        activeLayer = 2

        switch patternMode {
        case .lines:
            layer1Spacing = 8.0
            layer1Thickness = 3.0
            layer2Spacing = 8.5
            layer2Thickness = 3.0
        case .circles:
            layer1Spacing = 10.0
            layer1Thickness = 3.0
            layer2Spacing = 10.5
            layer2Thickness = 3.0
        case .grid:
            layer1Spacing = 10.0
            layer1Thickness = 2.0
            layer2Spacing = 10.5
            layer2Thickness = 2.0
        case .radial:
            layer1Spacing = 6.0
            layer1Thickness = 3.0
            layer2Spacing = 6.0
            layer2Thickness = 3.0
        case .dots:
            layer1Spacing = 10.0
            layer1Thickness = 4.0
            layer2Spacing = 10.5
            layer2Thickness = 4.0
        case .checkerboard:
            layer1Spacing = 10.0
            layer1Thickness = 10.0
            layer2Spacing = 10.5
            layer2Thickness = 10.5
        case .shapeMoire:
            layer1Spacing = 6.0
            layer1Thickness = 3.0
            layer2Spacing = 6.5
            layer2Thickness = 1.0
            shapeFontSize = 80.0
        }
    }

    // MARK: - Line Presets

    func applyLinePresetClassic() {
        patternMode = .lines
        reset()
    }

    func applyLinePresetFine() {
        patternMode = .lines
        reset()
        layer1Spacing = 4.0
        layer1Thickness = 2.0
        layer2Spacing = 4.3
        layer2Thickness = 2.0
    }

    func applyLinePresetAngled() {
        patternMode = .lines
        reset()
        layer2Angle = 5.0
    }

    func applyLinePresetWide() {
        patternMode = .lines
        reset()
        layer1Spacing = 15.0
        layer1Thickness = 7.0
        layer2Spacing = 16.0
        layer2Thickness = 7.0
    }

    // MARK: - Circle Presets

    func applyCirclePresetClassic() {
        patternMode = .circles
        reset()
    }

    func applyCirclePresetDense() {
        patternMode = .circles
        reset()
        layer1Spacing = 5.0
        layer1Thickness = 2.0
        layer2Spacing = 5.3
        layer2Thickness = 2.0
    }

    func applyCirclePresetOffset() {
        patternMode = .circles
        reset()
        layer2Offset = CGSize(width: 30, height: 0)
    }

    func applyCirclePresetWide() {
        patternMode = .circles
        reset()
        layer1Spacing = 16.0
        layer1Thickness = 6.0
        layer2Spacing = 17.0
        layer2Thickness = 6.0
    }

    // MARK: - Grid Presets

    func applyGridPresetClassic() {
        patternMode = .grid
        reset()
    }

    func applyGridPresetFine() {
        patternMode = .grid
        reset()
        layer1Spacing = 5.0
        layer1Thickness = 1.5
        layer2Spacing = 5.3
        layer2Thickness = 1.5
    }

    func applyGridPresetAngled() {
        patternMode = .grid
        reset()
        layer2Angle = 5.0
    }

    func applyGridPresetDense() {
        patternMode = .grid
        reset()
        layer1Spacing = 4.0
        layer1Thickness = 2.0
        layer2Spacing = 4.0
        layer2Thickness = 2.0
        layer2Angle = 3.0
    }

    // MARK: - Radial Presets

    func applyRadialPresetClassic() {
        patternMode = .radial
        reset()
    }

    func applyRadialPresetDense() {
        patternMode = .radial
        reset()
        layer1Spacing = 3.0
        layer1Thickness = 1.5
        layer2Spacing = 3.0
        layer2Thickness = 1.5
    }

    func applyRadialPresetOffset() {
        patternMode = .radial
        reset()
        layer2Offset = CGSize(width: 40, height: 0)
    }

    func applyRadialPresetWide() {
        patternMode = .radial
        reset()
        layer1Spacing = 10.0
        layer1Thickness = 5.0
        layer2Spacing = 10.0
        layer2Thickness = 5.0
    }

    // MARK: - Dot Presets

    func applyDotPresetClassic() {
        patternMode = .dots
        reset()
    }

    func applyDotPresetFine() {
        patternMode = .dots
        reset()
        layer1Spacing = 6.0
        layer1Thickness = 2.5
        layer2Spacing = 6.3
        layer2Thickness = 2.5
    }

    func applyDotPresetAngled() {
        patternMode = .dots
        reset()
        layer2Angle = 5.0
    }

    func applyDotPresetDense() {
        patternMode = .dots
        reset()
        layer1Spacing = 5.0
        layer1Thickness = 3.0
        layer2Spacing = 5.0
        layer2Thickness = 3.0
        layer2Angle = 3.0
    }

    // MARK: - Checkerboard Presets

    func applyCheckerPresetClassic() {
        patternMode = .checkerboard
        reset()
    }

    func applyCheckerPresetFine() {
        patternMode = .checkerboard
        reset()
        layer1Spacing = 5.0
        layer1Thickness = 5.0
        layer2Spacing = 5.3
        layer2Thickness = 5.3
    }

    func applyCheckerPresetAngled() {
        patternMode = .checkerboard
        reset()
        layer2Angle = 5.0
    }

    func applyCheckerPresetLarge() {
        patternMode = .checkerboard
        reset()
        layer1Spacing = 20.0
        layer1Thickness = 20.0
        layer2Spacing = 21.0
        layer2Thickness = 21.0
    }

    // MARK: - Shape Moiré Presets

    func applyShapePresetClassic() {
        patternMode = .shapeMoire
        reset()
        shapeText = "Hello"
    }

    func applyShapePresetKanji() {
        patternMode = .shapeMoire
        reset()
        shapeText = "モアレ"
        shapeFontSize = 100.0
    }

    func applyShapePresetFine() {
        patternMode = .shapeMoire
        reset()
        shapeText = "Moiré"
        layer1Spacing = 4.0
        layer2Spacing = 4.3
        layer2Thickness = 0.8
        shapeFontSize = 60.0
    }

    func applyShapePresetLarge() {
        patternMode = .shapeMoire
        reset()
        shapeText = "ABC"
        layer1Spacing = 8.0
        layer2Spacing = 8.5
        layer2Thickness = 1.5
        shapeFontSize = 120.0
    }
}
