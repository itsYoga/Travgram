import Foundation
import SwiftData
import os
import TipKit

class UserManager: ObservableObject {
    @Published var currentUser: User?
    @Published var isLoggedIn: Bool = false
    @Published var trips: [Trip] = [] // 支援行程功能

    let modelContext: ModelContext
    private let logger = Logger(subsystem: "com.travgram.UserManager", category: "UserManager")

    init(context: ModelContext) {
        self.modelContext = context
        rehydrateUser()
        fetchTrips()
    }

    // MARK: - User Management
    private func rehydrateUser() {
        guard let savedUserID = UserDefaults.standard.string(forKey: "currentUserID") else {
            logger.info("No saved user ID found in UserDefaults.")
            return
        }

        let fetchDescriptor = FetchDescriptor<User>(
            predicate: #Predicate { $0.id == savedUserID }
        )

        do {
            currentUser = try modelContext.fetch(fetchDescriptor).first
            isLoggedIn = currentUser != nil

            if let user = currentUser {
                logger.info("Rehydrated user: \(user.username, privacy: .public)")
            } else {
                logger.warning("No user found with ID: \(savedUserID)")
            }
        } catch {
            logger.error("Failed to fetch user during rehydration: \(error.localizedDescription, privacy: .public)")
        }
    }

    func register(username: String, email: String, password: String) {
        guard validateEmail(email) else {
            logger.warning("Invalid email format: \(email, privacy: .public)")
            return
        }

        let newUser = User(username: username, email: email, password: password)

        modelContext.insert(newUser)

        do {
            try modelContext.save()
            DispatchQueue.main.async {
                self.currentUser = newUser
                self.isLoggedIn = true
                UserDefaults.standard.set(newUser.id, forKey: "currentUserID")
            }
            logger.info("User registration successful for: \(username, privacy: .public)")
        } catch {
            logger.error("Registration failed: \(error.localizedDescription, privacy: .public)")
        }
    }

    func login(email: String, password: String) {
        let fetchDescriptor = FetchDescriptor<User>(
            predicate: #Predicate { $0.email == email && $0.password == password }
        )

        do {
            if let user = try modelContext.fetch(fetchDescriptor).first {
                currentUser = user
                isLoggedIn = true
                UserDefaults.standard.set(user.id, forKey: "currentUserID")
                logger.info("Login successful for user: \(user.username, privacy: .public)")
            } else {
                logger.warning("Login failed: Invalid email or password.")
            }
        } catch {
            logger.error("Error during login: \(error.localizedDescription, privacy: .public)")
        }
    }

    func logout() {
        currentUser = nil
        isLoggedIn = false
        UserDefaults.standard.removeObject(forKey: "currentUserID")
        logger.info("User logged out.")
    }

    func deleteAllUsers() {
        let fetchDescriptor = FetchDescriptor<User>()

        do {
            let users = try modelContext.fetch(fetchDescriptor)
            users.forEach { modelContext.delete($0) }
            try modelContext.save()
            logger.info("All users deleted successfully.")
        } catch {
            logger.error("Failed to delete users: \(error.localizedDescription, privacy: .public)")
        }
    }

    private func validateEmail(_ email: String) -> Bool {
        let emailRegEx = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }

    // MARK: - Trip Management
    func fetchTrips() {
        let fetchDescriptor = FetchDescriptor<Trip>()
        do {
            trips = try modelContext.fetch(fetchDescriptor)
        } catch {
            logger.error("Failed to fetch trips: \(error.localizedDescription, privacy: .public)")
        }
    }

    func addTrip(name: String, date: Date, type: TripType, budget: Double, expenses: Double, latitude: Double?, longitude: Double?) {
        let newTrip = Trip(name: name, date: date, type: type, budget: budget, expenses: expenses, latitude: latitude, longitude: longitude)
        modelContext.insert(newTrip)
        saveChanges()
        fetchTrips()
    }

    func deleteTrip(_ trip: Trip) {
        modelContext.delete(trip)
        saveChanges()
        fetchTrips()
    }

    func saveChanges() {
        do {
            try modelContext.save()
        } catch {
            logger.error("Failed to save changes: \(error.localizedDescription, privacy: .public)")
        }
    }
}
