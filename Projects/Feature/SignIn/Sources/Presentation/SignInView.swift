import SwiftUI

public struct SignInView: View {
    @StateObject private var viewModel: SignInViewModel

    public init(viewModel: SignInViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        VStack(spacing: 16) {
            Text("SignIn")
                .font(.title)
            Text(viewModel.errorMessage)
            Text(viewModel.userProfileMessage)
            if viewModel.isLoading {
                ProgressView()
            }
            Button("Sign In") {
                Task {
                    await viewModel.signInButtonTapped()
                }
            }
            .disabled(viewModel.isLoading)
            Button("Dashboard") {
                viewModel.dashboardButtonTapped()
            }
        }
        .padding()
    }
}
