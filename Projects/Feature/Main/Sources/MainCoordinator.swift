import DetailInterface
import SwiftUI

// MARK: 추후 리팩토링, Main + Root
@MainActor
public final class MainCoordinator: ObservableObject {
    @Published public var path: [MainDestination] = []

    public weak var delegate: MainCoordinatorDelegate?
    private let detailBuilder: DetailBuildable

    public init(detailBuilder: DetailBuildable) {
        self.detailBuilder = detailBuilder
    }

    public func startDetail() {
        path.removeAll()
    }

    public func makeRootView() -> AnyView {
        detailBuilder.makeDetailView(router: self)
    }

    public func makeDestinationView(_ destination: MainDestination) -> AnyView {
        switch destination {
        case .detail:
            detailBuilder.makeDetailView(router: self)
        }
    }
}
