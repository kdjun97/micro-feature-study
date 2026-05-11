//
//  ContentView.swift
//  TuistTemplate
//
//  Created by 김동준 on 9/7/25
//

import SwiftUI

@main
struct TuistTestApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

#Preview {
    VStack {
        Text("dd")
    }
}

public struct ContentView: View {
    public init() {}

    public var body: some View {
        Text("Hello, World!")
            .padding()
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
