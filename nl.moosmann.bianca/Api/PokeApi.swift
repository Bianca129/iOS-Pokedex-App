import Foundation
import UIKit


class PokeApi  {

  
    func getData(url: URL, completion: @escaping (Result<Pokemon, Error>) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                completion(.failure(ApiError.noData))
                return
            }

            do {
                let pokemonList = try JSONDecoder().decode(Pokemon.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(pokemonList))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }


   

        
        func getDetailsForPokemon(withURL url: String, completion: @escaping (Result<DetailPokemon, Error>) -> Void) {
            guard let apiUrl = URL(string: url) else {
                completion(.failure(ApiError.invalidUrl))
                return
            }
            
            URLSession.shared.dataTask(with: apiUrl) { (data, response, error) in
                guard let data = data else {
                    completion(.failure(ApiError.noData))
                    return
                }
                
                do {
                    let detailPokemon = try JSONDecoder().decode(DetailPokemon.self, from: data)
                    completion(.success(detailPokemon))
                } catch {
                    completion(.failure(error))
                }
            }.resume()
        }
    
    
    

    func fetchPokemonEvolutionData(forPokemonURL pokemonURL: URL?, completion: @escaping (Result<EvolutionData, Error>) -> Void) {
        
        guard let pokemonURL = pokemonURL else {
            completion(.failure(ApiError.invalidUrl))
            return
        }
        
        URLSession.shared.dataTask(with: pokemonURL) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(ApiError.noData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let evolutionChainData = try decoder.decode(EvolutionChainData.self, from: data)
                let evolutionChainURL = evolutionChainData.evolution_chain.url
                
                guard let evolutionDataURL = URL(string: evolutionChainURL.absoluteString) else {
                    completion(.failure(ApiError.invalidUrl))
                    return
                }
                
                URLSession.shared.dataTask(with: evolutionDataURL) { (data, response, error) in
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                    
                    guard let data = data else {
                        completion(.failure(ApiError.noData))
                        return
                    }
                    
                    do {
                        let decoder = JSONDecoder()
                        let evolutionData = try decoder.decode(EvolutionData.self, from: data)
                        completion(.success(evolutionData))
                    } catch {
                        completion(.failure(error))
                    }
                }.resume()
                
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    
   

    
    enum ApiError: Error {
        case invalidUrl
        case networkError(String)
        case noData
        case parsingError(String)
    }


}



