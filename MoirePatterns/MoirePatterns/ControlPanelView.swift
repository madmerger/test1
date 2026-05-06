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
                layer1Section
                Divider()
                layer2Section
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
            .pickerStyle(.segmented)
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

            if viewModel.patternMode == .lines {
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
                label: "Spacing",
                value: $viewModel.layer1Spacing,
                range: 2...30,
                format: "%.1f px"
            )

            parameterSlider(
                label: "Thickness",
                value: $viewModel.layer1Thickness,
                range: 0.5...15,
                format: "%.1f px"
            )

            if viewModel.patternMode == .lines {
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
                label: "Spacing",
                value: $viewModel.layer2Spacing,
                range: 2...30,
                format: "%.1f px"
            )

            parameterSlider(
                label: "Thickness",
                value: $viewModel.layer2Thickness,
                range: 0.5...15,
                format: "%.1f px"
            )

            if viewModel.patternMode == .lines {
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
                presetButton("Classic") {
                    viewModel.applyLinePresetClassic()
                }
                presetButton("Fine") {
                    viewModel.applyLinePresetFine()
                }
            }

            HStack(spacing: 8) {
                presetButton("Angled") {
                    viewModel.applyLinePresetAngled()
                }
                presetButton("Wide") {
                    viewModel.applyLinePresetWide()
                }
            }
        }
    }

    private var circlePresets: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                presetButton("Classic") {
                    viewModel.applyCirclePresetClassic()
                }
                presetButton("Dense") {
                    viewModel.applyCirclePresetDense()
                }
            }

            HStack(spacing: 8) {
                presetButton("Offset") {
                    viewModel.applyCirclePresetOffset()
                }
                presetButton("Wide") {
                    viewModel.applyCirclePresetWide()
                }
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
