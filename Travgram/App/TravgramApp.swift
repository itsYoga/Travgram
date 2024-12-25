//
//  TravgramApp.swift
//  Travgram
//
//  Created by Jesse Liang on 2024/12/23.
//

import SwiftUI
import SwiftData

@main
struct TravgramApp: App {
    @StateObject private var userManager: UserManager

    init() {
        let modelContainer = try! ModelContainer(for: User.self)
        _userManager = StateObject(wrappedValue: UserManager(context: modelContainer.mainContext))
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(userManager)
                .modelContainer(for: User.self)
        }
    }
}
