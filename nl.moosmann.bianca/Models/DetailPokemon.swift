import Foundation

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
