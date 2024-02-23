import Foundation
import SwiftUI


struct PokemonDetail: View {
    let pokemon: PokemonEntry
    @State private var detailPokemon: DetailPokemon?
    @State private var selectedTab: Tab = .About
    @State private var isLiked: Bool = false
    @State private var toastMessage = ""
    @State private var showToast = false
    @State private var shouldPopToRootView = false


    
    init(pokemon: PokemonEntry) {
        self.pokemon = pokemon
        _isLiked = State(initialValue: UserDefaults.standard.bool(forKey: "liked_\(pokemon.name)"))
    }

    enum Tab: String, CaseIterable {
        case About
        case Stats
        case Evolution
    }

    var body: some View {
        VStack {
            if let detailPokemon = detailPokemon {
                VStack(alignment: .leading, spacing: 20) {
                    HStack {
                        LazyHGrid(rows: [GridItem(.adaptive(minimum: 30), spacing: 5)], spacing: 5) {
                            ForEach(detailPokemon.types, id: \.slot) { type in
                                Button(action: {}) {
                                    Text(type.type.name.capitalized)
                                        .padding(10)
                                        .background(typeBackgroundColor(for: type.type.name))
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(typeBackgroundColor(for: type.type.name), lineWidth: 2)
                                        )
                                }
                                .frame(height: 20)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)

                        VStack(alignment: .trailing) {
                            Button(action: {
                                sharePokemon()
                            }) {
                                Image(systemName: "square.and.arrow.up")
                                    .foregroundColor(.blue)
                            }
                        }
                    
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .frame(maxHeight: 50)
                    .padding(16)

                }
                Text("#\(detailPokemon.id)")
                    .foregroundColor(Color(red: 37/255, green: 150/255, blue: 190/255))
                    .cornerRadius(10)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.trailing, 20) // Adjusted padding to trailing
                
                ZStack(alignment: .topTrailing) {
                    PokemonImageView(imageLink: detailPokemon.sprites.other.officialArtwork.front_default)
                        .padding(0)
                }


                TabBar(tabs: Tab.allCases, selectedTab: $selectedTab)
                TabView(selection: $selectedTab) {
                    AboutView(pokemon: pokemon, detailPokemon: detailPokemon)
                        .tag(Tab.About)
                    StatsView(detailPokemon: detailPokemon)
                        .tag(Tab.Stats)
                    EvolutionView(detailPokemon: detailPokemon)
                        .tag(Tab.Evolution)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))

            } else {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .purple))
                    .scaleEffect(1.5)
            }
            
            NavigationLink("", destination: ContentView(), isActive: $shouldPopToRootView)
                        .hidden()
        }
        .navigationBarTitle((pokemon.name.capitalized))

        .navigationBarItems(trailing: HStack {
            Button(action: {
                // Action for the heart symbol
                isLiked.toggle()
                UserDefaults.standard.set(isLiked, forKey: "liked_\(pokemon.name)")
            }) {
                Image(systemName: isLiked ? "heart.fill" : "heart")
            }
            .foregroundColor(isLiked ? .red : .gray)
        })
        .onAppear {
            getDetailInfoForPokemon()
        }
        .background(Color(red: 237/255, green: 246/255, blue: 255/255))
        .alert(isPresented: $showToast) {
            Alert(
                title: Text("Error"),
                message: Text(toastMessage),
                dismissButton: .default(Text("OK")) {
                    showToast = false
                }
            )
        }

    }

    func getDetailInfoForPokemon() {
        let api = PokeApi()
        api.getDetailsForPokemon(withURL: pokemon.url) { result in
            switch result {
            case .success(let detailPokemon):
                self.detailPokemon = detailPokemon
            case .failure(let error):
                DispatchQueue.main.async {
                    // Set the error message and show the toast
                    self.toastMessage = String(format: NSLocalizedString("errorFetchingDetails", comment: "Error fetching details"), error.localizedDescription)
                    self.showToast = true
                }
            }
        }
    }








    func sharePokemon() {
        guard let detailPokemon = detailPokemon else {
            return
        }

        let pokemonName = pokemon.name.capitalized
        let pokemonImage = detailPokemon.sprites.other.officialArtwork.front_default
        let shareTextFormat = NSLocalizedString("share %@", comment: "Share text format")
        let textToShare = String(format: shareTextFormat, pokemonName)
        let imageToShare = UIImage(data: try! Data(contentsOf: URL(string: pokemonImage)!))

        let activityViewController = UIActivityViewController(
            activityItems: [textToShare, imageToShare as Any],
            applicationActivities: nil
        )
        UIApplication.shared.windows.first?.rootViewController?.present(activityViewController, animated: true, completion: nil)
    }
}
