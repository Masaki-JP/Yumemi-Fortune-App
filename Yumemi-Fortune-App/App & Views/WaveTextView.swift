import SwiftUI

struct WaveTextView: View {
    @State private var characters: [(value: Character, isJumping: Bool)]
    private let offsetOfY: CGFloat = -25

    init(_ text: String = "今日のラッキー都道府県は…") {
        self.characters = text.map { ($0, false) }
    }

    var body: some View {
        HStack(spacing: 1.5) {
            ForEach(characters, id: \.value) { value, isJumping in
                Text(String(value))
                    .font(.title)
                    .fontWeight(.semibold)
                    .offset(y: isJumping == true ? offsetOfY : 0.0)
            }
        }
        .task {
            for _ in 0..<3 {
                try? await Task.sleep(for: .seconds(0.5))

                for character in $characters {
                    try? await Task.sleep(for: .seconds(0.075))

                    withAnimation(.easeIn) {
                        character.wrappedValue.isJumping = true
                    } completion: {
                        withAnimation(.easeOut) {
                            character.wrappedValue.isJumping = false
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    WaveTextView()
}
