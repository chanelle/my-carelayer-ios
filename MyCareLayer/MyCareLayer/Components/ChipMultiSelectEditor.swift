import SwiftUI

/// Chip multi-select matching the web editor: selected chips tap-to-remove,
/// search/filter suggested options, add custom values.
///
/// Native fix over the web editor: dedupe is CASE-INSENSITIVE. In the web
/// app the mobility suggestion "Cane during flares" could be added on top
/// of the existing sample chip "cane during flares" (lowercase, from the
/// default profile string), producing a case-variant duplicate. Here a
/// case-insensitive match counts as already selected — in suggestions,
/// in `add(_:)`, and for custom values. First-entered casing is kept.
struct ChipMultiSelectEditor: View {
    let title: String
    let options: [String]
    @Binding var selection: [String]
    @State private var draft = ""

    private func isSelected(_ value: String) -> Bool {
        selection.contains { $0.caseInsensitiveCompare(value) == .orderedSame }
    }

    private var suggestions: [String] {
        options.filter { !isSelected($0) }
            .filter { draft.isEmpty || $0.localizedCaseInsensitiveContains(draft) }
            .prefix(5).map { $0 }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            if !selection.isEmpty {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 110), alignment: .leading)], alignment: .leading, spacing: 8) {
                    ForEach(selection, id: \.self) { item in
                        Button {
                            selection.removeAll { $0 == item }
                        } label: {
                            HStack(spacing: 6) {
                                Text(item).font(.subheadline.weight(.medium))
                                Image(systemName: "xmark").font(.caption2.weight(.bold))
                            }
                            .padding(.horizontal, 10).padding(.vertical, 8)
                            .frame(minHeight: CareSpacing.minTouchTarget)
                            .background(CarePalette.chipBackground)
                            .foregroundStyle(CarePalette.primary)
                            .clipShape(Capsule())
                        }
                        .buttonStyle(.plain)
                        .accessibilityLabel("Remove \(item)")
                    }
                }
            }

            HStack(spacing: 8) {
                TextField("Search or add custom", text: $draft)
                    .textFieldStyle(.roundedBorder)
                    .accessibilityLabel("\(title), search or add custom")
                Button("Add") { add(draft) }
                    .buttonStyle(.borderedProminent)
                    .tint(CarePalette.primary)
                    .frame(minHeight: CareSpacing.minTouchTarget)
                    .disabled(draft.trimmingCharacters(in: .whitespaces).isEmpty)
            }

            if !suggestions.isEmpty {
                ForEach(suggestions, id: \.self) { option in
                    Button {
                        add(option)
                    } label: {
                        HStack {
                            Image(systemName: "plus.circle")
                            Text(option).font(.body)
                            Spacer()
                        }
                        .frame(minHeight: CareSpacing.minTouchTarget)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .foregroundStyle(CarePalette.primary)
                    .accessibilityLabel("Add \(option)")
                }
            }
        }
        .accessibilityElement(children: .contain)
    }

    private func add(_ raw: String) {
        let value = raw.trimmingCharacters(in: .whitespaces)
        // Case-insensitive dedupe (see type comment): "Cane during flares"
        // must not duplicate an existing "cane during flares" chip.
        guard !value.isEmpty, !isSelected(value) else { return }
        selection.append(value)
        draft = ""
    }
}
