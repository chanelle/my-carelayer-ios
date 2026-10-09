import XCTest
@testable import MyCareLayer

/// Ports the web app's built-in self-test function `T()` and adds
/// coverage for the catalog and formatting helpers.
final class MyCareLayerTests: XCTestCase {

    // Web: C.length !== 6 -> "Expected six audiences."
    func testSixAudiences() {
        XCTAssertEqual(AudienceCatalog.all.count, 6)
    }

    // Web: each audience needs id, label, summary, sections.
    func testAudienceShape() {
        for audience in AudienceCatalog.all {
            XCTAssertFalse(audience.id.isEmpty)
            XCTAssertFalse(audience.label.isEmpty)
            XCTAssertFalse(audience.summary.isEmpty)
            XCTAssertEqual(audience.sections.count, 4, "\(audience.id) should have 4 sections")
            for section in audience.sections {
                XCTAssertEqual(section.items.count, 3, "\(audience.id)/\(section.title) should have 3 items")
            }
        }
    }

    func testAudienceSectionOrder() {
        let expected = ["Why this matters", "Common mistakes", "Safety considerations", "What helps"]
        for audience in AudienceCatalog.all {
            XCTAssertEqual(audience.sections.map(\.title), expected, audience.id)
        }
    }

    // Web: ER should use medical cross, not warning icon.
    func testERGlyph() {
        let er = AudienceCatalog.audience(id: "er")
        XCTAssertEqual(er?.glyph, "✚")
    }

    // Web: splitList should parse comma lists.
    func testSplitListCommaString() {
        XCTAssertEqual(Formatting.splitList("POTS, MCAS, migraine"), ["POTS", "MCAS", "migraine"])
    }

    func testSplitListTrimsAndDropsEmpty() {
        XCTAssertEqual(Formatting.splitList("A,  B ,"), ["A", "B"])
        XCTAssertEqual(Formatting.splitList(""), [])
    }

    // Web: DOB should format from date input ("Apr 05, 1997").
    func testDOBFormatting() {
        var components = DateComponents()
        components.year = 1997; components.month = 4; components.day = 5
        let date = Calendar(identifier: .gregorian).date(from: components)
        XCTAssertEqual(Formatting.formatDOB(date), "Apr 05, 1997")
        XCTAssertEqual(Formatting.formatDOB(nil), "")
    }

    // Web: 10-digit phone format.
    func testPhoneTenDigit() {
        XCTAssertEqual(Formatting.formatPhone("5559876543"), "(555) 987-6543")
    }

    // Web: US country-code phone format.
    func testPhoneElevenDigit() {
        XCTAssertEqual(Formatting.formatPhone("15559876543"), "+1 (555) 987-6543")
    }

    func testPhoneEmptyAndOther() {
        XCTAssertEqual(Formatting.formatPhone(""), "")
        XCTAssertEqual(Formatting.formatPhone("555-313-4419"), "(555) 313-4419")
    }

    // Web: default status should be valid.
    func testSampleStatusIsValidOption() {
        let sample = UserProfile.makeSample()
        XCTAssertTrue(ProfileOptions.conditionStatuses.contains(sample.conditionStatus))
        XCTAssertTrue(ProfileOptions.conditionTypes.contains(sample.primaryConditionType))
        XCTAssertTrue(ProfileOptions.pronouns.contains(sample.pronouns))
    }

    func testSampleProfileIsDemoData() {
        let sample = UserProfile.makeSample()
        XCTAssertEqual(sample.displayName, "Alexandra Morgan")
        XCTAssertTrue(sample.emergencyContactPhone.contains("555"))
        XCTAssertFalse(sample.isEmpty)
    }

    func testEmptyProfile() {
        XCTAssertTrue(UserProfile().isEmpty)
    }

    func testShortenedCondition() {
        XCTAssertEqual(
            Formatting.shortenedCondition("Hypermobile Ehlers-Danlos Syndrome (hEDS)"), "hEDS")
    }

    func testShareTextIncludesOnlyFilledExtendedFields() {
        let profile = UserProfile()
        profile.displayName = "Test Person"
        let text = ShareComposer.emergencyCardText(profile: profile)
        XCTAssertTrue(text.contains("Test Person"))
        XCTAssertFalse(text.contains("Sensory needs"))
        profile.sensoryNeeds = "Low light"
        let text2 = ShareComposer.emergencyCardText(profile: profile)
        XCTAssertTrue(text2.contains("Low light"))
    }
}
