public final class DetailViewModel {
    var onOutput: ((DetailOutput) -> Void)?
    
    enum DetailAction {
        case sheetButtonTapped
    }
    
    public init() {
        print("⭕ DetailViewModel init!")
    }
    
    deinit {
        print("❎ DetailViewModel deinit!")
    }

    enum DetailOutput {
        case onPresentSheet
    }
    
    func send(_ action: DetailAction) {
        switch action {
        case .sheetButtonTapped:
            onOutput?(.onPresentSheet)
        }
    }
}
