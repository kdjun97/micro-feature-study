import SwiftUI

public struct DetailView: View {
    @StateObject private var viewModel: DetailViewModel

    public init(viewModel: DetailViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        VStack(spacing: 16) {
            Text(viewModel.title)
                .font(.title)

            Text(viewModel.logoutMessage)
            Text(viewModel.userProfileMessage)

            if viewModel.isLoading {
                ProgressView()
            }

            Button("Logout") {
                Task {
                    await viewModel.logoutButtonTapped()
                }
            }
            .disabled(viewModel.isLoading)
        }
        .padding()
        .alert("Logout Failed", isPresented: $viewModel.isLogoutFailedAlertPresented) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.logoutMessage)
        }
    }
}
