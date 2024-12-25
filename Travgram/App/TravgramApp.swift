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
    private static let modelContainer: ModelContainer = {
        // 初始化 ModelContainer 並加入多個模型
        try! ModelContainer(for: User.self, Trip.self)
    }()

    init() {
        _userManager = StateObject(wrappedValue: UserManager(context: Self.modelContainer.mainContext))
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(userManager)
                .modelContainer(Self.modelContainer) // 正確傳遞 ModelContainer
        }
    }
}
