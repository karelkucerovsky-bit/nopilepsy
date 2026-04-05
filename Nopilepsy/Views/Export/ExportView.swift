import SwiftUI
import SwiftData
import NopiCore

struct ExportView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query(sort: \RiskAssessmentEntity.timestamp)
    private var allAssessments: [RiskAssessmentEntity]
    @Query private var profiles: [UserProfileEntity]
    @State private var viewModel = ExportViewModel()

    var body: some View {
        NavigationStack {
            Form {
                Section("Date Range") {
                    DatePicker("From", selection: $viewModel.startDate, displayedComponents: .date)
                    DatePicker("To", selection: $viewModel.endDate, displayedComponents: .date)
                }

                Section("Format") {
                    Picker("Export Format", selection: $viewModel.exportFormat) {
                        ForEach(ExportViewModel.ExportFormat.allCases, id: \.self) { format in
                            Text(format.rawValue).tag(format)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                Section {
                    let count = allAssessments.filter {
                        $0.timestamp >= viewModel.startDate && $0.timestamp <= viewModel.endDate
                    }.count
                    Text("\(count) assessments in selected range")
                        .foregroundStyle(.secondary)
                }

                Section {
                    if let url = viewModel.exportedFileURL {
                        ShareLink(item: url) {
                            Label("Share Report", systemImage: "square.and.arrow.up")
                        }
                    }

                    Button {
                        _ = viewModel.generateExport(
                            assessments: allAssessments,
                            profile: profiles.first
                        )
                    } label: {
                        if viewModel.isExporting {
                            ProgressView()
                        } else {
                            Label("Generate Report", systemImage: "doc.badge.plus")
                        }
                    }
                    .disabled(viewModel.isExporting)
                }
            }
            .navigationTitle("Export")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}
