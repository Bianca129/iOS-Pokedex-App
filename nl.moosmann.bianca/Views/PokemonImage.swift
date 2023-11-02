//
//  PokemonImage.swift
//  nl.moosmann.bianca
//
//  Created by admin on 10/20/23.
//

import SwiftUI

struct PokemonImage: View {
    var imageLink: String
    var pokemonName: String

    @State private var pokemonSprite = ""

    var body: some View {
        AsyncImage(url: URL(string: pokemonSprite)) { phase in
            switch phase {
            case .empty:
                Text("Loading...")

            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .foregroundColor(Color.gray.opacity(0.60))

            case .failure:
                Text("Error")

            @unknown default:
                Text("Unknown Phase")
            }
        }
        .onAppear {
            if let loadedData = UserDefaults.standard.string(forKey: imageLink) {
                getSprite(url: loadedData)
            }  else {
                self.pokemonSprite = "placeholder"
            }
        }
        .clipShape(Circle())
        .foregroundColor(Color.gray.opacity(0.60))
        .scaledToFit()
    }


    func getSprite(url: String) {
        PokemonSelectedApi().getSprite(url: url) { sprite in
            self.pokemonSprite = sprite.other.officialArtwork.front_default ?? "placeholder"
        }
    }
}

/*
struct PokemonImage_Previews: PreviewProvider {
    static var previews: some View {
        let placeholderPokemon = PokemonEntry(name: "Pikachu", url: "https://example.com/pikachu")

        return PokemonImage(pokemon: placeholderPokemon)
            .previewLayout(.fixed(width: 150, height: 150))
    }
}
 */


/*

struct PokemonDetail_Previews: PreviewProvider {
    static var previews: some View {
        PokemonImage(imageLink: pokemon.sprites.other.officialArtwork.front_default)
            .previewInterfaceOrientation(.portrait)
    }
}*/




/*
struct PokemonImage: View {
    var imageLink = ""
    @State private var pokemonSprite = ""
    
    var body: some View {
        AsyncImage(url: URL(string: pokemonSprite))
            .frame(width: 200, height: 200)
            .onAppear {
                let loadedData = UserDefaults.standard.string(forKey: imageLink)
                
                if loadedData == nil {
                    getSprite(url: imageLink)
                    UserDefaults.standard.set(imageLink, forKey: imageLink)
                    //print("New url!!! Caching...")
                } else {
                    getSprite(url: loadedData!)
                    //print("Using cached url...")
                }
                //print(pokemonSprite)
            }
            .clipShape(Circle())
            .foregroundColor(Color.gray.opacity(0.60))
            .scaledToFit()
        
    }
    
    func getSprite(url: String) {
        var tempSprite: String?
        PokemonSelectedApi().getSprite(url: url) { sprite in
            tempSprite = sprite.front_default
            self.pokemonSprite = tempSprite ?? "placeholder"
        }
        
    }
}
 */
 



