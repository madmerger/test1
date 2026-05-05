import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = MoireViewModel()

    var body: some View {
        HSplitView {
            MoireCanvasView(viewModel: viewModel)
                .frame(minWidth: 500, minHeight: 500)

            ControlPanelView(viewModel: viewModel)
                .frame(width: 260)
                .padding()
        }
    }
}

#Preview {
    ContentView()
}
