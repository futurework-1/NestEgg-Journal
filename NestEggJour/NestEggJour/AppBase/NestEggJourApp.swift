import SwiftUI

@main
struct NestEggJourApp: App {
    @StateObject private var birdsManager = BirdsManager()
    
    var body: some Scene {
        WindowGroup {
            LoadingView()
                .environmentObject(birdsManager)
        }
    }
}
