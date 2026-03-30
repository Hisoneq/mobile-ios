import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = CalculatorViewModel()

    var body: some View {
        NavigationStack {
            GeometryReader { geo in
                let isPortrait = geo.size.height > geo.size.width
                let compactHeight = geo.size.height < 500
                ZStack {
                    viewModel.theme.backgroundColor
                        .ignoresSafeArea()

                    Group {
                        if isPortrait {
                            VStack(spacing: 0) {
                                displayBlock
                                    .frame(maxHeight: compactHeight ? 100 : .infinity)
                                keyboardBlock
                                    .frame(maxHeight: .infinity)
                            }
                        } else {
                            HStack(spacing: 0) {
                                displayBlock
                                    .frame(maxWidth: .infinity)
                                keyboardBlock
                                    .frame(maxWidth: min(geo.size.width * 0.55, 360))
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .ignoresSafeArea(.keyboard)
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(viewModel.theme.backgroundColor, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Button("History") { viewModel.showHistory = true }
                        Button("Theme") { viewModel.showTheme = true }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .foregroundColor(viewModel.theme.textColor)
                    }
                    .accessibilityLabel("Menu: History and Theme")
                }
            }
        }
        .statusBar(hidden: false)
        .sheet(isPresented: $viewModel.showHistory) {
            HistoryView(theme: viewModel.theme)
        }
        .sheet(isPresented: $viewModel.showTheme) {
            ThemeEditorView(theme: $viewModel.theme, onSave: {
                viewModel.saveTheme()
            })
        }
    }

    private var displayBlock: some View {
        DisplayView(
            displayText: viewModel.displayText,
            resultText: viewModel.resultText,
            errorMessage: viewModel.errorMessage,
            theme: viewModel.theme
        )
    }

    private var keyboardBlock: some View {
        KeyboardView(onKey: viewModel.handleKey, theme: viewModel.theme)
    }
}
