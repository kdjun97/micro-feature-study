import DashboardInterface

public final class HomeViewModel {
    var onOutput: ((HomeOutput) -> Void)?
    
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
    
    enum HomeOutput {
        case onPushDetail
        case showAlert(HomeAlertCase?)
    }
    
    func send(_ action: HomeAction) {
        switch action {
        case .buttonTapped:
            onOutput?(.onPushDetail)
        case .alertButtonTapped(let alertCase):
            onOutput?(.showAlert(alertCase))
        case .dismissAlert:
            onOutput?(.showAlert(nil))
        }
    }
}
