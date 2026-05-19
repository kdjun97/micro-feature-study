import SwiftUI

public enum DetailRoute: Equatable {
    case logout
}

@MainActor
public protocol DetailRouting: AnyObject {
    func route(from route: DetailRoute)
}

public protocol DetailBuildable {
    @MainActor
    func makeDetailView(router: DetailRouting) -> AnyView
}

public protocol DetailUseCaseProtocol {
    func title() -> String
    func logout() async -> Bool
}
