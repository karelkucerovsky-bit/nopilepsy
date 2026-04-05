import SwiftUI
import NopiCore

struct WatchFactorListView: View {
    let factors: [FactorContribution]

    var body: some View {
        List(factors) { factor in
            NavigationLink(destination: WatchFactorDetailView(factor: factor)) {
                WatchFactorRow(factor: factor)
            }
        }
        .navigationTitle("Factors")
    }
}
