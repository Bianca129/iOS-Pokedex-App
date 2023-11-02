//
//  PokemonDetailView.swift
//  nl.moosmann.bianca
//
//  Created by admin on 10/20/23.
//

import Foundation
import SwiftUI



struct PokemonDetailView: View {
    let pokemon: PokemonEntry
    @State private var detailPokemon: DetailPokemon?
    @State private var selectedTab: Tab = .About
    


    enum Tab: String, CaseIterable {
        case About
        case Stats
        case Evolution
    }

    var body: some View {
            VStack {
                if let detailPokemon = detailPokemon {

                    LazyHGrid(rows: [GridItem(.adaptive(minimum: 30), spacing: 5)], spacing: 5) {
                        ForEach(detailPokemon.abilities, id: \.slot) { ability in
                            Button(action: {
                                // Aktion ausführen, wenn auf den Button geklickt wird
                                print("Button tapped for ability: \(ability.ability.name)")
                            }) {
                                Text(ability.ability.name)
                                    .padding(10)
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.blue, lineWidth: 2)
                                    )
                            }
                            .frame(height: 20) // Hier legst du die Höhe der Buttons fest, passe sie nach Bedarf an
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading) // Die Zeile erstreckt sich über die gesamte Breite und wird linksbündig ausgerichtet
                    .frame(maxHeight: 50) // Hier begrenzen Sie die maximale Höhe der Zeile
                    .padding(16)

                    
                    
                    PokemonImageView(imageLink: detailPokemon.sprites.other.officialArtwork.front_default)

                        //
                        //.frame(width: 400, height: 250)
                        .padding(0)
                        //.border(Color.black, width: 2)

                    
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
            
            //.padding(.leading, 0)


        .navigationBarTitle((pokemon.name.capitalized))
        .onAppear {
            getDetailInfoForPokemon()
        }
        //.background(LinearGradient(gradient: Gradient(colors: [.blue, .clear]), startPoint: .top, endPoint: .init(x: 0.5, y: 1/2)))
        
       



    }
    
        
    
    func getDetailInfoForPokemon() {
        print("Fetching data for \(pokemon.name) from URL: \(pokemon.url)")
        let api = PokeApi()
        api.getDetailsForPokemon(withURL: pokemon.url) { detailPokemon in
            if let detailPokemon = detailPokemon {
                self.detailPokemon = detailPokemon
                print("Data loaded successfully")
            } else {
                print("Failed to load data")
                // Fehlerbehandlung hier
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
                            .foregroundColor(selectedTab == tab ? .blue : .clear)
                            .offset(y: 15)
                    )
            }
        }
        .padding(.horizontal, 16) // Fügt einen Abstand von 16 Einheiten am rechten und linken Bildschirmrand hinzu
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
                // Zeige ein Platzhalterbild oder eine Fehlermeldung an, falls das Laden fehlschlägt
                Text("Image Load Error")
            } else {
                // Zeige ein Lade- oder Platzhalterbild an, während das Bild geladen wird
                ProgressView()
            }
        }
    }
}







/*
struct PokemonDetailView: View {
    let pokemon: PokemonEntry
    @State private var detailPokemon: DetailPokemon?
    
    var body: some View {
        VStack {
            if let detailPokemon = detailPokemon {
                
                LazyHGrid(rows: [GridItem(.flexible())], spacing: 10) {
                    ForEach(detailPokemon.abilities, id: \.slot) { ability in
                        Button(action: {
                            // Aktion ausführen, wenn auf den Button geklickt wird
                            print("Button tapped for ability: \(ability.ability.name)")
                        }) {
                            Text(ability.ability.name)
                                .padding(10)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.blue, lineWidth: 2)
                                )
                        }
                    }
                }
                
                PokemonImageView(imageLink: detailPokemon.sprites.front_default ?? "")
                
                
                    Text("Name: \(pokemon.name.capitalized)")
                    //Text("ID: \(pokemon.id)")
                    Text("Height: \(detailPokemon.height)")
                    Text("Weight: \(detailPokemon.weight)")

            } else {
                Text("Loading...") // Zeige "Loading..." an, während die Detailinformationen abgerufen werden
            }
        }
        .navigationBarTitle((pokemon.name.capitalized))
        .onAppear {
            // Lade Detailinformationen, wenn die Ansicht erscheint
            getDetailInfoForPokemon()
        }
    }
    
    func getDetailInfoForPokemon() {
        let api = PokeApi()
        api.getDetailsForPokemon(withURL: pokemon.url) { detailPokemon in
            if let detailPokemon = detailPokemon {
                // Die Detailinformationen wurden erfolgreich abgerufen
                self.detailPokemon = detailPokemon
            } else {
                // Fehler beim Abrufen der Detailinformationen
                // Du kannst hier entsprechende Fehlerbehandlung hinzufügen
            }
        }
    }
}*/








