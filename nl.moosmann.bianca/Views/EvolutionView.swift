import Foundation
import SwiftUI

struct EvolutionView: View {
    let detailPokemon: DetailPokemon
    @State private var evolutionInfo: EvolutionData?
    @State private var evolvedPokemonEntries: [PokemonEntry] = []
    @State private var isLoading = true
    @State private var showError = false
    @State private var errorMessage = ""

    var body: some View {
        VStack {
            if let evolutionData = evolutionInfo {
                ScrollView {
                    ForEach(evolvedPokemonEntries, id: \.id) { evolvedPokemonEntry in
                        NavigationLink(destination: PokemonDetail(pokemon: evolvedPokemonEntry)) {
                            HStack {
                                if let imageURL = URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(evolvedPokemonEntry.id).png") {
                                    AsyncImage(url: imageURL) { phase in
                                        switch phase {
                                        case .empty:
                                            ProgressView()
                                                .progressViewStyle(CircularProgressViewStyle(tint: .purple))
                                                .scaleEffect(1.5)
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

            } else if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .purple))
                    .scaleEffect(1.5)
                    .onAppear {
                        fetchEvolutionData()
                    }

            } else if showError {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
                    .onTapGesture {
                        // Optional: Implement logic to reset error state or try again
                        showError = false
                        fetchEvolutionData()
                    }

            } else {
                Text(NSLocalizedString("noEvoData", comment: "No evolution data available"))
            }
        }
        .onAppear {
            fetchEvolutionData()
        }
    }

    func fetchEvolutionData() {
        PokeApi().fetchPokemonEvolutionData(forPokemonURL: detailPokemon.species.url) { result in
            switch result {
            case .success(let evolutionData):
                self.evolutionInfo = evolutionData
                evolvedPokemonEntries = []
                displayEvolutionChain(evolutionData.chain)
            case .failure(let error):
                showError = true
                errorMessage = NSLocalizedString("evolutionDataFetchError", comment: "Error fetching evolution data")
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
