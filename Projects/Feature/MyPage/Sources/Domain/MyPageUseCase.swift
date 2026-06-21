import Foundation
import MyPageInterface

public struct MyPageUseCase: MyPageUseCaseProtocol {
    public init() {}

    public func userName() -> String {
        "김시미"
    }

    public func emotionRecordCount() -> Int {
        0
    }

    public func supportItems() -> [MyPageSupportItem] {
        MyPageSupportItem.allCases
    }

    public func appVersion() -> String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
    }

    public func logout() async -> Bool {
        true
    }
}
