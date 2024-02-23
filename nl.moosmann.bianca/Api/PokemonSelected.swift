import Foundation

class PokemonSelectedApi {
    let errorDomain = "nl.biancamoosmann.nl-moosmann-bianca.errorDomain"

    func getOfficialArtwork(url: String, completion: @escaping (Result<OfficialArtwork, NSError>) -> ()) {
        guard let url = URL(string: url) else {
            let errorMessage = NSLocalizedString("InvalidURLError", comment: "Invalid URL")
            completion(.failure(NSError(domain: errorDomain, code: 0, userInfo: [NSLocalizedDescriptionKey: errorMessage])))
            return
        }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                let errorMessage = NSLocalizedString("NetworkError", comment: "Network error")
                completion(.failure(NSError(domain: self.errorDomain, code: 1, userInfo: [NSLocalizedDescriptionKey: String(format: errorMessage, error.localizedDescription)])))
                return
            }

            guard let data = data else {
                let errorMessage = NSLocalizedString("NoDataError", comment: "No data received")
                completion(.failure(NSError(domain: self.errorDomain, code: 2, userInfo: [NSLocalizedDescriptionKey: errorMessage])))
                return
            }

            do {
                let officialArtwork = try JSONDecoder().decode(OfficialArtwork.self, from: data)
                completion(.success(officialArtwork))
            } catch {
                let errorMessage = NSLocalizedString("DecodingError", comment: "Error decoding data")
                completion(.failure(NSError(domain: self.errorDomain, code: 3, userInfo: [NSLocalizedDescriptionKey: String(format: errorMessage, error.localizedDescription)])))
            }
        }.resume()
    }

    func getSprite(url: String, completion: @escaping (Result<PokemonSprites, NSError>) -> ()) {
            guard let url = URL(string: url) else {
                let errorMessage = NSLocalizedString("InvalidURLError", comment: "Invalid URL")
                completion(.failure(NSError(domain: errorDomain, code: 4, userInfo: [NSLocalizedDescriptionKey: errorMessage])))
                return
            }

            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    let errorMessage = NSLocalizedString("NetworkError", comment: "Network error")
                    completion(.failure(NSError(domain: self.errorDomain, code: 5, userInfo: [NSLocalizedDescriptionKey: String(format: errorMessage, error.localizedDescription)])))
                    return
                }

                guard let data = data else {
                    let errorMessage = NSLocalizedString("NoDataError", comment: "No data received")
                    completion(.failure(NSError(domain: self.errorDomain, code: 6, userInfo: [NSLocalizedDescriptionKey: errorMessage])))
                    return
                }

                do {
                    let pokemonSprite = try JSONDecoder().decode(PokemonSelected.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(pokemonSprite.sprites))
                    }
                } catch {
                    let errorMessage = NSLocalizedString("DecodingError", comment: "Error decoding data")
                    completion(.failure(NSError(domain: self.errorDomain, code: 7, userInfo: [NSLocalizedDescriptionKey: String(format: errorMessage, error.localizedDescription)])))
                }
            }.resume()
        }
}

