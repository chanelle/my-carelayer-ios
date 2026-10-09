import Foundation
import SwiftData

/// The single, local-only user profile. No real person's data is stored
/// in source — `sample` below is the demo profile from the public web
/// prototype, clearly fictional placeholder data (555 phone number).
@Model
final class UserProfile {
    var displayName: String = ""
    /// Verbatim age label from the web app, e.g. "27 yrs" or "Prefer not to say".
    var ageLabel: String = ""
    var dateOfBirth: Date?
    var pronouns: String = ""
    /// EDS / primary condition type string, verbatim from ProfileOptions.
    var primaryConditionType: String = ""
    var conditionStatus: String = ""
    var relatedConditions: [String] = []
    var medications: [String] = []
    var allergies: [String] = []
    var hasAdhesiveSensitivity: Bool = false
    var mobilityAids: [String] = []
    // Fields required by the native brief, beyond the web version.
    // Empty by default; shown on cards/audience views only when non-empty.
    var sensoryNeeds: String = ""
    var communicationNeeds: String = ""
    var accommodations: String = ""
    var medicalHistoryNotes: String = ""
    var clinicianNotes: String = ""
    var criticalNotes: String = ""
    var emergencyContactName: String = ""
    var emergencyContactPhone: String = ""

    init() {}

    var isEmpty: Bool {
        displayName.isEmpty && primaryConditionType.isEmpty
            && relatedConditions.isEmpty && medications.isEmpty
            && allergies.isEmpty && criticalNotes.isEmpty
    }

    var completenessFraction: Double {
        let checks: [Bool] = [
            !displayName.isEmpty, dateOfBirth != nil, !pronouns.isEmpty,
            !primaryConditionType.isEmpty, !conditionStatus.isEmpty,
            !relatedConditions.isEmpty, !medications.isEmpty,
            !allergies.isEmpty, !mobilityAids.isEmpty,
            !criticalNotes.isEmpty, !emergencyContactName.isEmpty,
            !emergencyContactPhone.isEmpty
        ]
        return Double(checks.filter { $0 }.count) / Double(checks.count)
    }

    /// Demo profile — verbatim from the web prototype's defaults.
    /// Fictional sample data only; never replace with a real person's data.
    static func makeSample() -> UserProfile {
        let p = UserProfile()
        p.displayName = "Alexandra Morgan"
        p.ageLabel = "27 yrs"
        var components = DateComponents()
        components.year = 1997; components.month = 4; components.day = 5
        p.dateOfBirth = Calendar(identifier: .gregorian).date(from: components)
        p.pronouns = "They / Them"
        p.primaryConditionType = "Hypermobile Ehlers-Danlos Syndrome (hEDS)"
        p.conditionStatus = "Diagnosed"
        p.relatedConditions = ["POTS", "MCAS", "Chronic Pain"]
        p.medications = ["Low Dose Naltrexone", "Ivabradine", "Famotidine"]
        p.allergies = ["Adhesive tape", "Latex", "Opioids severe nausea"]
        p.hasAdhesiveSensitivity = true
        p.mobilityAids = ["Knee brace", "cane during flares", "joint supports"]
        // Note: the web source stores mobility aids as one comma string
        // "Knee brace, cane during flares, joint supports" — the lowercase
        // "cane during flares" is preserved verbatim from that string split.
        p.emergencyContactName = "Jordan Morgan (Partner)"
        p.emergencyContactPhone = "+1 (555) 987-6543"
        p.criticalNotes = "Fragile skin and connective tissue. Avoid excessive force and rapid stretching. Monitor HR/BP; history of syncope. Needs extra time for position changes."
        return p
    }

    func loadSampleValues() {
        let s = UserProfile.makeSample()
        displayName = s.displayName; ageLabel = s.ageLabel
        dateOfBirth = s.dateOfBirth; pronouns = s.pronouns
        primaryConditionType = s.primaryConditionType
        conditionStatus = s.conditionStatus
        relatedConditions = s.relatedConditions; medications = s.medications
        allergies = s.allergies; hasAdhesiveSensitivity = s.hasAdhesiveSensitivity
        mobilityAids = s.mobilityAids
        emergencyContactName = s.emergencyContactName
        emergencyContactPhone = s.emergencyContactPhone
        criticalNotes = s.criticalNotes
    }

    func clearAll() {
        let fresh = UserProfile()
        displayName = fresh.displayName; ageLabel = fresh.ageLabel
        dateOfBirth = nil; pronouns = fresh.pronouns
        primaryConditionType = fresh.primaryConditionType
        conditionStatus = fresh.conditionStatus
        relatedConditions = []; medications = []; allergies = []
        hasAdhesiveSensitivity = false; mobilityAids = []
        sensoryNeeds = ""; communicationNeeds = ""; accommodations = ""
        medicalHistoryNotes = ""; clinicianNotes = ""; criticalNotes = ""
        emergencyContactName = ""; emergencyContactPhone = ""
    }
}
