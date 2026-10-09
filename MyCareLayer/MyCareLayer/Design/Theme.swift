import SwiftUI

extension Color {
    init(hex: UInt32) {
        self.init(
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255)
    }
}

/// Design tokens from the web palette. Text always uses Dynamic Type
/// text styles (.body, .headline, …) — never fixed point sizes.
enum CarePalette {
    static let primary = Color(hex: 0x20483A)       // deep green
    static let primaryDark = Color(hex: 0x17362D)   // darker green
    static let background = Color(hex: 0xF6F1E7)    // cream
    static let card = Color(hex: 0xFFFDF8)
    static let ring = Color(hex: 0xE5DCCE)
    static let mutedText = Color(hex: 0x6F7C75)
    static let bodyText = Color(hex: 0x18231F)
    static let bodyTextSoft = Color(hex: 0x26332E)
    static let accent = Color(hex: 0x4F9274)
    static let chipBackground = Color(hex: 0xDCEBDF)
    static let gold = Color(hex: 0xE7C873)
    static let warning = Color(hex: 0xB85C5C)
}

enum CareSpacing {
    static let small: CGFloat = 8
    static let medium: CGFloat = 16
    static let large: CGFloat = 24
    static let cardCorner: CGFloat = 20
    static let minTouchTarget: CGFloat = 44
}

struct CareCardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(CarePalette.card)
            .clipShape(RoundedRectangle(cornerRadius: CareSpacing.cardCorner))
            .overlay(
                RoundedRectangle(cornerRadius: CareSpacing.cardCorner)
                    .stroke(CarePalette.ring, lineWidth: 1))
    }
}

extension View {
    func careCard() -> some View { modifier(CareCardModifier()) }
}
