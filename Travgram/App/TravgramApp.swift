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
    private let modelContainer: ModelContainer

    init() {
        do {
            modelContainer = try ModelContainer(for: User.self, Trip.self)
            let context = ModelContext(modelContainer)
            _userManager = StateObject(wrappedValue: UserManager(context: context))
        } catch {
            fatalError("Unable to create ModelContainer: \(error.localizedDescription)")
        }
    }

    var body: some Scene {
        WindowGroup {
            if userManager.isLoggedIn {
                MainPageView()
                    .environmentObject(userManager)
                    .modelContainer(modelContainer)
            } else {
                LoginView()
                    .environmentObject(userManager)
                    .modelContainer(modelContainer)
            }
        }
    }
}
