import SwiftUI
import SwiftData
import NopiCore

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var settings: [AppSettingsEntity]

    private var hasAcceptedDisclaimer: Bool {
        settings.first?.hasAcceptedDisclaimer ?? false
    }

    var body: some View {
        if hasAcceptedDisclaimer {
            MainTabView()
        } else {
            OnboardingView()
        }
    }
}

struct MainTabView: View {
    var body: some View {
        TabView {
            DashboardView()
                .tabItem {
                    Label("Dashboard", systemImage: "gauge.medium")
                }

            HistoryView()
                .tabItem {
                    Label("History", systemImage: "chart.xyaxis.line")
                }

            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle")
                }

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
    }
}
