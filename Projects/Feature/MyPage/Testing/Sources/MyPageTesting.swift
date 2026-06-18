import MyPageInterface

public struct MyPageTesting {
    public init() {}
}

public struct MyPageUseCaseStub: MyPageUseCaseProtocol {
    public var userNameValue: String
    public var emotionRecordCountValue: Int
    public var supportItemsValue: [MyPageSupportItem]
    public var appVersionValue: String
    public var logoutResult: Bool

    public init(
        userNameValue: String = "테스트",
        emotionRecordCountValue: Int = 0,
        supportItemsValue: [MyPageSupportItem] = MyPageSupportItem.allCases,
        appVersionValue: String = "0.0.0",
        logoutResult: Bool = true
    ) {
        self.userNameValue = userNameValue
        self.emotionRecordCountValue = emotionRecordCountValue
        self.supportItemsValue = supportItemsValue
        self.appVersionValue = appVersionValue
        self.logoutResult = logoutResult
    }

    public func userName() -> String { userNameValue }
    public func emotionRecordCount() -> Int { emotionRecordCountValue }
    public func supportItems() -> [MyPageSupportItem] { supportItemsValue }
    public func appVersion() -> String { appVersionValue }
    public func logout() async -> Bool { logoutResult }
}
