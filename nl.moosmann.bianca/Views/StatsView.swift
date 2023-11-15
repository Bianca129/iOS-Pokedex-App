//
//  StatsView.swift
//  nl.moosmann.bianca
//
//  Created by admin on 10/21/23.
//

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

struct ProgressBar: View {
    var value: Int // value for the metrics for the pokemon

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(width: geometry.size.width, height: 8)
                    .opacity(0.3)
                    .foregroundColor(Color.gray)
                    .cornerRadius(30)

                Rectangle()
                    .frame(width: CGFloat(value) / 160 * geometry.size.width, height: 8)
                    .foregroundColor(Color.purple)
                    .cornerRadius(30)
            }
        }
    }
}
