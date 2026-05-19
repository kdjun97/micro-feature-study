import SwiftUI

public struct DashboardView: View {
    @StateObject private var viewModel: DashboardViewModel

    public init(viewModel: DashboardViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        VStack(spacing: 16) {
            Text(viewModel.title)
                .font(.title)

            Button("Back") {
                viewModel.backButtonTapped()
            }
        }
        .padding()
    }
}
