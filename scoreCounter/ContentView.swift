import SwiftUI

struct ContentView: View {
    @State var isSettingsVisible = false
    
    var body: some View {
        ZStack {
            NavigationStack {
                ScrollView(.vertical) {
                    AdaptiveGrid {
                        ForEach(Settings.shared.players) { player in
                            PlayerView(name: player.name, colour: player.colour, id: player.id)
                        }
                        Spacer()
                    }
                    .frame(maxWidth: Settings.shared.collapsed ? CGFloat(Settings.shared.players.count * 160 + 10) : .infinity)
                }
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Settings", systemImage: "sidebar.left") {
                            withAnimation(.easeOut) {
                                isSettingsVisible.toggle()
                            }
                        }
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Collapse", systemImage: Settings.shared.collapsed ? "plus" : "minus") {
                            withAnimation {
                                Settings.shared.collapsed.toggle()
                            }
                        }
                    }
                }
            }
            .zIndex(0)
            if isSettingsVisible {
                NavigationStack {
                    SettingsView()
                        .toolbar {
                            ToolbarItem(placement: .topBarLeading) {
                                Button("Back", systemImage: "chevron.left") {
                                    withAnimation(.easeInOut) {
                                        isSettingsVisible.toggle()
                                    }
                                }
                            }
                        }
                }
                .zIndex(1)
                .transition(.move(edge: .leading))
            }
        }
        .padding()
    }
}

struct AdaptiveGrid<Content: View>: View {
    private let columns = [GridItem(.adaptive(minimum: Settings.shared.collapsed ? 150 : 380), spacing: 10)]
    
    @ViewBuilder let content: () -> Content
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 10, content: {
            content()
        })
    }
}

#Preview {
    ContentView()
}
