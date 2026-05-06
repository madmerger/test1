import SwiftUI

struct ControlPanelView: View {
    @ObservedObject var viewModel: MoireViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                headerSection
                patternModeSection
                interactionSection
                Divider()
                if viewModel.patternMode == .shapeMoire {
                    shapeTextSection
                    Divider()
                    shapeBaseSection
                    Divider()
                    shapeRevealSection
                } else {
                    layer1Section
                    Divider()
                    layer2Section
                }
                Divider()
                presetsSection
                Spacer()
            }
        }
    }

    // MARK: - Header

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Moiré Patterns")
                .font(.title2)
                .fontWeight(.bold)
            Text("Drag on the canvas to move the active layer. Observe how the moiré pattern moves faster than the layer itself.")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }

    // MARK: - Pattern Mode

    private var patternModeSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Pattern")
                .font(.headline)

            Picker("Pattern", selection: $viewModel.patternMode) {
                ForEach(MoireViewModel.PatternMode.allCases, id: \.self) { mode in
                    Text(mode.rawValue).tag(mode)
                }
            }
            .pickerStyle(.menu)
            .onChange(of: viewModel.patternMode) { _, _ in
                viewModel.reset()
            }
        }
    }

    // MARK: - Interaction

    private var interactionSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Interaction")
                .font(.headline)

            Picker("Active Layer", selection: $viewModel.activeLayer) {
                Text("Layer 1").tag(1)
                Text("Layer 2").tag(2)
            }
            .pickerStyle(.segmented)

            if viewModel.supportsAngle {
                Picker("Drag Mode", selection: $viewModel.dragMode) {
                    ForEach(MoireViewModel.DragMode.allCases, id: \.self) { mode in
                        Text(mode.rawValue).tag(mode)
                    }
                }
                .pickerStyle(.segmented)
            }
        }
    }

    // MARK: - Layer 1

    private var layer1Section: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Layer 1 (Base)")
                    .font(.headline)
                Spacer()
                Toggle("", isOn: $viewModel.showLayer1)
                    .toggleStyle(.switch)
                    .labelsHidden()
            }

            parameterSlider(
                label: spacingLabel,
                value: $viewModel.layer1Spacing,
                range: spacingRange,
                format: "%.1f px"
            )

            if showsThickness {
                parameterSlider(
                    label: thicknessLabel,
                    value: $viewModel.layer1Thickness,
                    range: thicknessRange,
                    format: "%.1f px"
                )
            }

            if viewModel.supportsAngle {
                parameterSlider(
                    label: "Angle",
                    value: $viewModel.layer1Angle,
                    range: -90...90,
                    format: "%.1f°"
                )
            }

            ColorPicker("Color", selection: $viewModel.layer1Color)
        }
    }

    // MARK: - Layer 2

    private var layer2Section: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Layer 2 (Overlay)")
                    .font(.headline)
                Spacer()
                Toggle("", isOn: $viewModel.showLayer2)
                    .toggleStyle(.switch)
                    .labelsHidden()
            }

            parameterSlider(
                label: spacingLabel,
                value: $viewModel.layer2Spacing,
                range: spacingRange,
                format: "%.1f px"
            )

            if showsThickness {
                parameterSlider(
                    label: thicknessLabel,
                    value: $viewModel.layer2Thickness,
                    range: thicknessRange,
                    format: "%.1f px"
                )
            }

            if viewModel.supportsAngle {
                parameterSlider(
                    label: "Angle",
                    value: $viewModel.layer2Angle,
                    range: -90...90,
                    format: "%.1f°"
                )
            }

            ColorPicker("Color", selection: $viewModel.layer2Color)
        }
    }

    // MARK: - Mode-specific labels and ranges

    private var spacingLabel: String {
        switch viewModel.patternMode {
        case .checkerboard:
            return "Cell Size"
        case .dots:
            return "Spacing"
        default:
            return "Spacing"
        }
    }

    private var spacingRange: ClosedRange<Double> {
        switch viewModel.patternMode {
        case .checkerboard:
            return 3...40
        default:
            return 2...30
        }
    }

    private var thicknessLabel: String {
        switch viewModel.patternMode {
        case .dots:
            return "Dot Radius"
        default:
            return "Thickness"
        }
    }

    private var thicknessRange: ClosedRange<Double> {
        switch viewModel.patternMode {
        case .dots:
            return 0.5...10
        default:
            return 0.5...15
        }
    }

    private var showsThickness: Bool {
        viewModel.patternMode != .checkerboard && viewModel.patternMode != .shapeMoire
    }

    // MARK: - Shape Moiré Sections

    private var shapeTextSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Text")
                .font(.headline)
            TextField("Enter text", text: $viewModel.shapeText)
                .textFieldStyle(.roundedBorder)

            parameterSlider(
                label: "Font Size",
                value: $viewModel.shapeFontSize,
                range: 20...200,
                format: "%.0f pt"
            )
        }
    }

    private var shapeBaseSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Base Layer")
                    .font(.headline)
                Spacer()
                Toggle("", isOn: $viewModel.showLayer1)
                    .toggleStyle(.switch)
                    .labelsHidden()
            }

            parameterSlider(
                label: "Base Period (pb)",
                value: $viewModel.layer1Spacing,
                range: 2...20,
                format: "%.1f px"
            )

            ColorPicker("Color", selection: $viewModel.layer1Color)
        }
    }

    private var shapeRevealSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Reveal Layer")
                    .font(.headline)
                Spacer()
                Toggle("", isOn: $viewModel.showLayer2)
                    .toggleStyle(.switch)
                    .labelsHidden()
            }

            parameterSlider(
                label: "Reveal Period (pr)",
                value: $viewModel.layer2Spacing,
                range: 2...20,
                format: "%.1f px"
            )

            parameterSlider(
                label: "Slit Width",
                value: $viewModel.layer2Thickness,
                range: 0.3...5,
                format: "%.1f px"
            )
        }
    }

    // MARK: - Presets

    private var presetsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Presets")
                .font(.headline)

            switch viewModel.patternMode {
            case .lines:
                linePresets
            case .circles:
                circlePresets
            case .grid:
                gridPresets
            case .radial:
                radialPresets
            case .dots:
                dotPresets
            case .checkerboard:
                checkerPresets
            case .shapeMoire:
                shapePresets
            }

            Button("Reset All") {
                viewModel.reset()
            }
            .buttonStyle(.bordered)
        }
    }

    private var linePresets: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                presetButton("Classic") { viewModel.applyLinePresetClassic() }
                presetButton("Fine") { viewModel.applyLinePresetFine() }
            }
            HStack(spacing: 8) {
                presetButton("Angled") { viewModel.applyLinePresetAngled() }
                presetButton("Wide") { viewModel.applyLinePresetWide() }
            }
        }
    }

    private var circlePresets: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                presetButton("Classic") { viewModel.applyCirclePresetClassic() }
                presetButton("Dense") { viewModel.applyCirclePresetDense() }
            }
            HStack(spacing: 8) {
                presetButton("Offset") { viewModel.applyCirclePresetOffset() }
                presetButton("Wide") { viewModel.applyCirclePresetWide() }
            }
        }
    }

    private var gridPresets: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                presetButton("Classic") { viewModel.applyGridPresetClassic() }
                presetButton("Fine") { viewModel.applyGridPresetFine() }
            }
            HStack(spacing: 8) {
                presetButton("Angled") { viewModel.applyGridPresetAngled() }
                presetButton("Dense") { viewModel.applyGridPresetDense() }
            }
        }
    }

    private var radialPresets: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                presetButton("Classic") { viewModel.applyRadialPresetClassic() }
                presetButton("Dense") { viewModel.applyRadialPresetDense() }
            }
            HStack(spacing: 8) {
                presetButton("Offset") { viewModel.applyRadialPresetOffset() }
                presetButton("Wide") { viewModel.applyRadialPresetWide() }
            }
        }
    }

    private var dotPresets: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                presetButton("Classic") { viewModel.applyDotPresetClassic() }
                presetButton("Fine") { viewModel.applyDotPresetFine() }
            }
            HStack(spacing: 8) {
                presetButton("Angled") { viewModel.applyDotPresetAngled() }
                presetButton("Dense") { viewModel.applyDotPresetDense() }
            }
        }
    }

    private var checkerPresets: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                presetButton("Classic") { viewModel.applyCheckerPresetClassic() }
                presetButton("Fine") { viewModel.applyCheckerPresetFine() }
            }
            HStack(spacing: 8) {
                presetButton("Angled") { viewModel.applyCheckerPresetAngled() }
                presetButton("Large") { viewModel.applyCheckerPresetLarge() }
            }
        }
    }

    private var shapePresets: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                presetButton("Classic") { viewModel.applyShapePresetClassic() }
                presetButton("カタカナ") { viewModel.applyShapePresetKanji() }
            }
            HStack(spacing: 8) {
                presetButton("Fine") { viewModel.applyShapePresetFine() }
                presetButton("Large") { viewModel.applyShapePresetLarge() }
            }
        }
    }

    // MARK: - Helpers

    private func parameterSlider(
        label: String,
        value: Binding<Double>,
        range: ClosedRange<Double>,
        format: String
    ) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack {
                Text(label)
                    .font(.caption)
                Spacer()
                Text(String(format: format, value.wrappedValue))
                    .font(.caption)
                    .monospacedDigit()
                    .foregroundColor(.secondary)
            }
            Slider(value: value, in: range)
        }
    }

    private func presetButton(_ title: String, action: @escaping () -> Void) -> some View {
        Button(title, action: action)
            .buttonStyle(.bordered)
            .controlSize(.small)
    }
}

#Preview {
    ControlPanelView(viewModel: MoireViewModel())
        .frame(width: 260)
        .padding()
}
