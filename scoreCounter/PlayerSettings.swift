import SwiftUI

struct PlayerSettings: View {
    @State var editingPlayer: PlayerData?
    @State var editMode: Bool = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(Settings.shared.players) { player in
                    HStack {
                        Image(systemName: "person.fill")
                            .foregroundStyle(player.colour)
                        Text(player.name)
                    }
                    .swipeActions(edge: .trailing) { 
                        Button("Delete") {
                            withAnimation {
                                Settings.shared.players.removeAll { $0.id == player.id }
                            }
                        }
                        .tint(.red)
                    }
                    .swipeActions(edge: .trailing) { 
                        Button("Edit") { 
                            editingPlayer = player
                        }
                        .tint(.blue)
                    }
                }
                .onMove { indices, newOffset in
                    Settings.shared.players.move(fromOffsets: indices, toOffset: newOffset)
                }
                Button("Add Player") {
                    editingPlayer = PlayerData(name: "", colour: .black)
                }
                .sheet(item: $editingPlayer) { val in
                    AddPlayerSettings(player: val, editingPlayer: $editingPlayer)
                }
            }
            .environment(\.editMode, editMode ? .constant(.active) : .constant(.inactive))
            .navigationTitle("Players")
            .scrollContentBackground(.hidden)
            .toolbar {
                Button(role: .cancel) {
                    withAnimation {
                        editMode.toggle()
                    }
                } label: {
                    if (editMode) {
                        Image(systemName: "checkmark")
                    } else {
                        Text("Reorder")
                    }
                }
            }
        }
    }
}

struct AddPlayerSettings: View {
    @State var player: PlayerData
    @Binding var editingPlayer: PlayerData?
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Name", text: Binding(get: { 
                    player.name
                }, set: { val in
                    player.name = val.capitalized
                }))
                ColorPicker("Colour", selection: Binding(get: { 
                    player.colour
                }, set: { val in
                    player.colour = val
                }))
                HStack {
                    Spacer()
                    Button("Submit") { 
                        if !player.name.isEmpty {
                            player.counters = Settings.shared.counters
                            Settings.shared.players.removeAll { $0.id == player.id }
                            
                            Settings.shared.players.append(player)
                            
                            editingPlayer = nil
                        }
                    }
                    Spacer()
                }
            }
        }
    }
}

#Preview { 
    PlayerSettings()
}
