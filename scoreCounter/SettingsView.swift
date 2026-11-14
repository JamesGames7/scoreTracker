import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationStack {
            Form {
                NavigationLink("Players") { 
                    PlayerSettings()
                }
                NavigationLink("Modifiers") { 
                    ModifierSettings()
                }
                NavigationLink("Counters") {
                    CountersView()
                }
                NavigationLink("Random") {
                    RandomView()
                }
            }
            .navigationTitle("Settings")
            .scrollContentBackground(.hidden)
        }
    }
}

@Observable
class Settings {
    static var shared = Settings()
    
    var modifiers: [Int] = [-5, -1, 1, 5]
    var players: [PlayerData] = []
    var counters: [CountersData] = []
    var collapsed: Bool = false
}

#Preview { 
    SettingsView()
}
