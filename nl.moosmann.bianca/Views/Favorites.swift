import Foundation
import SwiftUI

struct FavoritesView: View {
    @Binding var pokemon: [PokemonEntry]
    @State private var favoritePokemon: [PokemonEntry] = []

    let columns = [
        GridItem(.flexible(minimum: 150)),
        GridItem(.flexible(minimum: 150))
    ]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(favoritePokemon, id: \.name) { pokemon in
                    NavigationLink(destination: PokemonDetailView(pokemon: pokemon)) {
                        VStack {
                            PokemonImage(imageLink: pokemon.url, pokemonName: pokemon.name.capitalized)
                                .frame(width: 170, height: 100)
                                .background(Color(red: 246/255, green: 246/255, blue: 255/255))
                            Text(pokemon.name.capitalized)
                                .padding(5)
                        }
                        .background(Color.white)
                        .cornerRadius(15)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding()
        }
        .background(Color(red: 237/255, green: 246/255, blue: 255/255))
        .shadow(color: Color.gray, radius: 3, x: 0, y: 2)
        .shadow(color: Color.gray, radius: 3, x: 2, y: 0)
        .navigationTitle("Favorites")
        .onAppear {
            loadFavoritePokemon()
        }
    }

    func loadFavoritePokemon() {
        favoritePokemon = []

        for pokemonEntry in pokemon {
            if UserDefaults.standard.bool(forKey: "liked_\(pokemonEntry.name)") {
                favoritePokemon.append(pokemonEntry)
            }
        }
    }
}
