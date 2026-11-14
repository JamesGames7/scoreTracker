import SwiftUI

struct CountersView: View {
    @State var editingCounter: CountersData?
    @State var editMode: Bool = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(Settings.shared.counters) { counter in
                    HStack {
                        Image(systemName: counter.icon)
                        Text(counter.name)
                    }
                    .swipeActions(edge: .trailing) {
                        Button("Delete") {
                            withAnimation {
                                for index in 0..<Settings.shared.players.count {
                                    Settings.shared.players[index].counters.removeAll {
                                        $0.id == counter.id
                                    }
                                }
                                
                                Settings.shared.counters.removeAll(where: {$0.id == counter.id})
                            }
                        }
                        .tint(.red)
                    }
                    .swipeActions(edge: .trailing) {
                        Button("Edit") {
                            editingCounter = counter
                        }
                        .tint(.blue)
                    }
                }
                .onMove { indices, newOffset in
                    for index in 0..<Settings.shared.players.count {
                        Settings.shared.players[index].counters.move(fromOffsets: indices, toOffset: newOffset)
                    }
                    Settings.shared.counters.move(fromOffsets: indices, toOffset: newOffset)
                }
                Button("Add Counter") {
                    editingCounter = CountersData()
                }
                .sheet(item: $editingCounter) { val in
                    AddCountersSettings(counter: val, editingCounter: $editingCounter)
                }
            }
            .environment(\.editMode, editMode ? .constant(.active) : .constant(.inactive))
            .navigationTitle("Counters")
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

struct AddCountersSettings: View {
    @State var counter: CountersData
    @Binding var editingCounter: CountersData?
    
    var body: some View {
        NavigationStack {
            Form {
                Picker("Icon", selection: $counter.icon) {
                    Image(systemName: "atom").tag("atom")
                    Image(systemName: "bag.fill").tag("bag.fill")
                    Image(systemName: "dollarsign.circle.fill").tag("dollarsign.circle.fill")
                    Image(systemName: "trophy.fill").tag("trophy.fill")
                    Image(systemName: "crown.fill").tag("crown.fill")
                    Image(systemName: "bell.fill").tag("bell.fill")
                    Image(systemName: "tag.fill").tag("tag.fill")
                    Image(systemName: "bolt.fill").tag("bolt.fill")
                    Image(systemName: "flame.fill").tag("flame.fill")
                    Image(systemName: "drop.fill").tag("drop.fill")
                    Image(systemName: "leaf.fill").tag("leaf.fill")
                    Image(systemName: "fish.fill").tag("fish.fill")
                    Image(systemName: "pawprint.fill").tag("pawprint.fill")
                    Image(systemName: "cart.fill").tag("cart.fill")
                    Image(systemName: "gift.fill").tag("gift.fill")
                    Image(systemName: "hourglass").tag("hourglass")
                    Image(systemName: "sun.max.fill").tag("sun.max.fill")
                    Image(systemName: "snow").tag("snow")
                    Image(systemName: "umbrella.fill").tag("umbrella.fill")
                    Image(systemName: "book.fill").tag("book.fill")
                    Image(systemName: "graduationcap.fill").tag("graduationcap.fill")
                    Image(systemName: "gearshape.fill").tag("gearshape.fill")
                    Image(systemName: "key.fill").tag("key.fill")
                    Image(systemName: "lock.fill").tag("lock.fill")
                    Image(systemName: "car.fill").tag("car.fill")
                }
                TextField("Name", text: Binding(get: {
                    counter.name
                }, set: { val in
                    counter.name = val.capitalized
                }))
                HStack {
                    Spacer()
                    Button("Submit") {
                        if !counter.name.isEmpty {
                            for index in Settings.shared.players.indices {
                                Settings.shared.players[index].counters.removeAll {
                                    $0.id == counter.id
                                }
                                
                                Settings.shared.players[index].counters.append(counter)
                            }
                            
                            Settings.shared.counters.removeAll(where: {$0.id == counter.id})
                            
                            Settings.shared.counters.append(counter)
                            
                            editingCounter = nil
                        }
                    }
                    Spacer()
                }
            }
        }
    }
}

struct CountersData: Identifiable {
    let id = UUID()
    
    var icon: String = "atom"
    var name: String = ""
    var num: Int = 0
}

#Preview {
    CountersView()
}
