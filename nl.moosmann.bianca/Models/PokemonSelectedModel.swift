import Foundation

struct OfficialArtwork: Codable {
    let front_default: String
}

struct PokemonSelected: Codable {
    var sprites: PokemonSprites
    var weight: Int
}

struct PokemonSprites: Codable {
    let other: OtherSprites

    struct OtherSprites: Codable {
        let officialArtwork: OfficialArtwork

        enum CodingKeys: String, CodingKey {
            case officialArtwork = "official-artwork"
        }
    }
}
