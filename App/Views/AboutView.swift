import Foundation
import SwiftUI

struct AboutView: View {
    let pokemon: PokemonEntry
    let detailPokemon: DetailPokemon

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Text("name").bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 16)
                    Text(pokemon.name.capitalized)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.trailing, 16)
                        .foregroundColor(Color.gray)
                }
                HStack {
                    Text("base").bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 16)
                    Text(String(detailPokemon.base_experience))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.trailing, 16)
                        .foregroundColor(Color.gray)
                }
                HStack {
                    Text("weight").bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 16)
                    Text(String(detailPokemon.weight))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.trailing, 16)
                        .foregroundColor(Color.gray)
                }
                HStack {
                    Text("height").bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 16)
                    Text(String(detailPokemon.height))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.trailing, 16)
                        .foregroundColor(Color.gray)
                }
                HStack {
                    Text("types").bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 16)
                    Text(detailPokemon.types.map { $0.type.name }.joined(separator: ", "))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.trailing, 16)
                        .foregroundColor(Color.gray)
                }
                HStack {
                    Text("abilities").bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 16)
                    Text(detailPokemon.abilities.map { $0.ability.name }.joined(separator: ", "))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.trailing, 16)
                        .foregroundColor(Color.gray)
                }
            }
            .padding(.top, 20)
        }
    }
}

struct TableRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
            Spacer()
            Text(value)
        }
    }
}
