import SwiftUI

struct ContentView: View {
    @EnvironmentObject var userManager: UserManager

    var body: some View {
        if userManager.isLoggedIn {
            MainPageView()
        } else {
            LoginView()
        }
    }
}
