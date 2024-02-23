import Foundation
import SwiftUI

struct StatsView: View {
    let detailPokemon: DetailPokemon

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                ForEach(detailPokemon.stats, id: \.self) { stat in
                    HStack {
                        Text(stat.stat.name.capitalized)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 16)

                        Text(String(stat.base_stat))
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .padding(.trailing, 16)
                    }

                    ProgressBar(value: stat.base_stat)
                        .padding(.horizontal, 16)
                        .padding(.bottom, 10)
                        .cornerRadius(30)
                }
            }
        }
        .padding(.top, 20)
    }

    func statValue(for name: String) -> Int {
        if let stat = detailPokemon.stats.first(where: { $0.stat.name == name }) {
            return stat.base_stat
        }
        return 0
    }
}
