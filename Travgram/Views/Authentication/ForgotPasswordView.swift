//
//  ForgotPasswordView.swift
//  Travgram
//
//  Created by Jesse Liang on 2024/12/23.
//

//
//  ForgotPasswordView.swift
//  Travgram
//
//  Created by Jesse Liang on 2024/12/24.
//

import SwiftUI
import SwiftData
import TipKit

struct ForgotPasswordView: View {
    @State private var email = ""
    @State private var showConfirmation = false
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        VStack(spacing: 20) {
            Text("Forgot Password")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()

            Text("Enter your email address and we'll send you a link to reset your password.")
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            TextField("Email Address", text: $email)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            Button(action: sendPasswordReset) {
                Text("Send Reset Link")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding(.horizontal)

            Spacer()
        }
        .padding()
        .alert("Reset Link Sent", isPresented: $showConfirmation) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("If this email address exists, a reset link has been sent to it.")
        }
    }

    func sendPasswordReset() {
        // 模擬的密碼重置邏輯
        let fetchRequest = FetchDescriptor<User>(predicate: #Predicate { $0.email == email })

        do {
            let users = try modelContext.fetch(fetchRequest)
            if users.isEmpty {
                print("No user found with this email.")
            } else {
                // 模擬發送重置密碼的邏輯
                print("Password reset link sent to \(email)")
            }
            showConfirmation = true
        } catch {
            print("Error searching for user: \(error)")
        }
    }
}

#Preview {
    ForgotPasswordView()
}
