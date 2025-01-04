import SwiftUI
import SwiftData
import TipKit

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @EnvironmentObject var userManager: UserManager
    @State private var loginError = false
    @State private var showDeletionSuccess = false

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
                
                // 刪除所有用戶按鈕
                Button("Delete All Users") {
                    deleteAllUsers()
                    showDeletionSuccess = true // 顯示成功提示
                }
                .alert("Deletion Successful", isPresented: $showDeletionSuccess) {
                    Button("OK", role: .cancel) {}
                }
                
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
            .navigationDestination(isPresented: $userManager.isLoggedIn) {
                MainPageView()
            }
        }
    }
    
    func loginUser() {
        // Directly fetch the user with plain text email and password
        let fetchRequest = FetchDescriptor<User>(
            predicate: #Predicate { $0.email == email && $0.password == password }
        )
        
        do {
            if let user = try userManager.modelContext.fetch(fetchRequest).first {
                userManager.currentUser = user
                userManager.isLoggedIn = true
                UserDefaults.standard.set(user.id, forKey: "currentUserID")
            } else {
                loginError = true
            }
        } catch {
            print("Login failed: \(error.localizedDescription)")
        }
    }
    
    func deleteAllUsers() {
        let fetchDescriptor = FetchDescriptor<User>()

        do {
            let users = try userManager.modelContext.fetch(fetchDescriptor)
            users.forEach { userManager.modelContext.delete($0) }
            try userManager.modelContext.save()
            print("All users deleted successfully.")
        } catch {
            print("Failed to delete users: \(error.localizedDescription)")
        }
    }
}

#Preview {
    do {
        let container = try ModelContainer(for: User.self) // Initialize ModelContainer
        let context = container.mainContext
        let userManager = UserManager(context: context)

        return LoginView()
            .environmentObject(userManager) // Inject UserManager
            .modelContainer(container) // Inject ModelContainer to ensure correct context usage
    } catch {
        return Text("Error initializing preview") // Handle initialization error in preview
    }
}
