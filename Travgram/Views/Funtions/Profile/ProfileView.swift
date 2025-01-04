//
//  ProfileView.swift
//  Travgram
//
//  Created by Jesse Liang on 2024/12/24.
//

import SwiftUI
import SwiftData
import TipKit

struct ProfileView: View {
    @EnvironmentObject var userManager: UserManager
    @State private var isShowingLoginView = false
    @State private var isEditingProfile = false

    var body: some View {
        NavigationView {
            ZStack {
                // Background Image
                Image("profile") // Replace with your background image name
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                    .opacity(0.5)

                // Main Content
                ScrollView {
                    VStack(spacing: 30) {
                        // Profile Header
                        if let currentUser = userManager.currentUser {
                            ProfileHeaderView(user: currentUser, isEditing: $isEditingProfile)
                        } else {
                            Text("Loading user data...")
                                .foregroundColor(.gray)
                                .italic()
                        }

                        Divider()
                            .padding(.horizontal)

                        // User Details Section
                        if let currentUser = userManager.currentUser {
                            VStack(alignment: .leading, spacing: 15) {
                                ProfileDetailRow(title: "Username", value: currentUser.username)
                                ProfileDetailRow(title: "Email", value: currentUser.email) // Assuming email is non-optional
                                if let fullname = currentUser.fullname, !fullname.isEmpty {
                                    ProfileDetailRow(title: "Full Name", value: fullname)
                                }
                                if let bio = currentUser.bio, !bio.isEmpty {
                                    ProfileDetailRow(title: "Bio", value: bio)
                                }
                            }
                            .padding()
                        }

                        Spacer()

                        // Logout Button
                        Button(action: {
                            userManager.logout()
                            isShowingLoginView = true
                        }) {
                            Text("Logout")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.red)
                                .cornerRadius(10)
                        }
                        .padding(.horizontal)
                    }
                    .padding()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
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
    }
}

struct ProfileDetailRow: View {
    let title: String
    let value: String

    var body: some View {
        HStack {
            Text(title)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.gray)
            Spacer()
            Text(value)
                .font(.subheadline)
                .foregroundColor(.primary)
                .multilineTextAlignment(.trailing)
        }
        .padding(.vertical, 5)
        .padding(.horizontal)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
    }
}
