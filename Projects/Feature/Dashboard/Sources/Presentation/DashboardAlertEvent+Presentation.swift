import DashboardInterface

extension DashboardAlertEvent {
    var title: String {
        switch self {
        case .tip:
            "[꿀팁] 테스트 꿀팁!"
        case .stopEditing:
            "편집을 중단할까요?"
        }
    }

    var contents: String {
        switch self {
        case .tip:
            "어떤게 꿀팁이 될 수 있을지 잘 모르겠지만 일단은 적어봄."
        case .stopEditing:
            "편집을 중단하시면 지금까지 수정한 내용이 모두 삭제됩니다."
        }
    }

    var primaryButtonTitle: String {
        "닫기"
    }

    var secondaryButtonTitle: String? {
        switch self {
        case .tip:
            nil
        case .stopEditing:
            "확인"
        }
    }

    var isDismissable: Bool {
        switch self {
        case .tip:
            true
        case .stopEditing:
            false
        }
    }
}
