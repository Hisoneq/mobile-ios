import SwiftUI

struct DisplayView: View {
    let displayText: String
    let resultText: String
    let errorMessage: String?

    var body: some View {
        VStack(alignment: .trailing, spacing: 12) {
            Text(displayText.isEmpty ? "0" : displayText)
                .font(.system(size: CGFloat(min(32, 24 + displayText.count / 4))))
                .foregroundColor(.white)
                .lineLimit(2)
                .minimumScaleFactor(0.5)
                .frame(maxWidth: .infinity, alignment: .trailing)

            if let err = errorMessage {
                Text(err)
                    .font(.caption)
                    .foregroundColor(.orange)
            } else {
                Text(resultText.isEmpty ? "0" : resultText)
                    .font(.system(size: 28, weight: .medium))
                    .foregroundColor(Color.white.opacity(0.7))
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(red: 0.11, green: 0.11, blue: 0.12))
    }
}
