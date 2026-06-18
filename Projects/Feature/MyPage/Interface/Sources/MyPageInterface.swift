import UIKit

public enum MyPageRoute: Equatable, Sendable {
    case logoutRequested
}

@MainActor
public protocol MyPageRouting: AnyObject {
    func route(from route: MyPageRoute)
}

public protocol MyPageBuildable {
    @MainActor
    func makeMyPageViewController(router: MyPageRouting) -> UIViewController
}

public enum MyPageSupportItem: CaseIterable, Equatable, Sendable {
    case versionInfo
    case termsOfService
    case privacyPolicy
    case logout

    public var title: String {
        switch self {
        case .versionInfo: "버전 정보"
        case .termsOfService: "서비스 이용 약관"
        case .privacyPolicy: "개인정보처리방침"
        case .logout: "로그아웃"
        }
    }
}

public protocol MyPageUseCaseProtocol: Sendable {
    func userName() -> String
    func emotionRecordCount() -> Int
    func supportItems() -> [MyPageSupportItem]
    func appVersion() -> String
    func logout() async -> Bool
}
