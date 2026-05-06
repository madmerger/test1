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
    }

    enum DragMode: String, CaseIterable {
        case translate = "Move"
        case rotate = "Rotate"
    }

    func reset() {
        layer1Thickness = 3.0
        layer1Angle = 0.0
        layer1Offset = .zero

        layer2Thickness = 3.0
        layer2Angle = 0.0
        layer2Offset = .zero

        activeLayer = 2

        switch patternMode {
        case .lines:
            layer1Spacing = 8.0
            layer2Spacing = 8.5
        case .circles:
            layer1Spacing = 10.0
            layer2Spacing = 10.5
        }
    }

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
}
