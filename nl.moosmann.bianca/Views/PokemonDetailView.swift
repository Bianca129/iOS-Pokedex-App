// PokemonDetailView.swift
// nl.moosmann.bianca
// Created by admin on 10/20/23.

import Foundation
import SwiftUI

struct PokemonDetailView: View {
    let pokemon: PokemonEntry
    @State private var detailPokemon: DetailPokemon?
    @State private var selectedTab: Tab = .About
    @State private var isLiked: Bool = false

    init(pokemon: PokemonEntry) {
        self.pokemon = pokemon
        _isLiked = State(initialValue: UserDefaults.standard.bool(forKey: "liked_\(pokemon.name)"))
    }

    enum Tab: String, CaseIterable {
        case About
        case Stats
        case Evolution
    }

    var body: some View {
        VStack {
            if let detailPokemon = detailPokemon {
                LazyHGrid(rows: [GridItem(.adaptive(minimum: 30), spacing: 5)], spacing: 5) {
                    ForEach(detailPokemon.types, id: \.slot) { type in
                        Button(action: {
                            // Action to perform when the button is tapped
                        }) {
                            Text(type.type.name.capitalized)
                                .padding(10)
                                .background(typeBackgroundColor(for: type.type.name))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(typeBackgroundColor(for: type.type.name), lineWidth: 2)
                                )
                        }
                        .frame(height: 20)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(maxHeight: 50)
                .padding(16)

                PokemonImageView(imageLink: detailPokemon.sprites.other.officialArtwork.front_default)
                    .padding(0)

                TabBar(tabs: Tab.allCases, selectedTab: $selectedTab)
                TabView(selection: $selectedTab) {
                    AboutView(pokemon: pokemon, detailPokemon: detailPokemon)
                        .tag(Tab.About)
                    StatsView(detailPokemon: detailPokemon)
                        .tag(Tab.Stats)
                    EvolutionView(detailPokemon: detailPokemon)
                        .tag(Tab.Evolution)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
            } else {
                ProgressView("Loading...")
            }
        }
        .navigationBarTitle((pokemon.name.capitalized))
        .navigationBarItems(trailing: HStack {
            Button(action: {
                // Action for the heart symbol
                isLiked.toggle()
                UserDefaults.standard.set(isLiked, forKey: "liked_\(pokemon.name)")
            }) {
                Image(systemName: isLiked ? "heart.fill" : "heart")
            }
            .foregroundColor(isLiked ? .red : .gray)
        })
        .onAppear {
            getDetailInfoForPokemon()
        }
        .background(Color(red: 237/255, green: 246/255, blue: 255/255))
    }

    func getDetailInfoForPokemon() {
        let api = PokeApi()
        api.getDetailsForPokemon(withURL: pokemon.url) { detailPokemon in
            if let detailPokemon = detailPokemon {
                self.detailPokemon = detailPokemon
            }
        }
    }
}

struct TabBar: View {
    let tabs: [PokemonDetailView.Tab]
    @Binding var selectedTab: PokemonDetailView.Tab

    var body: some View {
        HStack(spacing: 0) {
            ForEach(tabs, id: \.self) { tab in
                Text(tab.rawValue)
                    .font(selectedTab == tab ? .system(size: 18, weight: .bold) : .system(size: 18, weight: .bold))
                    .foregroundColor(selectedTab == tab ? .black : .gray)
                    .onTapGesture {
                        selectedTab = tab
                    }
                    .frame(maxWidth: .infinity)
                    .overlay(
                        Rectangle()
                            .frame(height: 2)
                            .foregroundColor(selectedTab == tab ? .purple : .clear)
                            .offset(y: 15)
                    )
            }
        }
        .padding(.horizontal, 16)
    }
}

struct PokemonImageView: View {
    var imageLink: String

    var body: some View {
        AsyncImage(url: URL(string: imageLink)) { phase in
            if let image = phase.image {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else if phase.error != nil {
                Text("Image Load Error")
            } else {
                ProgressView()
            }
        }
    }
}

func typeBackgroundColor(for typeName: String) -> Color {
    let lowercaseTypeName = typeName.lowercased()
    switch lowercaseTypeName {
    case "normal":
        return Color.gray
    case "fighting":
        return Color.red
    case "flying":
        return Color.blue
    case "poison":
        return Color.purple
    case "ground":
        return Color.brown
    case "rock":
        return Color.gray
    case "bug":
        return Color.green
    case "ghost":
        return Color.purple
    case "steel":
        return Color.gray
    case "fire":
        return Color.red
    case "water":
        return Color.blue
    case "grass":
        return Color.green
    case "electric":
        return Color.yellow
    case "psychic":
        return Color.pink
    case "ice":
        return Color.blue
    case "dragon":
        return Color.blue
    case "dark":
        return Color.gray
    case "fairy":
        return Color.pink
    default:
        return Color.gray
    }
}
