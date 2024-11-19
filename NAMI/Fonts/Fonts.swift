//
//  Fonts.swift
//  NAMI
//
//  Created by Riley Koo on 11/18/24.
//
import SwiftUI

enum FontWeight {
    case light
    case medium
    case bold
    case black
    case italic
    case regular
}

extension Font {
    static let proximaNova: (FontWeight, CGFloat) -> Font = { fontType, size in
        switch fontType {
        case .light:
            Font.custom("proximanova_light", size: size)
        case .bold:
            Font.custom("proximanova_bold", size: size)
        case .black:
            Font.custom("proximanova_black", size: size)
        default:
            Font.custom("proximanova_regular", size: size)
        }
    }
    static let franklinGothic: (FontWeight, CGFloat) -> Font = { fontType, size in
        switch fontType {
        case .italic:
            Font.custom("FranklinGothicITALIC", size: size)
        case .medium:
            Font.custom("Franklin Gothic Condensed", size: size)
        default:
            Font.custom("FranklinGothic", size: size)
        }
    }

}

extension Text {
    func proximaNova(_ fontWeight: FontWeight? = .regular, _ size: CGFloat? = nil) -> Text {
        return self.font(.proximaNova(fontWeight ?? .regular, size ?? 16))
    }
    func franklinGothic(_ fontWeight: FontWeight? = .regular, _ size: CGFloat? = nil) -> Text {
        return self.font(.franklinGothic(fontWeight ?? .regular, size ?? 16))
    }
}
