import SwiftUI

struct MoireCanvasView: View {
    @ObservedObject var viewModel: MoireViewModel
    @State private var dragStart: CGSize = .zero

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                viewModel.backgroundColor

                if viewModel.showLayer1 {
                    LinePatternLayer(
                        spacing: viewModel.layer1Spacing,
                        thickness: viewModel.layer1Thickness,
                        angle: viewModel.layer1Angle,
                        offset: viewModel.layer1Offset,
                        color: viewModel.layer1Color,
                        canvasSize: geometry.size
                    )
                }

                if viewModel.showLayer2 {
                    LinePatternLayer(
                        spacing: viewModel.layer2Spacing,
                        thickness: viewModel.layer2Thickness,
                        angle: viewModel.layer2Angle,
                        offset: viewModel.layer2Offset,
                        color: viewModel.layer2Color,
                        canvasSize: geometry.size
                    )
                    .blendMode(.darken)
                }
            }
            .clipped()
            .gesture(dragGesture)
            .overlay(alignment: .topLeading) {
                layerIndicator
                    .padding(8)
            }
        }
    }

    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                let translation = value.translation
                switch viewModel.dragMode {
                case .translate:
                    if viewModel.activeLayer == 1 {
                        viewModel.layer1Offset = CGSize(
                            width: dragStart.width + translation.width,
                            height: dragStart.height + translation.height
                        )
                    } else {
                        viewModel.layer2Offset = CGSize(
                            width: dragStart.width + translation.width,
                            height: dragStart.height + translation.height
                        )
                    }
                case .rotate:
                    let rotationAmount = translation.width * 0.2
                    if viewModel.activeLayer == 1 {
                        viewModel.layer1Angle = dragStart.width + rotationAmount
                    } else {
                        viewModel.layer2Angle = dragStart.width + rotationAmount
                    }
                }
            }
            .onEnded { _ in
                updateDragStart()
            }
    }

    private func updateDragStart() {
        switch viewModel.dragMode {
        case .translate:
            if viewModel.activeLayer == 1 {
                dragStart = viewModel.layer1Offset
            } else {
                dragStart = viewModel.layer2Offset
            }
        case .rotate:
            if viewModel.activeLayer == 1 {
                dragStart = CGSize(width: viewModel.layer1Angle, height: 0)
            } else {
                dragStart = CGSize(width: viewModel.layer2Angle, height: 0)
            }
        }
    }

    private var layerIndicator: some View {
        HStack(spacing: 4) {
            Circle()
                .fill(viewModel.activeLayer == 1 ? Color.blue : Color.red)
                .frame(width: 8, height: 8)
            Text("Dragging Layer \(viewModel.activeLayer)")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 6))
    }
}

struct LinePatternLayer: View {
    let spacing: Double
    let thickness: Double
    let angle: Double
    let offset: CGSize
    let color: Color
    let canvasSize: CGSize

    var body: some View {
        Canvas { context, size in
            let totalSpacing = spacing + thickness
            guard totalSpacing > 0 else { return }

            // Calculate the diagonal to ensure full coverage when rotated
            let diagonal = sqrt(size.width * size.width + size.height * size.height)
            let lineCount = Int(diagonal / totalSpacing) + 2

            // Apply transformations
            context.translateBy(x: size.width / 2, y: size.height / 2)
            context.rotate(by: .degrees(angle))
            context.translateBy(x: offset.width, y: offset.height)
            context.translateBy(x: -size.width / 2, y: -size.height / 2)

            // Draw lines centered on the canvas
            let startX = (size.width - diagonal) / 2
            let startY = (size.height - diagonal) / 2

            for i in 0..<lineCount {
                let x = startX + Double(i) * totalSpacing
                let rect = CGRect(
                    x: x,
                    y: startY,
                    width: thickness,
                    height: diagonal
                )
                context.fill(Path(rect), with: .color(color))
            }
        }
    }
}

#Preview {
    MoireCanvasView(viewModel: MoireViewModel())
}
