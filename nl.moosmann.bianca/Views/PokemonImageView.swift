import Foundation
import SwiftUI


struct PokemonImageView: View {
    var imageLink: String

    var body: some View {
        AsyncImage(url: URL(string: imageLink)) { phase in
            switch phase {
            case .empty:
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .purple))
                    .scaleEffect(1.5)
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            case .failure(let error):
                //Error handling
                Text("Error: \(error.localizedDescription)")
            @unknown default:
                Text(NSLocalizedString("unknownError", comment: "Unknown error"))
            }
        }
    }
}
