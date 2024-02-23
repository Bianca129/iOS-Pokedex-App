import Foundation

class PokeApi  {
    
    func getData(completion: @escaping ([PokemonEntry]?) -> Void) {
            guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon?offset=0&limit=1292") else {
                completion(nil)
                return
            }
            
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard let data = data else {
                    print("noData")
                    completion(nil)
                    return
                }
                
                do {
                    let pokemonList = try JSONDecoder().decode(Pokemon.self, from: data)
                    DispatchQueue.main.async {
                        completion(pokemonList.results)
                    }
                } catch {
                    print("errorDecode")
                    completion(nil)
                }
            }.resume()
        }
    
    
    func getDetailsForPokemon(withURL url: String, completion: @escaping (DetailPokemon?) -> Void) {
            guard let apiUrl = URL(string: url) else {
                print("invalideUrl \(url)")
                completion(nil)
                return
            }
            
            URLSession.shared.dataTask(with: apiUrl) { (data, response, error) in
                guard let data = data else {
                    print("noData")
                    completion(nil)
                    return
                }
                
                do {
                    let detailPokemon = try JSONDecoder().decode(DetailPokemon.self, from: data)
                    completion(detailPokemon)
                } catch {
                    print("errorDecode \(error)")
                    completion(nil)
                }
            }.resume()
        }
    

    func fetchPokemonEvolutionData(forPokemonURL pokemonURL: URL?, completion: @escaping (EvolutionData?) -> Void) {

            guard let pokemonURL = pokemonURL else {
                print("invalideUrl")
                completion(nil)
                return
            }
            
            URLSession.shared.dataTask(with: pokemonURL) { (data, response, error) in
                if let error = error {
                    print("errorFetch \(error)")
                    completion(nil)
                    return
                }
                
                guard let data = data else {
                    print("noData")
                    completion(nil)
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let evolutionChainData = try decoder.decode(EvolutionChainData.self, from: data)
                    let evolutionChainURL = evolutionChainData.evolution_chain.url
                    
                    guard let evolutionDataURL = URL(string: evolutionChainURL.absoluteString) else {
                        print("invalideUrl \(evolutionChainURL.absoluteString)")
                        completion(nil)
                        return
                    }
                    
                    URLSession.shared.dataTask(with: evolutionDataURL) { (data, response, error) in
                        if let error = error {
                            print("errorFetch \(error)")
                            completion(nil)
                            return
                        }
                        
                        guard let data = data else {
                            print("noData")
                            completion(nil)
                            return
                        }
                        
                        do {
                            let decoder = JSONDecoder()
                            let evolutionData = try decoder.decode(EvolutionData.self, from: data)
                            completion(evolutionData)
                        } catch {
                            print("errorDecode \(error)")
                            completion(nil)
                        }
                    }.resume()
                    
                } catch {
                    print("errorDecode \(error)")
                    completion(nil)
                }
            }.resume()
        }
}
