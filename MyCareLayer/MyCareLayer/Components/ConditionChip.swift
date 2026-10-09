import SwiftUI

struct ConditionChip: View {
    let text: String
    var onDark: Bool = false

    var body: some View {
        Text(text)
            .font(.subheadline.weight(.medium))
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .frame(minHeight: CareSpacing.minTouchTarget / 2 + 12)
            .background(onDark ? Color.white.opacity(0.14) : CarePalette.chipBackground)
            .foregroundStyle(onDark ? Color.white : CarePalette.primary)
            .clipShape(Capsule())
            .accessibilityLabel(text)
    }
}
