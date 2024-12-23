//
//  LoginView.swift
//  Travgram
//
//  Created by Jesse Liang on 2024/12/23.
//

import SwiftUI
import SwiftData

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @Environment(\.modelContext) private var context
    @State private var loginError = false
    @State private var isLoggedIn = false // 控制導航到主頁

    var body: some View {
        NavigationStack {
            VStack {
                Spacer()

                // App 名稱
                Text("Travgram")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .frame(width: 220, height: 100, alignment: .center)

                // 輸入框
                VStack(spacing: 16) {
                    TextField("Enter your email", text: $email)
                        .autocapitalization(.none)
                        .modifier(VGTextFieldModifier())

                    SecureField("Enter your password", text: $password)
                        .modifier(VGTextFieldModifier())
                }
                .padding(.horizontal)

                // 忘記密碼按鈕
                NavigationLink(destination: ForgotPasswordView()) {
                    Text("Forgot Password?")
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .padding(.trailing, 28)

                // 登入按鈕
                Button(action: loginUser) {
                    Text("Login")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(width: 360, height: 44)
                        .background(Color(.systemBlue))
                        .cornerRadius(8)
                }
                .padding(.vertical)
                .alert("Login Failed", isPresented: $loginError) {
                    Button("OK", role: .cancel) {}
                } message: {
                    Text("Invalid email or password.")
                }

                // 分隔線
                HStack {
                    Rectangle()
                        .frame(width: (UIScreen.main.bounds.width / 2) - 40, height: 0.5)
                    Text("OR")
                        .font(.footnote)
                        .fontWeight(.semibold)
                    Rectangle()
                        .frame(width: (UIScreen.main.bounds.width / 2) - 40, height: 0.5)
                }
                .foregroundColor(.gray)
                .padding(.vertical, 8)

                // Google 登入按鈕
                HStack {
                    Image("google")
                        .resizable()
                        .frame(width: 20, height: 20)
                    Text("Continue with Google")
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .foregroundColor(Color(.systemBlue))
                }
                .padding(.top, 8)

                Spacer()

                Divider()

                // 註冊連結
                NavigationLink(destination: SignupView()) {
                    HStack(spacing: 3) {
                        Text("Don't have an account?")
                        Text("Sign Up")
                            .fontWeight(.semibold)
                    }
                    .font(.footnote)
                }
                .padding(.vertical, 16)
            }
            // 使用 navigationDestination 來控制導航到主頁
            .navigationDestination(isPresented: $isLoggedIn) {
                MainPageView()
            }
        }
    }
    
    func loginUser() {
        let fetchRequest = FetchDescriptor<User>(predicate: #Predicate { $0.email == email && $0.password == password })
        
        do {
            if let _ = try context.fetch(fetchRequest).first {
                isLoggedIn = true // 設置為已登入，導航到主頁
                print("Login successful!")
            } else {
                loginError = true
            }
        } catch {
            print("Login failed: \(error)")
        }
    }
}

#Preview {
    let container = try? ModelContainer(for: User.self)
    return LoginView()
        .modelContainer(container!)  // Inject the model container for the preview
}
