import Foundation
import SwiftUI


struct TabBar: View {
    let tabs: [PokemonDetail.Tab]
    @Binding var selectedTab: PokemonDetail.Tab

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
