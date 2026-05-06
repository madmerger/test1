import SwiftUI

struct MoireCanvasView: View {
    @ObservedObject var viewModel: MoireViewModel
    @State private var dragStart: CGSize = .zero

    private let sheetInset: CGFloat = 30

    var body: some View {
        GeometryReader { geometry in
            let sheetSize = CGSize(
                width: max(geometry.size.width - sheetInset * 2, 0),
                height: max(geometry.size.height - sheetInset * 2, 0)
            )

            ZStack {
                Color(nsColor: .windowBackgroundColor)

                if viewModel.patternMode == .shapeMoire {
                    shapeMoireContent(sheetSize: sheetSize)
                } else {
                    if viewModel.showLayer1 {
                        sheetView(borderColor: .blue) {
                            patternLayer(
                                spacing: viewModel.layer1Spacing,
                                thickness: viewModel.layer1Thickness,
                                angle: viewModel.layer1Angle,
                                offset: .zero,
                                color: viewModel.layer1Color,
                                canvasSize: sheetSize
                            )
                        }
                        .frame(width: sheetSize.width, height: sheetSize.height)
                        .offset(viewModel.layer1Offset)
                    }

                    if viewModel.showLayer2 {
                        sheetView(borderColor: .red) {
                            patternLayer(
                                spacing: viewModel.layer2Spacing,
                                thickness: viewModel.layer2Thickness,
                                angle: viewModel.layer2Angle,
                                offset: .zero,
                                color: viewModel.layer2Color,
                                canvasSize: sheetSize
                            )
                        }
                        .frame(width: sheetSize.width, height: sheetSize.height)
                        .offset(viewModel.layer2Offset)
                        .blendMode(.darken)
                    }
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

    private func sheetView<Content: View>(
        borderColor: Color,
        @ViewBuilder content: () -> Content
    ) -> some View {
        content()
            .background(viewModel.backgroundColor)
            .clipShape(Rectangle())
            .overlay(Rectangle().stroke(borderColor.opacity(0.4), lineWidth: 1.5))
            .shadow(color: .black.opacity(0.12), radius: 4, x: 2, y: 2)
    }

    @ViewBuilder
    private func shapeMoireContent(sheetSize: CGSize) -> some View {
        if viewModel.showLayer1 {
            sheetView(borderColor: .blue) {
                ShapeBaseLayer(
                    text: viewModel.shapeText,
                    basePeriod: viewModel.layer1Spacing,
                    fontSize: viewModel.shapeFontSize,
                    offset: .zero,
                    color: viewModel.layer1Color,
                    canvasSize: sheetSize
                )
            }
            .frame(width: sheetSize.width, height: sheetSize.height)
            .offset(viewModel.layer1Offset)
        }

        if viewModel.showLayer2 {
            sheetView(borderColor: .red) {
                ShapeRevealLayer(
                    revealPeriod: viewModel.layer2Spacing,
                    slitWidth: viewModel.layer2Thickness,
                    offset: .zero,
                    canvasSize: sheetSize
                )
            }
            .frame(width: sheetSize.width, height: sheetSize.height)
            .offset(viewModel.layer2Offset)
            .blendMode(.darken)
        }
    }

    @ViewBuilder
    private func patternLayer(
        spacing: Double,
        thickness: Double,
        angle: Double,
        offset: CGSize,
        color: Color,
        canvasSize: CGSize
    ) -> some View {
        switch viewModel.patternMode {
        case .lines:
            LinePatternLayer(
                spacing: spacing,
                thickness: thickness,
                angle: angle,
                offset: offset,
                color: color,
                canvasSize: canvasSize
            )
        case .circles:
            CirclePatternLayer(
                spacing: spacing,
                thickness: thickness,
                offset: offset,
                color: color,
                canvasSize: canvasSize
            )
        case .grid:
            GridPatternLayer(
                spacing: spacing,
                thickness: thickness,
                angle: angle,
                offset: offset,
                color: color,
                canvasSize: canvasSize
            )
        case .radial:
            RadialPatternLayer(
                spacing: spacing,
                thickness: thickness,
                offset: offset,
                color: color,
                canvasSize: canvasSize
            )
        case .dots:
            DotPatternLayer(
                spacing: spacing,
                dotRadius: thickness,
                angle: angle,
                offset: offset,
                color: color,
                canvasSize: canvasSize
            )
        case .checkerboard:
            CheckerboardPatternLayer(
                cellSize: spacing,
                angle: angle,
                offset: offset,
                color: color,
                canvasSize: canvasSize
            )
        case .shapeMoire:
            EmptyView()
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

// MARK: - Line Pattern

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

            let diagonal = sqrt(size.width * size.width + size.height * size.height)
            let lineCount = Int(diagonal / totalSpacing) + 2

            context.translateBy(x: size.width / 2, y: size.height / 2)
            context.rotate(by: .degrees(angle))
            context.translateBy(x: offset.width, y: offset.height)
            context.translateBy(x: -size.width / 2, y: -size.height / 2)

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

// MARK: - Circle Pattern

struct CirclePatternLayer: View {
    let spacing: Double
    let thickness: Double
    let offset: CGSize
    let color: Color
    let canvasSize: CGSize

    var body: some View {
        Canvas { context, size in
            let totalSpacing = spacing + thickness
            guard totalSpacing > 0 else { return }

            let centerX = size.width / 2 + offset.width
            let centerY = size.height / 2 + offset.height

            let diagonal = sqrt(size.width * size.width + size.height * size.height)
            let ringCount = Int(diagonal / totalSpacing) + 1

            for i in 0..<ringCount {
                let outerRadius = Double(i + 1) * totalSpacing
                let innerRadius = outerRadius - thickness
                guard innerRadius >= 0 else { continue }

                var path = Path()
                path.addArc(
                    center: CGPoint(x: centerX, y: centerY),
                    radius: outerRadius,
                    startAngle: .zero,
                    endAngle: .degrees(360),
                    clockwise: false
                )
                path.addArc(
                    center: CGPoint(x: centerX, y: centerY),
                    radius: innerRadius,
                    startAngle: .zero,
                    endAngle: .degrees(360),
                    clockwise: true
                )
                context.fill(path, with: .color(color))
            }
        }
    }
}

// MARK: - Grid Pattern

struct GridPatternLayer: View {
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

            let diagonal = sqrt(size.width * size.width + size.height * size.height)

            context.translateBy(x: size.width / 2, y: size.height / 2)
            context.rotate(by: .degrees(angle))
            context.translateBy(x: offset.width, y: offset.height)
            context.translateBy(x: -size.width / 2, y: -size.height / 2)

            let start = (size.width - diagonal) / 2
            let startY = (size.height - diagonal) / 2
            let count = Int(diagonal / totalSpacing) + 2

            for i in 0..<count {
                let x = start + Double(i) * totalSpacing
                let vRect = CGRect(x: x, y: startY, width: thickness, height: diagonal)
                context.fill(Path(vRect), with: .color(color))
            }

            for i in 0..<count {
                let y = startY + Double(i) * totalSpacing
                let hRect = CGRect(x: start, y: y, width: diagonal, height: thickness)
                context.fill(Path(hRect), with: .color(color))
            }
        }
    }
}

// MARK: - Radial Pattern

struct RadialPatternLayer: View {
    let spacing: Double
    let thickness: Double
    let offset: CGSize
    let color: Color
    let canvasSize: CGSize

    var body: some View {
        Canvas { context, size in
            let totalSpacing = spacing + thickness
            guard totalSpacing > 0.5 else { return }

            let centerX = size.width / 2 + offset.width
            let centerY = size.height / 2 + offset.height

            let diagonal = sqrt(size.width * size.width + size.height * size.height)
            let circumference = Double.pi * diagonal
            let rayCount = Int(circumference / totalSpacing)
            guard rayCount > 0 else { return }

            let angleStep = 360.0 / Double(rayCount)
            let angularThickness = angleStep * (thickness / totalSpacing)

            for i in 0..<rayCount {
                let startAngle = Double(i) * angleStep
                let endAngle = startAngle + angularThickness

                var path = Path()
                path.move(to: CGPoint(x: centerX, y: centerY))
                path.addArc(
                    center: CGPoint(x: centerX, y: centerY),
                    radius: diagonal,
                    startAngle: .degrees(startAngle),
                    endAngle: .degrees(endAngle),
                    clockwise: false
                )
                path.closeSubpath()
                context.fill(path, with: .color(color))
            }
        }
    }
}

// MARK: - Dot Pattern

struct DotPatternLayer: View {
    let spacing: Double
    let dotRadius: Double
    let angle: Double
    let offset: CGSize
    let color: Color
    let canvasSize: CGSize

    var body: some View {
        Canvas { context, size in
            let cellSize = spacing + dotRadius * 2
            guard cellSize > 0 else { return }

            let diagonal = sqrt(size.width * size.width + size.height * size.height)

            context.translateBy(x: size.width / 2, y: size.height / 2)
            context.rotate(by: .degrees(angle))
            context.translateBy(x: offset.width, y: offset.height)
            context.translateBy(x: -size.width / 2, y: -size.height / 2)

            let startX = (size.width - diagonal) / 2
            let startY = (size.height - diagonal) / 2
            let cols = Int(diagonal / cellSize) + 2
            let rows = Int(diagonal / cellSize) + 2

            for row in 0..<rows {
                for col in 0..<cols {
                    let cx = startX + Double(col) * cellSize + cellSize / 2
                    let cy = startY + Double(row) * cellSize + cellSize / 2
                    let dotRect = CGRect(
                        x: cx - dotRadius,
                        y: cy - dotRadius,
                        width: dotRadius * 2,
                        height: dotRadius * 2
                    )
                    context.fill(Path(ellipseIn: dotRect), with: .color(color))
                }
            }
        }
    }
}

// MARK: - Checkerboard Pattern

struct CheckerboardPatternLayer: View {
    let cellSize: Double
    let angle: Double
    let offset: CGSize
    let color: Color
    let canvasSize: CGSize

    var body: some View {
        Canvas { context, size in
            guard cellSize > 0 else { return }

            let diagonal = sqrt(size.width * size.width + size.height * size.height)

            context.translateBy(x: size.width / 2, y: size.height / 2)
            context.rotate(by: .degrees(angle))
            context.translateBy(x: offset.width, y: offset.height)
            context.translateBy(x: -size.width / 2, y: -size.height / 2)

            let startX = (size.width - diagonal) / 2
            let startY = (size.height - diagonal) / 2
            let cols = Int(diagonal / cellSize) + 2
            let rows = Int(diagonal / cellSize) + 2

            for row in 0..<rows {
                for col in 0..<cols {
                    guard (row + col) % 2 == 0 else { continue }
                    let x = startX + Double(col) * cellSize
                    let y = startY + Double(row) * cellSize
                    let rect = CGRect(x: x, y: y, width: cellSize, height: cellSize)
                    context.fill(Path(rect), with: .color(color))
                }
            }
        }
    }
}

// MARK: - Shape Moiré Base Layer

struct ShapeBaseLayer: View {
    let text: String
    let basePeriod: Double
    let fontSize: Double
    let offset: CGSize
    let color: Color
    let canvasSize: CGSize

    var body: some View {
        Canvas { context, size in
            guard basePeriod > 0, !text.isEmpty else { return }

            let font = Font.system(size: fontSize, weight: .bold)
            let resolved = context.resolve(Text(text).font(font).foregroundColor(color))
            let textSize = resolved.measure(in: CGSize(width: size.width * 2, height: .infinity))

            guard textSize.height > 0 else { return }

            let compressionRatio = basePeriod / textSize.height
            let tileCount = Int(size.height / basePeriod) + 3
            let yMod = offset.height.truncatingRemainder(dividingBy: basePeriod)

            for i in -1..<tileCount {
                var ctx = context
                let tileY = Double(i) * basePeriod + yMod
                ctx.translateBy(x: size.width / 2 + offset.width, y: tileY)
                ctx.scaleBy(x: 1.0, y: compressionRatio)
                ctx.draw(resolved, at: CGPoint(x: 0, y: 0), anchor: .top)
            }
        }
    }
}

// MARK: - Shape Moiré Reveal Layer

struct ShapeRevealLayer: View {
    let revealPeriod: Double
    let slitWidth: Double
    let offset: CGSize
    let canvasSize: CGSize

    var body: some View {
        Canvas { context, size in
            guard revealPeriod > 0, slitWidth > 0, slitWidth < revealPeriod else { return }

            let bandHeight = revealPeriod - slitWidth
            let bandCount = Int(size.height / revealPeriod) + 3
            let yMod = offset.height.truncatingRemainder(dividingBy: revealPeriod)

            for i in -1..<bandCount {
                let slitTop = Double(i) * revealPeriod + yMod
                let bandTop = slitTop + slitWidth
                let rect = CGRect(x: 0, y: bandTop, width: size.width, height: bandHeight)
                context.fill(Path(rect), with: .color(.black))
            }
        }
    }
}

#Preview {
    MoireCanvasView(viewModel: MoireViewModel())
}
