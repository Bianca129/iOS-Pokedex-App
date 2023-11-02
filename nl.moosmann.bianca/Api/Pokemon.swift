//
//  Pokemon.swift
//  nl.moosmann.bianca
//
//  Created by admin on 10/20/23.
//

import Foundation

struct Pokemon : Codable{
    var results: [PokemonEntry]
}

struct PokemonEntry: Codable, Identifiable, Hashable {
    let id = UUID()
    var name: String
    var url: String
}


class PokeApi  {
    
    func getData(completion:@escaping ([PokemonEntry]) -> ()) {
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=151") else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            
            let pokemonList = try! JSONDecoder().decode(Pokemon.self, from: data)
            
            DispatchQueue.main.async {
                completion(pokemonList.results)
            }
        }.resume()
    }
    
    
    func getDetailsForPokemon(withURL url: String, completion: @escaping (DetailPokemon?) -> Void) {
        guard let apiUrl = URL(string: url) else {
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: apiUrl) { (data, response, error) in
            guard let data = data else {
                completion(nil)
                return
            }

            do {
                let detailPokemon = try JSONDecoder().decode(DetailPokemon.self, from: data)
                completion(detailPokemon)
            } catch {
                completion(nil)
            }
        }.resume()
    }
    
    func fetchPokemonEvolutionData(forPokemonURL pokemonURL: URL, completion: @escaping (Result<URL?, Error>) -> Void) {
        print("In fetchPokemonEvolutionData")
        print(pokemonURL)

        URLSession.shared.dataTask(with: pokemonURL) { (data, response, error) in
            if let error = error {
                print("Fehler beim Abrufen der Daten: \(error)")
                completion(.failure(error))
                return
            }

            guard let data = data else {
                let noDataError = NSError(domain: "YourAppDomain", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                print("No data received")
                completion(.failure(noDataError))
                return
            }

            do {
                let decoder = JSONDecoder()
                let evolutionChainData = try decoder.decode(EvolutionChainData.self, from: data)
                let evolutionChainURL = evolutionChainData.evolution_chain.url

                guard let evolutionDataURL = URL(string: evolutionChainURL.absoluteString) else {
                    print("Ungültige URL: \(evolutionChainURL)")
                    completion(.failure(NSError(domain: "YourAppDomain", code: 0, userInfo: [NSLocalizedDescriptionKey: "Ungültige URL"])))
                    return
                }

                URLSession.shared.dataTask(with: evolutionDataURL) { (data, response, error) in
                    if let error = error {
                        print("Fehler beim Abrufen der Daten: \(error)")
                        completion(.failure(error))
                        return
                    }

                    guard let data = data else {
                        let noDataError = NSError(domain: "YourAppDomain", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                        print("No data received")
                        completion(.failure(noDataError))
                        return
                    }

                    do {
                        let decoder = JSONDecoder()
                        let evolutionData = try decoder.decode(EvolutionData.self, from: data)
                        print(evolutionData)
                        // Hier kannst du die Daten aus evolutionData verwenden.
                        completion(.success(evolutionChainURL))
                    } catch {
                        print("Fehler beim Decodieren der Evolution-URL: \(error)")
                        completion(.failure(error))
                    }
                }.resume()
            } catch {
                print("Fehler beim Decodieren der Pokemon-URL: \(error)")
                completion(.failure(error))
            }
        }.resume()
    }

}

struct DetailPokemon: Codable {
    let id: Int
    let height: Int
    let weight: Int
    let base_experience: Int 
    let sprites: PokemonSprites
    let abilities: [Ability]
    let types: [Type]
    let stats: [Stat]
    let species : Species
    
    
    
}

struct Ability: Codable {
    let ability: AbilityDetail
    let is_hidden: Bool
    let slot: Int
}

struct Species: Codable {
        let name: String
        let url: URL
    }

struct AbilityDetail: Codable {
    let name: String
    let url: String
}

struct Type: Codable {
    let slot: Int
    let type: TypeInfo
}

struct TypeInfo: Codable {
    let name: String
    let url: String
}


struct Stat: Codable, Hashable {
    let base_stat: Int
    let stat: StatInfo
    
    struct StatInfo: Codable {
        let name: String
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(base_stat)
        hasher.combine(stat.name)
    }

    static func == (lhs: Stat, rhs: Stat) -> Bool {
        return lhs.base_stat == rhs.base_stat && lhs.stat.name == rhs.stat.name
    }
}



struct EvolutionChainData: Codable {
    let evolution_chain: EvolutionChain

    struct EvolutionChain: Codable {
        let url: URL

    
    }
}




struct EvolutionData: Codable {
    let chain: Chain
    let id : Int
}


struct Chain: Codable {
    let evolves_to: [Chain]
    let species: Species
    let is_baby : Bool
}







