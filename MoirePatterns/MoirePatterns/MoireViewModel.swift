import SwiftUI
import Combine

class MoireViewModel: ObservableObject {
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
    @Published var activeLayer: Int = 2  // Which layer responds to drag (1 or 2)
    @Published var dragMode: DragMode = .translate

    enum DragMode: String, CaseIterable {
        case translate = "Move"
        case rotate = "Rotate"
    }

    func reset() {
        layer1Spacing = 8.0
        layer1Thickness = 3.0
        layer1Angle = 0.0
        layer1Offset = .zero

        layer2Spacing = 8.5
        layer2Thickness = 3.0
        layer2Angle = 0.0
        layer2Offset = .zero

        activeLayer = 2
    }
}
