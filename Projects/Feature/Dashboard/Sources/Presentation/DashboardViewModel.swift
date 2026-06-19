import DashboardInterface

public final class HomeViewModel {
    var onRoute: ((HomeRoute) -> Void)?
    
    deinit {
        print("❎ HomeViewModel deinit!")
    }
    
    public init() {
        print("⭕ HomeViewModel init!")
    }

    enum HomeAction {
        case buttonTapped
        case alertButtonTapped(DashboardAlertEvent)
    }
    
    enum HomeRoute {
        case detailRequested
        case alertRequested(DashboardAlertEvent)
    }
    
    func send(_ action: HomeAction) {
        switch action {
        case .buttonTapped:
            onRoute?(.detailRequested)
        case .alertButtonTapped(let alertCase):
            onRoute?(.alertRequested(alertCase))
        }
    }
}
