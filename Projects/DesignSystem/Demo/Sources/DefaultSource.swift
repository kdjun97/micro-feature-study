// default
import SwiftUI
import DesignSystem

@main
struct PreviewApp: App {
    var body: some Scene {
        WindowGroup {
            DesignSystemView() 
        }
    }
}

#Preview {
    DesignSystemView()
}
