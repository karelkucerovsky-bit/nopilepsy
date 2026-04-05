import SwiftUI
import SwiftData
import NopiCore

@main
struct NopiWatchApp: App {
    let modelContainer: ModelContainer

    init() {
        do {
            modelContainer = try NopiModelContainer.create()
        } catch {
            fatalError("Failed to create model container: \(error)")
        }
        WatchConnectivityService.shared.setup()
    }

    var body: some Scene {
        WindowGroup {
            WatchDashboardView()
        }
        .modelContainer(modelContainer)
    }
}
