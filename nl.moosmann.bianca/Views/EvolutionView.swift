import SwiftUI

struct EvolutionView: View {
    let detailPokemon: DetailPokemon
    @State private var evolutionInfo: EvolutionData?
    @State private var evolvedPokemonEntries: [PokemonEntry] = []

    var body: some View {
        VStack {
            if let evolutionData = evolutionInfo {
                ScrollView {
                    ForEach(evolvedPokemonEntries, id: \.id) { evolvedPokemonEntry in
                        NavigationLink(destination: PokemonDetailView(pokemon: evolvedPokemonEntry)) {
                            HStack {
                                if let imageURL = URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(evolvedPokemonEntry.id).png") {
                                    AsyncImage(url: imageURL) { phase in
                                        switch phase {
                                        case .empty:
                                            ProgressView()
                                        case .success(let image):
                                            image
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 100, height: 100)
                                        case .failure:
                                            Image(systemName: "photo")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 100, height: 100)
                                        }
                                    }
                                    .padding(.trailing, 16)
                                }

                                VStack(alignment: .leading) {
                                    Text("# \(evolvedPokemonEntry.id)")
                                        .padding(5)
                                        .background(Color(red: 37/255, green: 150/255, blue: 190/255))
                                        .foregroundColor(.white)
                                        .cornerRadius(10)

                                    Text(evolvedPokemonEntry.name.capitalized)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                .padding(16)
                                .background(Color(red: 237/255, green: 246/255, blue: 255/255))
                            }

                            .padding(16)
                        }
                        Divider()
                            .background(Color.black)
                            .padding(.horizontal, 16)
                    }
                }
                .background(Color(red: 237/255, green: 246/255, blue: 255/255))
            } else {
                Text("no Evolution data")
            }
        }
        .onAppear {
            fetchEvolutionData()
        }
    }

    func fetchEvolutionData() {
        PokeApi().fetchPokemonEvolutionData(forPokemonURL: detailPokemon.species.url) { evolutionData in
            if let evolutionData = evolutionData {
                self.evolutionInfo = evolutionData
                evolvedPokemonEntries = []
                displayEvolutionChain(evolutionData.chain)
            }
        }
    }

    func displayEvolutionChain(_ chain: Chain) {
        let pokemonId = extractPokemonId(from: chain.species.url)
        let urlString = "https://pokeapi.co/api/v2/pokemon/\(pokemonId)"
        let evolvedPokemonEntry = PokemonEntry(name: chain.species.name, url: urlString)
        evolvedPokemonEntries.append(evolvedPokemonEntry)

        for evolvesTo in chain.evolves_to {
            displayEvolutionChain(evolvesTo)
        }
    }

    func extractPokemonId(from url: URL) -> String {
        guard let lastPathComponent = url.pathComponents.last else {
            return ""
        }
        return lastPathComponent
    }
}
