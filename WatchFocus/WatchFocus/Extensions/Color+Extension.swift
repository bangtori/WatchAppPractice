//
//  Color+Extension.swift
//  WatchFocus
//
//  Created by 방유빈 on 2024/02/13.
//

import SwiftUI
import UIKit

@available(iOS 13.0, *)
extension Color {
    /// #FFFFFF와 같이 16진수 hexString color를 쓸 수 있음.
    init(hex: String, opacity: Double = 1.0) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let red = Double((rgb & 0xFF0000) >> 16) / 255.0
        let green = Double((rgb & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgb & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue, opacity: opacity)
    }
    
    func downSaturation(percent value: Double = 0.3) -> Color{
        let uiColor = UIColor(self)
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        
        uiColor.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        let newSaturation = max(saturation - value, 0)
        
        return Color(hue: hue, saturation: newSaturation, brightness: brightness)
    }

    
    static let wfMainPurple = Color(hex: "#E901FD")
    static let wfAlphaPurple = Color(hex: "#E901FD", opacity: 0.5)
    static let wfMainBlue = Color(hex: "#007AFF")
    static let wfAlphaBlue = Color(hex: "#007AFF", opacity: 0.5)
    static let wfBackgroundGray = Color(hex: "#FAFBFF")
    static let wfLightGray = Color(hex: "#D9D9D9")
    static let wfGray = Color(hex: "#ADADAD")
    static let wfBlueGray = Color(hex: "#AAB6D4")
}
