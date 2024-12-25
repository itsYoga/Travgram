//
//  ProfileView.swift
//  Travgram
//
//  Created by Jesse Liang on 2024/12/24.
//

import SwiftUI
import SwiftData

struct ProfileView: View {
    @EnvironmentObject var userManager: UserManager
    @State private var isShowingLoginView = false
    @State private var isEditingProfile = false

    var body: some View {
        VStack(spacing: 20) {
            // 檢查 currentUser 是否存在
            if let currentUser = userManager.currentUser {
                ProfileHeaderView(user: currentUser, isEditing: $isEditingProfile)
            } else {
                Text("Loading user data...")
                    .foregroundColor(.gray)
            }

            Spacer()

            // Logout 按鈕
            Button("Logout") {
                userManager.logout()
                isShowingLoginView = true
            }
            .padding()
            .background(Color.red)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .onAppear {
            debugCurrentUser()
        }
        .padding()
        .navigationTitle("Profile")
        .navigationBarBackButtonHidden(true)
        .fullScreenCover(isPresented: $isShowingLoginView) {
            LoginView()
                .environmentObject(userManager)
        }
        .sheet(isPresented: $isEditingProfile) {
            if let currentUser = userManager.currentUser {
                EditProfileView(user: currentUser)
                    .environment(\.modelContext, userManager.modelContext)
            }
        }
    }

    private func debugCurrentUser() {
        if let currentUser = userManager.currentUser {
            print("Current user is \(currentUser.username)")
        } else {
            print("No current user available!")
        }
    }
}
