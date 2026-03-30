import SwiftUI

struct DisplayView: View {
    let displayText: String
    let resultText: String
    let errorMessage: String?
    let theme: ThemeModel

    var body: some View {
        VStack(alignment: .trailing, spacing: 12) {
            Text(displayText.isEmpty ? "0" : displayText)
                .font(.system(size: CGFloat(min(32, 24 + displayText.count / 4))))
                .foregroundColor(theme.textColor)
                .lineLimit(2)
                .minimumScaleFactor(0.5)
                .frame(maxWidth: .infinity, alignment: .trailing)

            if let err = errorMessage {
                Text(err)
                    .font(.caption)
                    .foregroundColor(theme.accentColor)
            } else {
                Text(resultText.isEmpty ? "0" : resultText)
                    .font(.system(size: 28, weight: .medium))
                    .foregroundColor(theme.textColor.opacity(0.7))
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(theme.backgroundColor)
    }
}
