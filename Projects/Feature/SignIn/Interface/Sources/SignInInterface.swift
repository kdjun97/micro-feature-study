import SwiftUI

public enum SignInRoute: Equatable {
    case signInSucceeded
    case dashboardRequested
}

@MainActor
public protocol SignInRouting: AnyObject {
    func route(from route: SignInRoute)
}

public protocol SignInBuildable {
    @MainActor
    func makeSignInView(router: SignInRouting) -> AnyView
}
