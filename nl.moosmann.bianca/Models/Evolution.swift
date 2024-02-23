import Foundation

struct EvolutionChainData: Codable {
    let evolution_chain: EvolutionChain
}

struct EvolutionChain: Codable {
    let url: URL
}

struct EvolutionData: Codable {
    let chain: Chain
    let id : Int
}


struct Chain: Codable {
    let evolves_to: [Chain]
    let is_baby : Bool
    let species: Species
}
