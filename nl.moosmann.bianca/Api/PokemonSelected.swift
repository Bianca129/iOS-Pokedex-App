//
//  PokemonSelected.swift
//  nl.moosmann.bianca
//
//  Created by admin on 10/20/23.
//

import Foundation

struct OfficialArtwork: Codable {
    let front_default: String
}

struct PokemonSelected : Codable {
    var sprites: PokemonSprites
    var weight: Int
}

struct PokemonSprites: Codable {
    //let front_default: String?
    let other: OtherSprites

    struct OtherSprites: Codable {
        let officialArtwork: OfficialArtwork

        enum CodingKeys: String, CodingKey {
            case officialArtwork = "official-artwork"
        }
    }
}

class PokemonSelectedApi  {
    func getOfficialArtwork(url: String, completion: @escaping (OfficialArtwork?) -> ()) {
        guard let url = URL(string: url) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                completion(nil)
                return
            }
            
            do {
                let officialArtwork = try JSONDecoder().decode(OfficialArtwork.self, from: data)
                completion(officialArtwork)
            } catch {
                completion(nil)
            }
        }.resume()
    }
    
    func getSprite(url: String, completion: @escaping (PokemonSprites) -> ()) {
        guard let url = URL(string: url) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            
            let pokemonSprite = try! JSONDecoder().decode(PokemonSelected.self, from: data)
            
            DispatchQueue.main.async {
                completion(pokemonSprite.sprites)
            }
        }.resume()
    }
}
