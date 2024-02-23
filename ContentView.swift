import Foundation
import SwiftUI


struct ContentView: View {
    @State private var pokemon = [PokemonEntry]()
    @State private var searchText = ""
    @State private var showToast = false
    @State private var toastMessage = ""
    @State private var currentPage = 0
    @State private var isLoadingNextPage = false
    
    @State private var nextURL: URL?
    


    let columns = [
        GridItem(.flexible(minimum: 150)),
        GridItem(.flexible(minimum: 150))
    ]
    
    func handleDataFetchingResult(_ result: Result<[PokemonEntry], Error>) {
        switch result {
        case .success(let fetchedPokemon):
            self.pokemon += fetchedPokemon
        case .failure(let error):
            handleDataFetchingError(error)
        }
    }


    var body: some View {
        TabView {
            NavigationView {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(pokemon.filter {
                            searchText.isEmpty || $0.name.capitalized.contains(searchText)
                        }) { entry in
                            PokemonGridItem(entry: entry)
                        }
                    }
                    .padding([.leading, .trailing], 20)
                    .overlay(
                        Group {
                            if isLoadingNextPage {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .purple))
                                    .scaleEffect(1.5)
                            }
                        }
                        .padding(.bottom, 50)
                    )
                }
                .onAppear {
                    fetchPokemonData()
                }
                .searchable(text: $searchText)
                .navigationTitle("allPokemons")
                .shadow(color: Color.gray, radius: 3, x: 0, y: 2)
                .shadow(color: Color.gray, radius: 3, x: 2, y: 0)
                .background(Color(red: 246/255, green: 246/255, blue: 255/255))
            }
            .tabItem {
                Image(systemName: "house")
                    .foregroundColor(.purple)
                Text("pokemons")
            }

            NavigationView {
                FavoritesView(pokemon: $pokemon)
            }
            .tabItem {
                Image(systemName: "heart.fill")
                    .foregroundColor(.purple)
                Text("fav")
            }
        }
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
    

    func fetchPokemonData() {
        guard !isLoadingNextPage else {
            return
        }

        let limit = 50
        let offset = 0

        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon?offset=\(offset)&limit=\(limit)") else {
            // Handle invalid URL
            return
        }

        PokeApi().getData(url: url) { result in
            switch result {
            case .success(let pokemonList):
                handleDataFetchingResult(.success(pokemonList.results))
                // Use optional binding to safely unwrap pokemonList.next
                if let nextUrlString = pokemonList.next {
                    fetchNextPage(nextUrl: nextUrlString)
                }
            case .failure(let error):
                handleDataFetchingError(error)
            }
            isLoadingNextPage = false
        }
    }

    
    
    
    

    func fetchNextPage(nextUrl: String?) {
        guard let unwrappedNextURLString = nextUrl,
              let unwrappedNextURL = URL(string: unwrappedNextURLString) else {
            isLoadingNextPage = false
            return
        }

        PokeApi().getData(url: unwrappedNextURL) { result in
            switch result {
            case .success(let pokemonList):
                handleDataFetchingResult(.success(pokemonList.results))

                // Check if it's the desired URL
                if pokemonList.next == nil {
                    nextURL = nil
                } else {
                    nextURL = URL(string: unwrappedNextURLString)
                    fetchNextPage(nextUrl: pokemonList.next)
                }

            case .failure(let error):
                // Handle other errors
                handleDataFetchingError(error)
            }
        }
    }


    func handleFetchedPokemonResult(_ result: Result<[PokemonEntry], Error>) {
        switch result {
            case .success(let fetchedPokemon):
                self.pokemon += fetchedPokemon
            case .failure(let error):
                handleDataFetchingError(error)
        }
    }


    func handleDataFetchingError(_ error: Error) {
        showToast = true
        toastMessage = NSLocalizedString("Failed To Fetch PokemonData", comment: "Error message when fetching Pokemon data fails.")
    }

}



