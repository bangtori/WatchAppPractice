//
//  Color+Extension.swift
//  WatchFocus Watch App
//
//  Created by 방유빈 on 2024/03/11.
//

import SwiftUI

// MARK: - Color System
extension Color {

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
    
    static let wfMainPurple = Color(hex: "#E901FD")
    static let wfMainBlue = Color(hex: "#007AFF")
    static let wfCategoryGreen = Color(hex: "#00E55C")
    static let wfCategoryYellow = Color(hex: "#FFB800")
    static let wfCategoryRed = Color(hex: "#FF2752")
    static let wfAlphaPurple = Color(hex: "#E901FD", opacity: 0.5)
    static let wfAlphaBlue = Color(hex: "#007AFF", opacity: 0.5)
    static let wfBackgroundGray = Color(hex: "#FAFBFF")
    static let wfLightGray = Color(hex: "#D9D9D9")
    static let wfGray = Color(hex: "#ADADAD")
    static let wfBlueGray = Color(hex: "#AAB6D4")
    
    // MARK: - Gray Scale
    /// 밝기 90%
    static let wfGray1 = Color(hex: "#E6E6E6")
    /// 밝기 80%
    static let wfGray2 = Color(hex: "#cccccc")
    /// 밝기 60%
    static let wfGray3 = Color(hex: "#999999")
    /// 밝기 50%
    static let wfGray4 = Color(hex: "#808080")
    /// 밝기 30%
    static let wfGray5 = Color(hex: "#4D4D4D")
}
