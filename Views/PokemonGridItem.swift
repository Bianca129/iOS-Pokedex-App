import Foundation
import SwiftUI

struct PokemonGridItem: View {
    let entry: PokemonEntry
    @State private var isLoadingImage = false


    var body: some View {
        NavigationLink(destination: PokemonDetail(pokemon: entry)) {
            VStack {
                ZStack(alignment: .topLeading) {
                    if isLoadingImage {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .purple))
                            .scaleEffect(1.5)
                    }

                    PokemonImage(imageLink: entry.url, pokemonName: entry.name.capitalized)
                        .frame(width: 170, height: 90)
                        .background(Color(red: 246/255, green: 246/255, blue: 255/255))
                        .onAppear {
                            isLoadingImage = true
                        }
                        .onDisappear {
                            isLoadingImage = false
                        }

                    if let range = entry.url.range(of: "pokemon/") {
                        let id = entry.url[range.upperBound...].trimmingCharacters(in: CharacterSet(charactersIn: "/"))

                        Text("#\(id)")
                            .foregroundColor(Color(red: 37/255, green: 150/255, blue: 190/255))
                            .font(.body)
                            .padding(5)
                            .cornerRadius(10)
                            .offset(x: 5, y: 5)
                    }
                }
                Text(entry.name.capitalized)
                    .padding(5)
            }
            .background(Color.white)
            .cornerRadius(15)
            .padding([.top, .leading, .trailing], 5)
            .padding(.bottom, 0)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
