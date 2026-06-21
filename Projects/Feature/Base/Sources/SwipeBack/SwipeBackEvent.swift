@MainActor
public protocol SwipeBackEventReceivable: AnyObject {
    func swipeBackDidComplete()
    func swipeBackDidCancel()
}
