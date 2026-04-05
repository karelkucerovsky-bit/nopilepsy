import SwiftUI
import SwiftData
import NopiCore

struct OnboardingView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = OnboardingViewModel()

    var body: some View {
        TabView(selection: $viewModel.currentPage) {
            WelcomePage()
                .tag(0)

            DisclaimerPage(hasScrolled: $viewModel.hasScrolledDisclaimer)
                .tag(1)

            ResearchTransparencyPage()
                .tag(2)

            HealthKitPermissionPage(authorized: $viewModel.healthKitAuthorized) {
                await viewModel.requestHealthKit()
            }
            .tag(3)

            ProfileSetupPage {
                viewModel.acceptDisclaimer(modelContext: modelContext)
            }
            .tag(4)
        }
        .tabViewStyle(.page)
        .indexViewStyle(.page(backgroundDisplayMode: .always))
        .onAppear { viewModel.setup() }
    }
}
