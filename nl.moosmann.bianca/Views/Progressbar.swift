import Foundation
import SwiftUI


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
