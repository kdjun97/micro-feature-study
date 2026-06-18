public final class HomeViewModel {
    var onRoute: ((HomeRoute) -> Void)?
    var onViewState: ((HomeViewState) -> Void)?
    
    deinit {
        print("❎ HomeViewModel deinit!")
    }
    
    public init() {
        print("⭕ HomeViewModel init!")
    }

    enum HomeAction {
        case buttonTapped
        case dismissAlert
        case alertButtonTapped(HomeAlertCase)
    }
    
    enum HomeRoute {
        case detailRequested
    }

    enum HomeViewState {
        case showAlert(HomeAlertCase?)
    }
    
    func send(_ action: HomeAction) {
        switch action {
        case .buttonTapped:
            onRoute?(.detailRequested)
        case .alertButtonTapped(let alertCase):
            onViewState?(.showAlert(alertCase))
        case .dismissAlert:
            onViewState?(.showAlert(nil))
        }
    }
}

enum HomeAlertCase: Equatable {
    case tip
    case stopEditing
}
