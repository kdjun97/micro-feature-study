import DetailInterface
import SwiftUI

public struct DetailTesting {
    public init() {}
}

public final class MockDetailUseCase: DetailUseCaseProtocol {
    public private(set) var titleCallCount = 0
    public private(set) var logoutCallCount = 0

    private let stubbedTitle: String
    private let logoutResult: Bool

    public init(
        title: String = "Detail",
        logoutResult: Bool = true
    ) {
        self.stubbedTitle = title
        self.logoutResult = logoutResult
    }

    public static func success(title: String = "Detail") -> MockDetailUseCase {
        MockDetailUseCase(title: title, logoutResult: true)
    }

    public static func failure(title: String = "Detail") -> MockDetailUseCase {
        MockDetailUseCase(title: title, logoutResult: false)
    }

    public func title() -> String {
        titleCallCount += 1
        return stubbedTitle
    }

    public func logout() async -> Bool {
        logoutCallCount += 1
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        return logoutResult
    }
}

@MainActor
public final class MockDetailRouter: DetailRouting {
    public private(set) var routes: [DetailRoute] = []

    public init() {}

    public func route(from route: DetailRoute) {
        routes.append(route)
    }
}
