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
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(pokemon.filter {
                        searchText.isEmpty || $0.name.capitalized.contains(searchText)
                    }) { entry in
                        NavigationLink(destination: PokemonDetailView(pokemon: entry)) {
                            VStack {
                                PokemonImage(imageLink: entry.url, pokemonName: entry.name.capitalized)
                                    .frame(width: 170, height: 100)
                                    .background(Color(red: 246/255, green: 246/255, blue: 255/255))
                                Text(entry.name.capitalized)
                                    .padding(5)
                            }
                            //.border(Color.black, width: 1)
                            .background(Color.white)
                            .cornerRadius(15)
                            //.shadow(color: Color.gray, radius: 3, x: 0, y: 2) // Fügt Schatten hinzu

                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(10)
            }
            .onAppear {
                PokeApi().getData() { pokemon in
                    self.pokemon = pokemon
                }
            }
            .searchable(text: $searchText)
            .navigationTitle("PokedexUI")
            .background(Color(red: 237/255, green: 246/255, blue: 255/255))
            .shadow(color: Color.gray, radius: 3, x: 0, y: 2)
            .shadow(color: Color.gray, radius: 3, x: 2, y: 0)



        }
    }

}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
