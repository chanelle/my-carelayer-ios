import Foundation

struct AudienceSection: Identifiable, Hashable {
    var id: String { title }
    let title: String
    let items: [String]
}

/// Data-driven audience definition. All copy lives in AudienceCatalog,
/// so a new audience is data, not a new screen.
struct Audience: Identifiable, Hashable {
    let id: String
    let label: String
    /// Original glyph from the web prototype, kept visible for identity.
    let glyph: String
    /// SF Symbol paired with the glyph for VoiceOver / clarity.
    let sfSymbol: String
    let short: String
    let summary: String
    let sections: [AudienceSection]
}
