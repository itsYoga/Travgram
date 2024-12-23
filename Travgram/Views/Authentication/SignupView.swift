//
//  SignupView.swift
//  Travgram
//
//  Created by Jesse Liang on 2024/12/23.
//

import SwiftUI
import SwiftData

struct SignupView: View {
    @State private var username = ""
    @State private var password = ""
    @State private var email = ""
    @State private var emailValid = true
    @State private var passwordValid = true
    @State private var emailInUse = false // Track duplicate email error
    @Environment(\.modelContext) private var modelContext
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
                        passwordValid = password.count >= 8
                    }

                // Email Field with validation
                TextField("Email", text: $email)
                    .autocapitalization(.none)
                    .modifier(VGTextFieldModifier())
                    .onChange(of: email) { _ in
                        emailValid = isValidEmail(email)
                    }

                // Validation messages
                if !emailValid {
                    Text("Please enter a valid email.")
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
                    Text("This email is already in use.")
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
                .disabled(!emailValid || !passwordValid || username.isEmpty) // Disable button if validation fails

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
            .navigationBarBackButtonHidden(true) // Hide the default back button
        }
    }

    func signupUser() {
        // Check if email already exists
        let fetchDescriptor = FetchDescriptor<User>(
            predicate: #Predicate { $0.email == email }
        )

        do {
            let existingUsers = try modelContext.fetch(fetchDescriptor)
            if !existingUsers.isEmpty {
                // Email already in use
                emailInUse = true
                return
            }

            // Create new user
            let newUser = User(username: username, email: email, password: password)
            modelContext.insert(newUser)
            try modelContext.save()
            showTip = true // Show success tip
        } catch {
            print("Error saving user: \(error)")
        }
    }

    // Email validation using regular expression
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
}

#Preview {
    let container = try? ModelContainer(for: User.self)
    return SignupView()
        .modelContainer(container!)
}
