import SwiftUI

struct PlayerView: View {
    var name: String
    var colour: Color
    var id: UUID
    
    @State var score: Int = 0
    @State var changing: Int = 0;
    @State var isChanging: Bool = false;
    @State private var resetTask: Task<Void, Error>? = nil
    @Bindable var settings = Settings.shared
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "person.fill")
                    .foregroundStyle(colour)
                    .font(.system(size: 26))
                
                Text(name)
                    .font(.system(size: 23))
                    .fontWeight(.bold)
                    .foregroundStyle(.primary)
                    
                
                Spacer()
                if (!Settings.shared.collapsed) {
                    Button {
                        score -= changing
                        changing = 0
                    } label: {
                        Text("\(changing.formatted(.number.sign(strategy: .always())))")
                            .font(.system(size: 20))
                            .fontWeight(.bold)
                            .padding(10)
                            .background(
                                (isChanging ? colour : Color.init(hue: 0, saturation: 0, brightness: 0.75))
                                    .animation(.easeInOut(duration: 0.2), value: isChanging))
                            .clipShape(.rect(cornerRadius: 10))
                            .monospaced()
                            .foregroundStyle(.black)
                    }

                }
            }
            
            HStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(height: 55)
                        .foregroundStyle(.tertiary)
                    
                    Text("\(score)".replacing(",", with: ""))
                        .font(.title.bold())
                        .scaledToFit()
                }
                if !Settings.shared.collapsed {
                    ForEach(Settings.shared.modifiers, id: \.self) { mod in
                        Button(action: {
                            resetTask?.cancel()
                            
                            score += mod
                            changing = isChanging ? changing + mod : mod
                            isChanging = true
                            
                            resetTask = Task {
                                try? await Task.sleep(nanoseconds: 1500000000)
                                if !Task.isCancelled {await stopChanging()}
                            }
                        }, label: {
                            scoreMod(mod: mod)
                        })
                    }
                }
            }
            if (!Settings.shared.collapsed) {
                VStack {
                    ForEach($settings.players.first(where: {$0.id == id})?.counters ?? .constant([])) { $counter in
                        Divider()
                        HStack {
                            Image(systemName: counter.icon)
                                .foregroundStyle(colour, .secondary)
                                .font(.system(size: 20, weight: .bold))
                                .frame(width: 25)
                            Text(counter.name)
                            Spacer()
                            Stepper("\(counter.num)") {
                                counter.num += 1
                            } onDecrement: {
                                counter.num -= 1
                            }
                            .fixedSize()
                        }
                    }
                }
            } else {
                VStack {
                    ForEach($settings.players.first(where: {$0.id == id})?.counters ?? .constant([])) { $counter in
                        Divider()
                        HStack {
                            Image(systemName: counter.icon)
                                .foregroundStyle(colour, .secondary)
                                .font(.system(size: 16, weight: .bold))
                            Spacer()
                            Text("\(counter.num)")
                        }
                    }
                }
            }
        }
        .frame(maxWidth: Settings.shared.collapsed ? .infinity : .infinity)
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(.quaternary)
        }
    }
    
    func stopChanging() async {
        isChanging = false
    }
}

struct scoreMod: View {
    var mod: Int = 0
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .frame(width: 55, height: 55)
                .foregroundStyle(mod < 0 ? .red : .green)
            
            Text("\(mod.formatted(.number.sign(strategy: .always())))")
                .font(.title.bold())
                .foregroundStyle(.white)
                .monospaced()
        }
    }
}

struct PlayerData: Identifiable {
    let id = UUID()
    
    var name: String
    var colour: Color
    var counters: [CountersData] = []
}

#Preview {
    PlayerView(name: "Connor", colour: .indigo, id: UUID())
}
