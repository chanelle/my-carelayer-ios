import Foundation

/// Pure helpers ported from the web app's `w`, `de`, and `fe` functions.
/// Kept dependency-free so the unit tests can exercise them directly.
enum Formatting {
    /// Web `splitList`: splits a comma string or trims an array.
    static func splitList(_ value: String) -> [String] {
        value.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }.filter { !$0.isEmpty }
    }

    static func joinList(_ values: [String], separator: String = " • ") -> String {
        values.filter { !$0.isEmpty }.joined(separator: separator)
    }

    private static var dobFormatter: DateFormatter {
        let f = DateFormatter()
        f.locale = Locale(identifier: "en_US")
        f.dateFormat = "MMM dd, yyyy"
        return f
    }

    /// "Apr 05, 1997" style, matching the web DOB display.
    static func formatDOB(_ date: Date?) -> String {
        guard let date else { return "" }
        return dobFormatter.string(from: date)
    }

    /// Web `formatPhone`: 10 digits -> (555) 987-6543,
    /// 11 digits starting with 1 -> +1 (555) 987-6543, else unchanged.
    static func formatPhone(_ raw: String) -> String {
        let trimmed = raw.trimmingCharacters(in: .whitespaces)
        let digits = trimmed.filter(\.isNumber)
        guard !digits.isEmpty else { return "" }
        if digits.count == 11, digits.hasPrefix("1") {
            let d = Array(digits)
            return "+1 (\(String(d[1...3]))) \(String(d[4...6]))-\(String(d[7...10]))"
        }
        if digits.count == 10 {
            let d = Array(digits)
            return "(\(String(d[0...2]))) \(String(d[3...5]))-\(String(d[6...9]))"
        }
        return trimmed
    }

    /// Shortens the long hEDS string for chips, as the web app does.
    static func shortenedCondition(_ value: String) -> String {
        value.replacingOccurrences(
            of: "Hypermobile Ehlers-Danlos Syndrome (hEDS)", with: "hEDS")
    }
}
