//
//  AboutView.swift
//  nl.moosmann.bianca
//
//  Created by admin on 10/21/23.
//

import Foundation
import SwiftUI

struct AboutView: View {
    let pokemon: PokemonEntry
    let detailPokemon: DetailPokemon

    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Text("Name").bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 16)
                    Text(pokemon.name.capitalized)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.trailing, 16)
                        .foregroundColor(Color.gray)
                }
                HStack {
                    Text("Base").bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 16)
                    Text(String(detailPokemon.base_experience))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.trailing, 16)
                        .foregroundColor(Color.gray)
                }
                HStack {
                    Text("Weight").bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 16)
                    Text(String(detailPokemon.weight))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.trailing, 16)
                        .foregroundColor(Color.gray)
                }
                HStack {
                    Text("Height").bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 16)
                    Text(String(detailPokemon.height))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.trailing, 16)
                        .foregroundColor(Color.gray)
                }
                HStack {
                    Text("Types").bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 16)
                    Text(detailPokemon.types.map { $0.type.name }.joined(separator: ", "))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.trailing, 16)
                        .foregroundColor(Color.gray)
                }
                HStack {
                    Text("Abilities").bold()
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


    
    /*
    var body: some View {
        List {
            Section() {
                TableRow(label: "Name", value: pokemon.name.capitalized)
                //TableRow(label: "ID", value: String(pokemon.id))
                TableRow(label: "Base", value: String(detailPokemon.base_experience))
                TableRow(label: "Weight", value: String(detailPokemon.weight))
                TableRow(label: "Height", value: String(detailPokemon.height))
                TableRow(label: "Types", value: detailPokemon.types.map { $0.type.name }.joined(separator: ", "))
                TableRow(label: "Abilities", value: detailPokemon.abilities.map { $0.ability.name }.joined(separator: ", "))
            }
        }
    }
     */
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
