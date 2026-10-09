import Foundation

/// Verbatim option lists and sample contacts from the web source
/// ("CareLayer lean v3", localStorage key `carelayer-profile-v3-lean`).
enum ProfileOptions {
    static let ageOptions: [String] =
        ["Prefer not to say"] + (1...110).map { "\($0) yrs" }

    static let pronouns = [
        "They / Them", "She / Her", "He / Him", "She / They", "He / They",
        "Any pronouns", "Prefer not to say", "Custom"
    ]

    static let conditionTypes = [
        "Hypermobile Ehlers-Danlos Syndrome (hEDS)",
        "Classical Ehlers-Danlos Syndrome (cEDS)",
        "Vascular Ehlers-Danlos Syndrome (vEDS)",
        "Hypermobility Spectrum Disorder (HSD)",
        "Suspected EDS / awaiting evaluation",
        "Other / custom"
    ]

    static let conditionStatuses = [
        "Diagnosed", "Suspected", "Seeking evaluation", "Family history",
        "Rule-out in progress", "Prefer not to say"
    ]

    static let relatedConditions = [
        "POTS", "Dysautonomia", "MCAS", "Chronic Pain", "Migraine",
        "Gastroparesis", "IBS", "GERD", "Autism", "ADHD", "OCD", "CPTSD",
        "CSF leak history", "Fibromyalgia"
    ]

    static let medications = [
        "Low Dose Naltrexone", "Ivabradine", "Famotidine", "Cetirizine",
        "Gabapentin", "Pregabalin", "Duloxetine", "Cyclobenzaprine",
        "Tylenol / Acetaminophen", "Adderall / stimulant medication"
    ]

    static let allergies = [
        "Adhesive tape", "Latex", "Opioids severe nausea",
        "Fragrance sensitivity", "NSAID sensitivity", "Chlorhexidine",
        "Iodine contrast", "Penicillin",
        "Lidocaine resistance / reduced response"
    ]

    static let mobilityAids = [
        "Knee brace", "Ankle brace", "Wrist brace", "Cane during flares",
        "Crutches", "Walker", "Wheelchair", "Joint supports",
        "Compression garments", "Orthotics"
    ]

    struct SampleContact: Identifiable, Hashable {
        var id: String { name }
        let name: String
        let phone: String
    }

    /// Fictional sample contacts from the web prototype (555 numbers).
    static let sampleContacts: [SampleContact] = [
        SampleContact(name: "Jordan Morgan (Partner)", phone: "+1 (555) 987-6543"),
        SampleContact(name: "Maya Thompson (Sister)", phone: "555-313-4419"),
        SampleContact(name: "Dr. Kim, PCP", phone: "5552220104")
    ]
}

/// All six audiences, transcribed EXACTLY from the web source array `C`.
/// Section order matches the source object's key order as rendered:
/// Why this matters / Common mistakes / Safety considerations / What helps.
enum AudienceCatalog {
    static let all: [Audience] = [
        Audience(
            id: "nurse", label: "Nurse", glyph: "♡", sfSymbol: "heart.fill",
            short: "Positioning, skin, vitals, pain.",
            summary: "EDS can affect joint stability, skin fragility, pain, autonomic symptoms, healing, and tolerance for positioning or procedures.",
            sections: [
                AudienceSection(title: "Why this matters", items: [
                    "Pain may be high even if the patient looks calm.",
                    "Joints may sublux or become injured with ordinary movement.",
                    "Dysautonomia may affect heart rate, blood pressure, dizziness, and fainting."
                ]),
                AudienceSection(title: "Common mistakes", items: [
                    "Assuming flexibility means less injury.",
                    "Moving limbs quickly during positioning.",
                    "Using strong adhesives without asking about skin sensitivity."
                ]),
                AudienceSection(title: "Safety considerations", items: [
                    "Avoid forcing joints into end range.",
                    "Ask before moving or lifting limbs.",
                    "Use gentle adhesive removal."
                ]),
                AudienceSection(title: "What helps", items: [
                    "Explain before touching or repositioning.",
                    "Let the patient guide their own joints when possible.",
                    "Document pain and functional limits clearly."
                ])
            ]),
        Audience(
            id: "pcp", label: "Primary Care", glyph: "+", sfSymbol: "stethoscope",
            short: "Patterns, referrals, coordination.",
            summary: "EDS may affect joints, skin, autonomic function, pain, GI symptoms, fatigue, injury recovery, and medication tolerance.",
            sections: [
                AudienceSection(title: "Why this matters", items: [
                    "Symptoms that look unrelated may share a connective tissue or autonomic component.",
                    "Standard imaging may miss instability or soft-tissue injury.",
                    "Coordination across specialists may be necessary."
                ]),
                AudienceSection(title: "Common mistakes", items: [
                    "Treating each symptom as isolated.",
                    "Assuming normal labs or imaging mean nothing is wrong.",
                    "Referring to PT without EDS-informed precautions."
                ]),
                AudienceSection(title: "Safety considerations", items: [
                    "Document functional impairment.",
                    "Avoid generalized stretching-only care plans.",
                    "Ask about medication sensitivity and prior adverse reactions."
                ]),
                AudienceSection(title: "What helps", items: [
                    "Coordinate care across specialists.",
                    "Document symptoms in functional terms.",
                    "Provide referrals and bridge plans when waits are long."
                ])
            ]),
        Audience(
            id: "er", label: "Emergency Room", glyph: "✚", sfSymbol: "cross.case.fill",
            short: "Urgent context and discharge safety.",
            summary: "Please consider joint instability, soft-tissue injury, dysautonomia, pain amplification, medication sensitivity, and that normal X-rays may not rule out clinically significant injury.",
            sections: [
                AudienceSection(title: "Why this matters", items: [
                    "Severe pain or instability can occur without obvious imaging findings.",
                    "Joints can sublux or dislocate from low-force mechanisms.",
                    "Dysautonomia may affect HR/BP, dizziness, fainting, and hydration."
                ]),
                AudienceSection(title: "Common mistakes", items: [
                    "Assuming normal X-ray equals safe discharge.",
                    "Moving joints aggressively through range of motion.",
                    "Interpreting calm affect as low pain."
                ]),
                AudienceSection(title: "Safety considerations", items: [
                    "Assess function, weight-bearing, neuro symptoms, and instability.",
                    "Avoid forceful manipulation unless clearly indicated.",
                    "Provide clear return precautions and concrete next steps."
                ]),
                AudienceSection(title: "What helps", items: [
                    "Listen for the pattern, not only the single symptom.",
                    "Document inability to bear weight, instability, numbness, or functional decline.",
                    "Explain what was ruled out and what was not."
                ])
            ]),
        Audience(
            id: "ortho", label: "Orthopedic", glyph: "◇", sfSymbol: "figure.walk",
            short: "Instability, imaging, bracing.",
            summary: "EDS can cause joint laxity, recurrent subluxations or dislocations, soft-tissue injury, altered proprioception, chronic pain, and atypical recovery.",
            sections: [
                AudienceSection(title: "Why this matters", items: [
                    "Instability may occur without major trauma.",
                    "Ligaments, tendons, and fascia may be vulnerable.",
                    "Standard rehab timelines may not apply cleanly."
                ]),
                AudienceSection(title: "Common mistakes", items: [
                    "Assuming hypermobility is harmless flexibility.",
                    "Missing instability because the joint is not dislocated during the appointment.",
                    "Recommending aggressive stretching."
                ]),
                AudienceSection(title: "Safety considerations", items: [
                    "Evaluate instability patterns, not only static imaging.",
                    "Consider advanced imaging when function is severely limited.",
                    "Assess gait, compensation, and adjacent joints."
                ]),
                AudienceSection(title: "What helps", items: [
                    "Validate functional impairment.",
                    "Document instability and activity limits.",
                    "Coordinate with PT around stabilization, not flexibility."
                ])
            ]),
        Audience(
            id: "pt", label: "Physical Therapy", glyph: "↟", sfSymbol: "figure.strengthtraining.functional",
            short: "Stability, pacing, proprioception.",
            summary: "PT should prioritize stabilization, proprioception, pacing, and safe strengthening. Flexibility is not the goal.",
            sections: [
                AudienceSection(title: "Why this matters", items: [
                    "End-range positions can worsen instability.",
                    "Small movements may create large symptoms.",
                    "Fatigue and delayed flares may affect progression."
                ]),
                AudienceSection(title: "Common mistakes", items: [
                    "Stretching already hypermobile joints.",
                    "Progressing too fast because exercises look easy.",
                    "Ignoring delayed flares after sessions."
                ]),
                AudienceSection(title: "Safety considerations", items: [
                    "Avoid forced passive stretching unless specifically indicated.",
                    "Keep movements controlled and mid-range when needed.",
                    "Track delayed pain and fatigue response."
                ]),
                AudienceSection(title: "What helps", items: [
                    "Explain each exercise purpose.",
                    "Prioritize form over intensity.",
                    "Use pacing and flare planning."
                ])
            ]),
        Audience(
            id: "family", label: "Friend / Family", glyph: "☼", sfSymbol: "person.2.fill",
            short: "Invisible pain and useful support.",
            summary: "EDS symptoms can change daily. Someone can look fine and still be in serious pain or at risk of injury.",
            sections: [
                AudienceSection(title: "Why this matters", items: [
                    "Plans may change suddenly because symptoms fluctuate.",
                    "Pain and fatigue are not always visible.",
                    "Rest is often prevention, not laziness."
                ]),
                AudienceSection(title: "Common mistakes", items: [
                    "Saying, “but you looked fine yesterday.”",
                    "Treating mobility aids as giving up.",
                    "Taking cancellations personally."
                ]),
                AudienceSection(title: "Safety considerations", items: [
                    "Do not pull, yank, grab, or surprise-move the person’s body.",
                    "Ask before helping them up.",
                    "Respect pacing and rest."
                ]),
                AudienceSection(title: "What helps", items: [
                    "Offer specific help instead of vague support.",
                    "Be flexible with plans.",
                    "Ask what support is useful today."
                ])
            ])
    ]

    static func audience(id: String) -> Audience? {
        all.first { $0.id == id }
    }
}
