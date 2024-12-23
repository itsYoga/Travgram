//
//  UserManager.swift
//  Travgram
//
//  Created by Jesse Liang on 2024/12/24.
//

import Foundation
import SwiftData

class UserManager: ObservableObject {
    @Published var currentUser: User?
    @Published var isLoggedIn: Bool = false

    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context

        // Rehydrate the user if an ID is saved in UserDefaults
        if let savedUserID = UserDefaults.standard.string(forKey: "currentUserID") {
            let fetchDescriptor = FetchDescriptor<User>(
                predicate: #Predicate { $0.id == savedUserID }
            )
            do {
                currentUser = try context.fetch(fetchDescriptor).first
                isLoggedIn = currentUser != nil
                if let user = currentUser {
                    print("Rehydrated user: \(user.username)")
                } else {
                    print("No user found with ID: \(savedUserID)")
                }
            } catch {
                print("Failed to fetch user during rehydration: \(error)")
            }
        }
    }

    var modelContext: ModelContext {
        return context
    }

    func register(username: String, email: String, password: String) {
        let newUser = User(username: username, email: email, password: password)
        context.insert(newUser)

        do {
            try context.save()
            print("User registration successful.")
        } catch {
            print("Registration failed: \(error.localizedDescription)")
        }
    }

    func login(email: String, password: String) {
        let fetchDescriptor = FetchDescriptor<User>(
            predicate: #Predicate { $0.email == email && $0.password == password }
        )

        do {
            if let user = try context.fetch(fetchDescriptor).first {
                currentUser = user
                isLoggedIn = true
                UserDefaults.standard.set(user.id, forKey: "currentUserID")
                print("Login successful for user: \(user.username)")
            } else {
                print("Login failed: Invalid email or password.")
            }
        } catch {
            print("Error during login: \(error.localizedDescription)")
        }
    }

    func logout() {
        currentUser = nil
        isLoggedIn = false
        UserDefaults.standard.removeObject(forKey: "currentUserID")
        print("User logged out.")
    }
}
