import SwiftUI

struct AudienceTile: View {
    let audience: Audience

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ZStack {
                RoundedRectangle(cornerRadius: 14)
                    .fill(CarePalette.chipBackground)
                    .frame(width: 44, height: 44)
                HStack(spacing: 2) {
                    Text(audience.glyph)
                        .font(.title3)
                        .foregroundStyle(CarePalette.primary)
                    Image(systemName: audience.sfSymbol)
                        .font(.caption)
                        .foregroundStyle(CarePalette.primary)
                }
            }
            .accessibilityHidden(true)

            Text(audience.label)
                .font(.headline)
                .foregroundStyle(CarePalette.bodyText)
                .multilineTextAlignment(.leading)
            Text(audience.short)
                .font(.subheadline)
                .foregroundStyle(CarePalette.mutedText)
                .multilineTextAlignment(.leading)
            Spacer(minLength: 0)
        }
        .padding(CareSpacing.medium)
        .frame(maxWidth: .infinity, minHeight: 118, alignment: .topLeading)
        .careCard()
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(audience.label). \(audience.short)")
        .accessibilityHint("Opens the CareLayer view for \(audience.label)")
    }
}
