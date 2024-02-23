import SwiftUI

struct PokemonImage: View {
    var imageLink: String
    var pokemonName: String

    @State private var pokemonSprite = ""
    @State private var isLoadingImage = false
    @State private var errorMessage: String?
    @State private var toastMessage = ""
    @State private var showToast = false

    var body: some View {
        ZStack {
            if isLoadingImage {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .purple))
                    .scaleEffect(1.5)
            }

            AsyncImage(url: URL(string: pokemonSprite)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .purple))
                        .scaleEffect(1.5)
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(Circle())
                        .foregroundColor(Color.gray.opacity(0.60))
                case .failure(let error):
                    Text(NSLocalizedString("noPhoto", comment: "No photo"))
                        .foregroundColor(.gray)
                        .padding(25)
                        
                @unknown default:
                    Text(NSLocalizedString("unknownError", comment: "Unknown error"))
                        .foregroundColor(.gray)
                        .padding(25)
                }
            }
            .alert(isPresented: $showToast) {
                Alert(
                    title: Text(NSLocalizedString("errorTitle", comment: "Error")),
                    message: Text(errorMessage ?? NSLocalizedString("unknownError", comment: "Unknown error")),
                    dismissButton: .default(Text(NSLocalizedString("okButton", comment: "OK"))) {
                        showToast = false
                    }
                )
            }
            .onAppear {
                isLoadingImage = true
                PokemonSelectedApi().getSprite(url: imageLink) { result in
                    isLoadingImage = false
                    switch result {
                    case .success(let sprite):
                        self.pokemonSprite = sprite.other.officialArtwork.front_default
                    case .failure(let error):
                        showToast = true
                        errorMessage = error.localizedDescription
                    }
                }
            }


            .clipShape(Circle())
            .foregroundColor(Color.gray.opacity(0.60))
            .scaledToFit()
        }
        .overlay(
            Group {
                if let errorMessage = errorMessage {
                    VStack {
                        Text(errorMessage)
                            .foregroundColor(.white)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.red))
                            .onTapGesture {
                                // Optional: Handle tap to dismiss
                                withAnimation {
                                    self.errorMessage = nil
                                }
                            }
                    }
                    .padding(.bottom, 100) // Adjust the position of the toast view
                    .transition(.move(edge: .bottom)) // Optional: Add an animation for appearance
                }
            }
        )
    }
}
