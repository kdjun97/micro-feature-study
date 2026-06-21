import UIKit

public enum SignInRoute: Equatable {
    case signInSucceeded
    case dashboardRequested
    case signInDetailRequested
    case signInDetailBackRequested
}

@MainActor
public protocol SignInRouting: AnyObject {
    func route(from route: SignInRoute)
}

public protocol SignInBuildable {
    @MainActor
    func makeSignInViewController(router: SignInRouting) -> UIViewController

    @MainActor
    func makeSignInDetailViewController(router: SignInRouting) -> UIViewController
}

public protocol SignInUseCaseProtocol {
    func signIn() async -> Bool
}
