import Foundation
import SwiftUI

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
