//
//  SignupView.swift
//  Travgram
//
//  Created by Jesse Liang on 2024/12/23.
//

import SwiftUI
import SwiftData
import TipKit

struct SignupView: View {
    @State private var username = ""
    @State private var password = ""
    @State private var email = ""
    @State private var emailValid = true
    @State private var passwordValid = true
    @State private var emailInUse = false
    @EnvironmentObject var userManager: UserManager
    @Environment(\.dismiss) private var dismiss
    @State private var showTip = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                Text("Sign Up")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.top)

                Text("Create your account to start using Travgram")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)

                // Username Field
                TextField("Username", text: $username)
                    .autocapitalization(.none)
                    .modifier(VGTextFieldModifier())
                    .padding(.top)

                // Password Field with validation
                SecureField("Password", text: $password)
                    .autocapitalization(.none)
                    .modifier(VGTextFieldModifier())
                    .onChange(of: password) { _ in
                        validatePassword()
                    }

                // Email Field with validation
                TextField("Email", text: $email)
                    .autocapitalization(.none)
                    .modifier(VGTextFieldModifier())
                    .onChange(of: email) { _ in
                        validateEmail()
                    }

                // Validation messages
                if !emailValid {
                    Text("Please enter a valid email address.")
                        .font(.footnote)
                        .foregroundColor(.red)
                        .padding(.top, 4)
                }

                if !passwordValid {
                    Text("Password must be at least 8 characters long.")
                        .font(.footnote)
                        .foregroundColor(.red)
                        .padding(.top, 4)
                }

                if emailInUse {
                    Text("This email is already in use. Please try another.")
                        .font(.footnote)
                        .foregroundColor(.red)
                        .padding(.top, 4)
                }

                // Sign Up Button
                Button(action: signupUser) {
                    Text("Sign Up")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(width: 360, height: 44)
                        .background(Color(.systemBlue))
                        .cornerRadius(8)
                }
                .padding(.vertical)
                .disabled(!emailValid || !passwordValid || username.isEmpty)

                Spacer()

                Divider()

                // Navigation link to LoginView
                NavigationLink(destination: LoginView()) {
                    HStack(spacing: 3) {
                        Text("Already have an account?")
                        Text("Log In")
                            .fontWeight(.semibold)
                    }
                    .font(.footnote)
                }
                .padding(.vertical, 16)
            }
            .alert("Sign Up Successful", isPresented: $showTip) {
                Button("OK") {
                    dismiss()
                }
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Image(systemName: "chevron.left")
                        .imageScale(.large)
                        .onTapGesture {
                            dismiss()
                        }
                }
            }
            .navigationBarBackButtonHidden(true)
        }
    }

    // MARK: - Validation
    private func validateEmail() {
        emailValid = isValidEmail(email)
    }

    private func validatePassword() {
        passwordValid = password.count >= 8
    }

    // MARK: - Sign Up Logic
    private func signupUser() {
        guard emailValid, passwordValid else {
            return
        }

        do {
            let fetchDescriptor = FetchDescriptor<User>(predicate: #Predicate { $0.email == email })
            let existingUsers = try userManager.modelContext.fetch(fetchDescriptor)
            if !existingUsers.isEmpty {
                emailInUse = true
                return
            }

            userManager.register(username: username, email: email, password: password)
            showTip = true
        } catch {
            print("Error during signup: \(error.localizedDescription)")
        }
    }

    // Email validation using regular expression
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
}

#Preview {
    let container = try! ModelContainer(for: User.self)
    let userManager = UserManager(context: container.mainContext)

    return SignupView()
        .environmentObject(userManager)
        .modelContainer(container)
}
