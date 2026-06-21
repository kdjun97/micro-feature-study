import MyPageInterface

public struct MyPageTesting {
    public init() {}
}

public struct MyPageMockState: Equatable, Sendable {
    public var userName: String
    public var emotionRecordCount: Int
    public var supportItems: [MyPageSupportItem]
    public var appVersion: String
    public var logoutResult: Bool

    public init(
        userName: String,
        emotionRecordCount: Int,
        supportItems: [MyPageSupportItem],
        appVersion: String,
        logoutResult: Bool
    ) {
        self.userName = userName
        self.emotionRecordCount = emotionRecordCount
        self.supportItems = supportItems
        self.appVersion = appVersion
        self.logoutResult = logoutResult
    }
}

public extension MyPageMockState {
    static let `default` = MyPageMockState(
        userName: "김시미",
        emotionRecordCount: 12,
        supportItems: MyPageSupportItem.allCases,
        appVersion: "1.0.0",
        logoutResult: true
    )
}

public enum MyPageMockPreset: CaseIterable, Sendable {
    case newUser
    case heavyUser
    case longName
    case betaVersion
    case minimalSupport
    case fullSupport
    case logoutFailure

    public var title: String {
        switch self {
        case .newUser: "신규 유저"
        case .heavyUser: "헤비 유저"
        case .longName: "긴 이름"
        case .betaVersion: "Beta 버전"
        case .minimalSupport: "고객지원 축소"
        case .fullSupport: "전체 메뉴"
        case .logoutFailure: "로그아웃 실패"
        }
    }

    public var state: MyPageMockState {
        switch self {
        case .newUser:
            MyPageMockState(
                userName: "처음 온 시미",
                emotionRecordCount: 0,
                supportItems: MyPageSupportItem.allCases,
                appVersion: "1.0.0",
                logoutResult: true
            )
        case .heavyUser:
            MyPageMockState(
                userName: "기록왕 김시미",
                emotionRecordCount: 13348,
                supportItems: MyPageSupportItem.allCases,
                appVersion: "1.0.0",
                logoutResult: true
            )
        case .longName:
            MyPageMockState(
                userName: "김시미이이이이이이이이이이이",
                emotionRecordCount: 42,
                supportItems: MyPageSupportItem.allCases,
                appVersion: "1.0.0",
                logoutResult: true
            )
        case .betaVersion:
            MyPageMockState(
                userName: "김시미",
                emotionRecordCount: 12,
                supportItems: MyPageSupportItem.allCases,
                appVersion: "2.0.0-beta",
                logoutResult: true
            )
        case .minimalSupport:
            MyPageMockState(
                userName: "김시미",
                emotionRecordCount: 12,
                supportItems: [.versionInfo],
                appVersion: "1.0.0",
                logoutResult: true
            )
        case .fullSupport:
            MyPageMockState.default
        case .logoutFailure:
            MyPageMockState(
                userName: "김시미",
                emotionRecordCount: 12,
                supportItems: MyPageSupportItem.allCases,
                appVersion: "1.0.0",
                logoutResult: false
            )
        }
    }
}

public struct MyPageUseCaseStub: MyPageUseCaseProtocol {
    private let stateProvider: @Sendable () -> MyPageMockState
    private let onLogoutFailed: (@MainActor @Sendable () -> Void)?

    public var userNameValue: String { stateProvider().userName }
    public var emotionRecordCountValue: Int { stateProvider().emotionRecordCount }
    public var supportItemsValue: [MyPageSupportItem] { stateProvider().supportItems }
    public var appVersionValue: String { stateProvider().appVersion }
    public var logoutResult: Bool { stateProvider().logoutResult }

    public init(
        userNameValue: String = "테스트",
        emotionRecordCountValue: Int = 0,
        supportItemsValue: [MyPageSupportItem] = MyPageSupportItem.allCases,
        appVersionValue: String = "0.0.0",
        logoutResult: Bool = true,
        onLogoutFailed: (@MainActor @Sendable () -> Void)? = nil
    ) {
        self.init(
            state: MyPageMockState(
                userName: userNameValue,
                emotionRecordCount: emotionRecordCountValue,
                supportItems: supportItemsValue,
                appVersion: appVersionValue,
                logoutResult: logoutResult
            ),
            onLogoutFailed: onLogoutFailed
        )
    }

    public init(
        state: MyPageMockState,
        onLogoutFailed: (@MainActor @Sendable () -> Void)? = nil
    ) {
        self.stateProvider = { state }
        self.onLogoutFailed = onLogoutFailed
    }

    public init(
        stateProvider: @escaping @Sendable () -> MyPageMockState,
        onLogoutFailed: (@MainActor @Sendable () -> Void)? = nil
    ) {
        self.stateProvider = stateProvider
        self.onLogoutFailed = onLogoutFailed
    }

    public func userName() -> String {
        stateProvider().userName
    }

    public func emotionRecordCount() -> Int {
        stateProvider().emotionRecordCount
    }

    public func supportItems() -> [MyPageSupportItem] {
        stateProvider().supportItems
    }

    public func appVersion() -> String {
        stateProvider().appVersion
    }

    public func logout() async -> Bool {
        let result = stateProvider().logoutResult
        if !result, let onLogoutFailed {
            await onLogoutFailed()
        }
        return result
    }
}
