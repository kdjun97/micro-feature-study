import MyPageInterface

struct SupportCellModel: Equatable {
    let item: MyPageSupportItem
    let index: Int
    let totalCount: Int
    let appVersion: String

    var hideDivider: Bool {
        index == totalCount - 1
    }
}
