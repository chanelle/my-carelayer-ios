import SwiftUI
import SwiftData

/// Form editor mirroring the web sections (Identity / Medical context /
/// Emergency contact) plus the native brief's Communication & Sensory
/// and Notes sections.
///
/// Saving: SwiftData autosaves edits made through @Bindable. An explicit
/// "Saved" indicator is still shown (mirroring the web Save button) —
/// tapping Save commits via modelContext.save() and shows the check
/// for 2 seconds. This keeps the familiar affordance without a
/// separate draft copy of the profile.
struct ProfileEditorView: View {
    @Bindable var profile: UserProfile
    /// True when shown as a sheet (Home / Card), so it gets a Done button.
    var isSheet = false
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var showSaved = false
    @State private var confirmClear = false
    @State private var customPronouns = ""
    @State private var customConditionType = ""
    // Custom mode is tracked explicitly. Deriving it from the stored value
    // alone failed: choosing "Custom" stored "" and the picker snapped
    // straight back, so the custom text field never appeared.
    @State private var isCustomPronouns = false
    @State private var isCustomCondition = false

    private var pronounPickerValue: String {
        if isCustomPronouns { return "Custom" }
        return profile.pronouns.isEmpty ? "Prefer not to say" : profile.pronouns
    }
    private var conditionPickerValue: String {
        isCustomCondition ? "Other / custom" : profile.primaryConditionType
    }

    /// Restores custom mode for values that aren't in the option lists.
    private func syncCustomModes() {
        if !profile.pronouns.isEmpty, !ProfileOptions.pronouns.contains(profile.pronouns) {
            isCustomPronouns = true
            customPronouns = profile.pronouns
        }
        if !profile.primaryConditionType.isEmpty,
           !ProfileOptions.conditionTypes.contains(profile.primaryConditionType) {
            isCustomCondition = true
            customConditionType = profile.primaryConditionType
        }
    }

    var body: some View {
        Form {
            headerSection
            identitySection
            medicalSection
            communicationSection
            notesSection
            emergencySection
            manageSection
            saveSection
        }
        .scrollContentBackground(.hidden)
        .background(CarePalette.background)
        .navigationTitle("My Profile")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if isSheet {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        try? modelContext.save()
                        dismiss()
                    }
                }
            }
        }
        .onAppear(perform: syncCustomModes)
        .confirmationDialog("Clear my information?",
                            isPresented: $confirmClear, titleVisibility: .visible) {
            Button("Clear Everything", role: .destructive) {
                profile.clearAll()
                isCustomPronouns = false; customPronouns = ""
                isCustomCondition = false; customConditionType = ""
                try? modelContext.save()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This removes all profile information stored on this device. There is no backup.")
        }
    }

    private var headerSection: some View {
        Section {
            VStack(alignment: .leading, spacing: 8) {
                Text("GUIDED SETUP")
                    .font(.caption2.weight(.semibold)).tracking(2)
                    .foregroundStyle(CarePalette.mutedText)
                Text("My Profile").font(.largeTitle.weight(.semibold))
                    .accessibilityAddTraits(.isHeader)
                Text("Structured fields make the card easier to scan and safer to show.")
                    .font(.body).foregroundStyle(CarePalette.mutedText)
            }
            .listRowBackground(CarePalette.card)
        }
    }

    private var identitySection: some View {
        Section("Identity") {
            TextField("Display name", text: $profile.displayName)
                .accessibilityLabel("Display name")
            Picker("Age", selection: $profile.ageLabel) {
                Text("Not set").tag("")
                ForEach(ProfileOptions.ageOptions, id: \.self) { Text($0).tag($0) }
            }
            DatePicker("Date of birth",
                       selection: Binding(
                        get: { profile.dateOfBirth ?? Date() },
                        set: { profile.dateOfBirth = $0 }),
                       displayedComponents: .date)
            if let dob = profile.dateOfBirth {
                Text("Shows as: \(Formatting.formatDOB(dob))")
                    .font(.footnote).foregroundStyle(CarePalette.mutedText)
            }
            Button("Clear date of birth") { profile.dateOfBirth = nil }
                .font(.footnote)
            Picker("Pronouns", selection: Binding(
                get: { pronounPickerValue },
                set: { newValue in
                    isCustomPronouns = newValue == "Custom"
                    profile.pronouns = isCustomPronouns ? customPronouns : newValue
                })) {
                ForEach(ProfileOptions.pronouns, id: \.self) { Text($0).tag($0) }
            }
            if pronounPickerValue == "Custom" {
                TextField("Custom pronouns", text: $customPronouns)
                    .onChange(of: customPronouns) { _, value in profile.pronouns = value }
                    .accessibilityLabel("Custom pronouns")
            }
        }
    }

    private var medicalSection: some View {
        Section("Medical context") {
            Picker("EDS type", selection: Binding(
                get: { conditionPickerValue },
                set: { newValue in
                    isCustomCondition = newValue == "Other / custom"
                    profile.primaryConditionType =
                        isCustomCondition ? customConditionType : newValue
                })) {
                Text("Not set").tag("")
                ForEach(ProfileOptions.conditionTypes, id: \.self) { Text($0).tag($0) }
            }
            if conditionPickerValue == "Other / custom" {
                TextField("Custom EDS type", text: $customConditionType)
                    .onChange(of: customConditionType) { _, value in
                        profile.primaryConditionType = value
                    }
                    .accessibilityLabel("Custom EDS type")
            }
            Picker("Status", selection: $profile.conditionStatus) {
                Text("Not set").tag("")
                ForEach(ProfileOptions.conditionStatuses, id: \.self) { Text($0).tag($0) }
            }
            VStack(alignment: .leading, spacing: 6) {
                Text("Related conditions").font(.subheadline.weight(.semibold))
                ChipMultiSelectEditor(title: "Related conditions",
                                      options: ProfileOptions.relatedConditions,
                                      selection: $profile.relatedConditions)
            }
            VStack(alignment: .leading, spacing: 6) {
                Text("Medications").font(.subheadline.weight(.semibold))
                ChipMultiSelectEditor(title: "Medications",
                                      options: ProfileOptions.medications,
                                      selection: $profile.medications)
            }
            VStack(alignment: .leading, spacing: 6) {
                Text("Allergies / sensitivities").font(.subheadline.weight(.semibold))
                ChipMultiSelectEditor(title: "Allergies / sensitivities",
                                      options: ProfileOptions.allergies,
                                      selection: $profile.allergies)
            }
            VStack(alignment: .leading, spacing: 6) {
                Text("Mobility aids").font(.subheadline.weight(.semibold))
                ChipMultiSelectEditor(title: "Mobility aids",
                                      options: ProfileOptions.mobilityAids,
                                      selection: $profile.mobilityAids)
            }
            Toggle(isOn: $profile.hasAdhesiveSensitivity) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Adhesive sensitivity").fontWeight(.semibold)
                    Text("Shows a warning on the card.")
                        .font(.footnote).foregroundStyle(CarePalette.mutedText)
                }
            }
            VStack(alignment: .leading, spacing: 6) {
                Text("Critical notes").font(.subheadline.weight(.semibold))
                TextEditor(text: $profile.criticalNotes)
                    .frame(minHeight: 80)
                    .accessibilityLabel("Critical notes")
            }
        }
    }

    private var communicationSection: some View {
        Section("Communication & Sensory") {
            labeledEditor("Sensory needs", text: $profile.sensoryNeeds)
            labeledEditor("Communication needs", text: $profile.communicationNeeds)
            labeledEditor("Accommodations", text: $profile.accommodations)
        }
    }

    private var notesSection: some View {
        Section("Notes") {
            labeledEditor("Important medical history", text: $profile.medicalHistoryNotes)
            labeledEditor("Notes the user wants clinicians to know", text: $profile.clinicianNotes)
        }
    }

    private func labeledEditor(_ label: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label).font(.subheadline.weight(.semibold))
            TextEditor(text: text).frame(minHeight: 60).accessibilityLabel(label)
        }
    }

    private var emergencySection: some View {
        Section("Emergency contact") {
            Menu {
                ForEach(ProfileOptions.sampleContacts) { contact in
                    Button(contact.name) {
                        profile.emergencyContactName = contact.name
                        profile.emergencyContactPhone = contact.phone
                    }
                }
            } label: {
                Label("Choose from sample contacts", systemImage: "person.crop.badge.plus")
                    .frame(minHeight: CareSpacing.minTouchTarget)
            }
            TextField("Contact name", text: $profile.emergencyContactName)
                .accessibilityLabel("Emergency contact name")
            TextField("Contact phone", text: $profile.emergencyContactPhone)
                .keyboardType(.phonePad)
                .accessibilityLabel("Emergency contact phone")
                .onChange(of: profile.emergencyContactPhone) { _, value in
                    let formatted = Formatting.formatPhone(value)
                    if formatted != value, value.count >= 10 { profile.emergencyContactPhone = formatted }
                }
            if !profile.emergencyContactPhone.isEmpty {
                Text("Shows as: \(Formatting.formatPhone(profile.emergencyContactPhone))")
                    .font(.footnote).foregroundStyle(CarePalette.mutedText)
            }
        }
    }

    private var manageSection: some View {
        Section("Manage") {
            Button("Load sample profile") {
                profile.loadSampleValues()
                isCustomPronouns = false; isCustomCondition = false
                try? modelContext.save()
            }
            Button("Clear my information", role: .destructive) { confirmClear = true }
        }
    }

    private var saveSection: some View {
        Section {
            Button {
                try? modelContext.save()
                showSaved = true
                Task {
                    try? await Task.sleep(for: .seconds(2))
                    showSaved = false
                }
            } label: {
                HStack {
                    Spacer()
                    if showSaved {
                        Label("Saved", systemImage: "checkmark.circle.fill").font(.headline)
                    } else {
                        Text("Save profile").font(.headline)
                    }
                    Spacer()
                }
                .frame(minHeight: CareSpacing.minTouchTarget)
            }
            .buttonStyle(.borderedProminent).tint(CarePalette.primary)
            .listRowBackground(Color.clear)
        }
    }
}
