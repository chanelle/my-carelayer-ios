import Foundation

/// Builds plain-text shares. Only non-empty, user-entered fields are
/// included. Sharing is always user-initiated via ShareLink — this
/// type never sends anything itself.
enum ShareComposer {
    static let disclaimer = "Patient-provided context. Use clinical judgment and verify details as needed."

    static func audienceText(audience: Audience, profile: UserProfile) -> String {
        var lines: [String] = []
        lines.append("CareLayer — Show this to: \(audience.label)")
        lines.append("")
        lines.append("Quick Summary")
        lines.append(audience.summary)
        appendProfileSummary(to: &lines, profile: profile)
        for section in audience.sections {
            lines.append("")
            lines.append(section.title)
            for item in section.items { lines.append("- \(item)") }
        }
        appendExtendedProfile(to: &lines, profile: profile)
        lines.append("")
        lines.append(disclaimer)
        return lines.joined(separator: "\n")
    }

    static func emergencyCardText(profile: UserProfile) -> String {
        var lines: [String] = []
        lines.append("CARELAYER — MEDICAL ALERT CARD")
        lines.append("")
        lines.append("Identity")
        lines.append(profile.displayName.isEmpty ? "Not set" : profile.displayName)
        let dob = Formatting.formatDOB(profile.dateOfBirth)
        lines.append("DOB: \(dob.isEmpty ? "Not set" : dob)")
        if !profile.ageLabel.isEmpty { lines.append(profile.ageLabel) }
        if !profile.pronouns.isEmpty { lines.append(profile.pronouns) }
        lines.append("")
        lines.append("Conditions")
        if !profile.primaryConditionType.isEmpty { lines.append(profile.primaryConditionType) }
        if !profile.conditionStatus.isEmpty { lines.append("Status: \(profile.conditionStatus)") }
        if !profile.relatedConditions.isEmpty {
            lines.append(Formatting.joinList(profile.relatedConditions))
        }
        lines.append("")
        lines.append("Medications")
        lines.append(profile.medications.isEmpty ? "No medications added." : Formatting.joinList(profile.medications))
        lines.append("")
        lines.append("Allergies & Sensitivities")
        lines.append(profile.allergies.isEmpty ? "No allergies added." : Formatting.joinList(profile.allergies))
        if profile.hasAdhesiveSensitivity { lines.append("Adhesive sensitivity noted.") }
        lines.append("")
        lines.append("Mobility / Positioning")
        lines.append(profile.mobilityAids.isEmpty ? "No mobility aids added." : Formatting.joinList(profile.mobilityAids))
        if !profile.criticalNotes.isEmpty {
            lines.append("")
            lines.append("Critical Notes")
            lines.append(profile.criticalNotes)
        }
        appendExtendedProfile(to: &lines, profile: profile)
        if !profile.emergencyContactName.isEmpty || !profile.emergencyContactPhone.isEmpty {
            lines.append("")
            lines.append("Emergency Contact")
            lines.append([profile.emergencyContactName, profile.emergencyContactPhone]
                .filter { !$0.isEmpty }.joined(separator: " — "))
        }
        lines.append("")
        lines.append(disclaimer)
        return lines.joined(separator: "\n")
    }

    private static func appendProfileSummary(to lines: inout [String], profile: UserProfile) {
        var chips: [String] = []
        if !profile.conditionStatus.isEmpty { chips.append(profile.conditionStatus) }
        if !profile.primaryConditionType.isEmpty {
            chips.append(Formatting.shortenedCondition(profile.primaryConditionType))
        }
        chips.append(contentsOf: profile.relatedConditions.prefix(5))
        if !chips.isEmpty {
            lines.append("")
            lines.append(chips.joined(separator: " • "))
        }
        if !profile.displayName.isEmpty {
            lines.append("")
            lines.append("About \(profile.displayName):")
            if !profile.medications.isEmpty {
                lines.append("Medications: \(Formatting.joinList(profile.medications))")
            }
            if !profile.allergies.isEmpty {
                lines.append("Allergies: \(Formatting.joinList(profile.allergies))")
            }
            if profile.hasAdhesiveSensitivity { lines.append("Adhesive sensitivity noted.") }
            if !profile.mobilityAids.isEmpty {
                lines.append("Mobility / positioning: \(Formatting.joinList(profile.mobilityAids))")
            }
        }
    }

    /// Brief-only fields, shown/shared only when the user filled them in.
    private static func appendExtendedProfile(to lines: inout [String], profile: UserProfile) {
        let fields: [(String, String)] = [
            ("Sensory needs", profile.sensoryNeeds),
            ("Communication needs", profile.communicationNeeds),
            ("Accommodations", profile.accommodations),
            ("Important medical history", profile.medicalHistoryNotes),
            ("Notes for clinicians", profile.clinicianNotes)
        ]
        for (label, value) in fields where !value.isEmpty {
            lines.append("")
            lines.append(label)
            lines.append(value)
        }
    }
}
