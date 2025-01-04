//
//  RegisterView.swift
//  Travgram
//
//  Created by Jesse Liang on 2024/12/24.
//

import SwiftUI
import SwiftData
import TipKit

struct RegisterView: View {
    @EnvironmentObject var userManager: UserManager
    @Environment(\.dismiss) var dismiss
    
    @State private var username = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Text("註冊").font(.largeTitle).bold()
            
            TextField("用戶名", text: $username)
                .textFieldStyle(.roundedBorder)
            
            TextField("電子郵件", text: $email)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
            
            SecureField("密碼", text: $password)
                .textFieldStyle(.roundedBorder)
            
            SecureField("確認密碼", text: $confirmPassword)
                .textFieldStyle(.roundedBorder)
            
            Button("註冊") {
                guard password == confirmPassword else {
                    print("密碼不匹配")
                    return
                }
                userManager.register(username: username, email: email, password: password)
                dismiss()
            }
            .buttonStyle(.borderedProminent)
            .padding(.top)
        }
        .padding()
    }
}

#Preview {
    RegisterView()
}
