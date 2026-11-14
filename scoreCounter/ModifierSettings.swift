import SwiftUI

struct ModifierSettings: View {
    var body: some View {
        NavigationStack {
            Form {
                ForEach(0..<4, id: \.self) { i in
                    HStack {
                        Slider(value: Binding(
                            get: {
                                Double(Settings.shared.modifiers[i])
                            }, set: { val in
                                Settings.shared.modifiers[i] = Int(val)
                            }
                        ), in: -10...10, step: 1.0)
                        TextField("val", value: Binding(
                            get: {
                                Settings.shared.modifiers[i]
                            }, set: { val in
                                Settings.shared.modifiers[i] = Int(val)
                            }
                        ), format: .number.sign(strategy: .always()))
                        .monospaced()
                        .fixedSize()
                    }
                }
                Button("Reset") {
                    Settings.shared.modifiers[0] = -5
                    Settings.shared.modifiers[1] = -1
                    Settings.shared.modifiers[2] = 1
                    Settings.shared.modifiers[3] = 5
                }
            }
            .navigationTitle("Modifiers")
            .scrollContentBackground(.hidden)
        }
    }
}

#Preview { 
    ModifierSettings()
}
