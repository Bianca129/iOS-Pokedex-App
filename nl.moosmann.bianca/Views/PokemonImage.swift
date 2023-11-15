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

            case .failure(let error):
                Text("Error loading image: \(error.localizedDescription)")

            @unknown default:
                Text("Unknown Phase")
            }
        }
        .onAppear {
            if let loadedData = UserDefaults.standard.string(forKey: imageLink) {
                getSprite(url: loadedData)
            } else {
                self.pokemonSprite = "placeholder"
            }
        }
        .clipShape(Circle())
        .foregroundColor(Color.gray.opacity(0.60))
        .scaledToFit()
    }

    // Fetch sprite for a given URL
    func getSprite(url: String) {
        PokemonSelectedApi().getSprite(url: url) { sprite in
            self.pokemonSprite = sprite.other.officialArtwork.front_default
        }
    }
}
