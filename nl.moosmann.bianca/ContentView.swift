import Foundation
import SwiftUI

struct ContentView: View {
    @State var pokemon = [PokemonEntry]()
    @State var searchText = ""
    @State var selectedPokemon: PokemonEntry?

    let columns = [
        GridItem(.flexible(minimum: 150)),
        GridItem(.flexible(minimum: 150))
    ]

    var body: some View {
        TabView {
            // Tab 1
            NavigationView {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(pokemon.filter {
                            searchText.isEmpty || $0.name.capitalized.contains(searchText)
                        }) { entry in
                            PokemonGridItem(entry: entry)
                        }
                    }
                    .padding(10)
                }
                .onAppear {
                    fetchPokemonData()
                }
                .searchable(text: $searchText)
                .navigationTitle("All Pokémon's")
                .shadow(color: Color.gray, radius: 3, x: 0, y: 2)
                .shadow(color: Color.gray, radius: 3, x: 2, y: 0)
            }
            .tabItem {
                Image(systemName: "house")
                    .foregroundColor(.purple)
                Text("Pokemons")
            }
            
            // Tab 2
            NavigationView {
                FavoritesView(pokemon: $pokemon)
            }
            .tabItem {
                Image(systemName: "heart.fill")
                    .foregroundColor(.purple)
                Text("Favoriten")
            }
        }
    }

    func fetchPokemonData() {
        PokeApi().getData { fetchedPokemon in
            if fetchedPokemon.isEmpty {
                print("No Pokémon data fetched.")
            } else {
                print("Pokémon data fetched successfully.")
            }

            self.pokemon = fetchedPokemon
        }
    }
}



struct PokemonGridItem: View {
    let entry: PokemonEntry

    var body: some View {
        NavigationLink(destination: PokemonDetailView(pokemon: entry)) {
            VStack {
                PokemonImage(imageLink: entry.url, pokemonName: entry.name.capitalized)
                    .frame(width: 170, height: 100)
                    .background(Color(red: 246/255, green: 246/255, blue: 255/255))
                Text(entry.name.capitalized)
                    .padding(5)
            }
            .background(Color.white)
            .cornerRadius(15)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
