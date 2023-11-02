import SwiftUI

struct EvolutionView: View {
    let detailPokemon: DetailPokemon
    @State private var evolutionInfo: String = "Loading..."

    var body: some View {
        VStack {
            Text("Evolution Chain")

            Text("Evolution URL: \(detailPokemon.species.url)")

            Text("Evolution Information: \(evolutionInfo)")
                .onAppear {
                    fetchEvolutionData()
                }
        }
    }
    
    func fetchEvolutionData() {
            PokeApi().fetchPokemonEvolutionData(forPokemonURL: detailPokemon.species.url) { result in
                switch result {
                case .success(let speciesURL):
                    // Hier kannst du auf die URL zur Evolutionskette zugreifen
                    let evolutionChainURL = detailPokemon.species.url
                    
                    // Rufe die Evolutionsdaten für evolutionChainURL ab
                    PokeApi().fetchPokemonEvolutionData(forPokemonURL: detailPokemon.species.url) { result in
                        switch result {
                        case .success(let evolutionDataURL):
                            // Hier kannst du die Daten aus evolutionDataURL verwenden
                            self.evolutionInfo = "Evolutionskette URL: \(evolutionDataURL)"
                        case .failure(let error):
                            self.evolutionInfo = "Fehler beim Abrufen der Evolutionsdaten: \(error.localizedDescription)"
                        }
                    }
                case .failure(let error):
                    self.evolutionInfo = "Fehler: \(error.localizedDescription)"
                }
            }
        }


    }


/*
    func fetchEvolutionData() {
        PokeApi().fetchPokemonEvolutionData(forPokemonURL: detailPokemon.species.url) { result in
            switch result {
                case .success(let speciesURL):
                    self.evolutionInfo = "Species URL: \(speciesURL)"
                case .failure(let error):
                    self.evolutionInfo = "Fehler: \(error.localizedDescription)"
            }
        }
    }
 */














