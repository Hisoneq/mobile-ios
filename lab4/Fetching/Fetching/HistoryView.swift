import SwiftUI

struct HistoryView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var items: [HistoryItem] = []
    @State private var isLoading = true
    let theme: ThemeModel

    var body: some View {
        NavigationStack {
            ZStack {
                theme.backgroundColor.ignoresSafeArea()

                if isLoading {
                    ProgressView()
                        .tint(theme.accentColor)
                } else if items.isEmpty {
                    Text("No history yet")
                        .foregroundColor(theme.textColor.opacity(0.7))
                } else {
                    List {
                        ForEach(items) { item in
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(item.expression)
                                        .font(.headline)
                                        .foregroundColor(theme.textColor)
                                    Text("= \(item.result)")
                                        .font(.subheadline)
                                        .foregroundColor(theme.accentColor)
                                }
                                Spacer()
                                Text(item.timestamp, style: .time)
                                    .font(.caption)
                                    .foregroundColor(theme.textColor.opacity(0.6))
                            }
                            .listRowBackground(theme.backgroundColor.opacity(0.5))
                            .listRowSeparatorTint(theme.textColor.opacity(0.3))
                        }
                    }
                    .scrollContentBackground(.hidden)
                }
            }
            .navigationTitle("History")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(theme.backgroundColor, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(theme.accentColor)
                }
            }
        }
        .onAppear {
            loadHistory()
        }
    }

    private func loadHistory() {
        isLoading = true
        FirebaseService.shared.loadHistory { loaded in
            DispatchQueue.main.async {
                items = loaded
                isLoading = false
            }
        }
    }
}
