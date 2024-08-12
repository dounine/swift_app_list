//
//  ContentView.swift
//  swift_app_list
//
//  Created by lake on 2024/8/12.
//

import SwiftUI

struct ContentView: View {
    let app = LSApp()
    @State var list = [LSApp.Info]()
    var body: some View {
        List {
            ForEach(list, id: \.bundleId) { item in
                HStack {
                    Image(systemName: "wifi")
                    VStack(alignment: .leading) {
                        Text(item.appName)
                        Group {
                            Text(item.version)
                            Text(item.bundleId)
                        }
                        .foregroundStyle(.secondary)
                    }
                    .lineLimit(1)
                }
            }
        }
        .task {
            list = app.appList()
        }
//        VStack {
//            Image(systemName: "globe")
//                .imageScale(.large)
//                .foregroundStyle(.tint)
//            Text("Hello, world!")
//        }
//        .padding()
    }
}

#Preview {
    ContentView()
}
