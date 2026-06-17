import UIKit

public enum DetailRoute: Equatable {
    case sheet
    case logout
}

@MainActor
public protocol DetailRouting: AnyObject {
    func route(from route: DetailRoute)
}

public protocol DetailBuildable {
    @MainActor
    func makeDetailViewController(router: DetailRouting) -> UIViewController

    @MainActor
    func makeDetailSheetViewController() -> UIViewController
}

public protocol DetailUseCaseProtocol {
    func title() -> String
    func logout() async -> Bool
}
