import SwiftUI

struct RandomView: View {
    @State var showAlert = false
    
    var body: some View {
        NavigationStack {
            List {
                Button("Choose random player") { 
                    showAlert = true
                }
                .alert(Settings.shared.players.map { player in
                    player.name
                    }.randomElement() ?? "", isPresented: $showAlert) { 
                        Button("OK") {
                            showAlert = false
                        }
                    }
            }
            .navigationTitle("Random")
            .scrollContentBackground(.hidden)
        }
    }
}

#Preview { 
    RandomView()
}
