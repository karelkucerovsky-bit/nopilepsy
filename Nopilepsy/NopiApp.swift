import SwiftUI
import SwiftData
import NopiCore

@main
struct NopiApp: App {
    let modelContainer: ModelContainer

    init() {
        do {
            modelContainer = try NopiModelContainer.create()
        } catch {
            fatalError("Failed to create model container: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    let context = modelContainer.mainContext
                    PhoneConnectivityService.shared.setup(modelContext: context)
                }
        }
        .modelContainer(modelContainer)
    }
}
