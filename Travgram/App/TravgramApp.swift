//
//  TravgramApp.swift
//  Travgram
//
//  Created by Jesse Liang on 2024/12/23.
//

import SwiftUI
import SwiftData
import TipKit

@main
struct TravgramApp: App {
    @StateObject private var userManager: UserManager
    private static let modelContainer: ModelContainer = {
        do {
            return try ModelContainer(for: User.self, Trip.self)
        } catch {
            fatalError("Failed to initialize ModelContainer: \(error)")
        }
    }()

    init() {
        _userManager = StateObject(wrappedValue: UserManager(context: Self.modelContainer.mainContext))
        
        // 提示系統初始化
        configureTips()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(userManager)
                .modelContainer(Self.modelContainer)
        }
    }
    
    // 配置 TipKit
    private func configureTips() {
        do {
            try Tips.configure([
                .displayFrequency(.hourly), // 設置提示每日顯示
                .datastoreLocation(.applicationDefault) // 預設的資料存儲位置
            ])
        } catch {
            print("TipKit 配置失敗: \(error.localizedDescription)")
        }
    }
}
