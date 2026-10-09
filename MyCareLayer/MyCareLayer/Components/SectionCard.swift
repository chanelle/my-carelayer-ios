import SwiftUI

/// Accordion section matching the web audience view: first section open
/// by default, Show/Hide pill (text, not color-only). Honors Reduce Motion.
struct SectionCard: View {
    let title: String
    let items: [String]
    @State private var isExpanded: Bool
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    init(title: String, items: [String], defaultOpen: Bool = false) {
        self.title = title
        self.items = items
        _isExpanded = State(initialValue: defaultOpen)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button {
                if reduceMotion {
                    isExpanded.toggle()
                } else {
                    withAnimation(.easeInOut(duration: 0.2)) { isExpanded.toggle() }
                }
            } label: {
                HStack {
                    Text(title)
                        .font(.headline)
                        .foregroundStyle(CarePalette.bodyText)
                        .accessibilityAddTraits(.isHeader)
                    Spacer()
                    Text(isExpanded ? "Hide" : "Show")
                        .font(.caption.weight(.semibold))
                        .padding(.horizontal, 12).padding(.vertical, 6)
                        .background(CarePalette.background)
                        .clipShape(Capsule())
                        .foregroundStyle(CarePalette.mutedText)
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(CarePalette.mutedText)
                }
                .frame(minHeight: CareSpacing.minTouchTarget)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel("\(title), \(isExpanded ? "expanded" : "collapsed")")
            .accessibilityHint(isExpanded ? "Double tap to collapse" : "Double tap to expand")

            if isExpanded {
                Divider().overlay(CarePalette.ring)
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(items, id: \.self) { item in
                        HStack(alignment: .top, spacing: 12) {
                            Circle()
                                .fill(CarePalette.accent)
                                .frame(width: 8, height: 8)
                                .padding(.top, 7)
                                .accessibilityHidden(true)
                            Text(item)
                                .font(.body)
                                .foregroundStyle(CarePalette.bodyTextSoft)
                        }
                    }
                }
                .padding(.top, 12)
            }
        }
        .padding(CareSpacing.medium)
        .careCard()
    }
}
