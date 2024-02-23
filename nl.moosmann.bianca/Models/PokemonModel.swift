import Foundation

struct Pokemon : Codable{
    var results: [PokemonEntry]
}

struct PokemonEntry: Codable, Identifiable, Hashable {
    var id: String { String(url.split(separator: "/").last ?? "") }
    var name: String
    var url: String
}