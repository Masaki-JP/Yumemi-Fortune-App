import SwiftUI

@MainActor
func fortunePromptView(action: @escaping () -> Void) -> some View {
    ContentUnavailableView {
        Label("今日のラッキー都道府県を\n占いましょう！", systemImage: "map.fill")
    } actions: {
        Button("占う", action: action)
            .buttonStyle(.borderedProminent)
    }
}

#Preview {
    fortunePromptView(action: {})
}
