import SwiftUI
import NopiCore

struct CitationsListView: View {
    var body: some View {
        List(Citations.all, id: \.doi) { citation in
            NavigationLink(destination: CitationDetailView(citation: citation)) {
                VStack(alignment: .leading, spacing: 4) {
                    Label(citation.factorCategory.displayName, systemImage: citation.factorCategory.iconName)
                        .font(.caption)
                        .foregroundStyle(.blue)

                    Text(citation.studyTitle)
                        .font(.subheadline)
                        .lineLimit(2)

                    Text("\(citation.authors) — \(citation.journal), \(citation.year)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
                .padding(.vertical, 2)
            }
        }
        .navigationTitle("Research Citations")
    }
}

struct CitationDetailView: View {
    let citation: ResearchCitation

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Label(citation.factorCategory.displayName, systemImage: citation.factorCategory.iconName)
                    .font(.headline)
                    .foregroundStyle(.blue)

                Text(citation.studyTitle)
                    .font(.title3.bold())

                VStack(alignment: .leading, spacing: 4) {
                    Text("Authors")
                        .font(.caption.bold())
                        .foregroundStyle(.secondary)
                    Text(citation.authors)
                        .font(.subheadline)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text("Journal")
                        .font(.caption.bold())
                        .foregroundStyle(.secondary)
                    Text("\(citation.journal), \(citation.year)")
                        .font(.subheadline)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text("DOI")
                        .font(.caption.bold())
                        .foregroundStyle(.secondary)
                    if let url = citation.doiURL {
                        Link(citation.doi, destination: url)
                            .font(.subheadline)
                    } else {
                        Text(citation.doi)
                            .font(.subheadline)
                    }
                }

                Divider()

                VStack(alignment: .leading, spacing: 4) {
                    Text("Key Finding")
                        .font(.caption.bold())
                        .foregroundStyle(.secondary)
                    Text(citation.findingSummary)
                        .font(.subheadline)
                }
            }
            .padding()
        }
        .navigationTitle("Citation")
        .navigationBarTitleDisplayMode(.inline)
    }
}
