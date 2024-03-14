//
//  WfColor.swift
//  WatchFocus
//
//  Created by 방유빈 on 2024/03/08.
//

import SwiftUI
import DYColor


extension DYColor {
    static let wfBlackWhite = DYColor(lightColor: .black, darkColor: .white)
    static let wfbackgroundColor = DYColor(lightColor: .wfBackgroundGray, darkColor: Color(hex: "#00000A"))
    static let wfRowBackgroundColor = DYColor(lightColor: .white, darkColor: Color(hex: "#333333"))
    static let wfMainPurple = DYColor(lightColor: .wfMainPurple)
    static let wfAlphaPurple = DYColor(lightColor: .wfAlphaPurple)
    static let wfMainBlue = DYColor(lightColor: .wfMainBlue)
    static let wfAlphaBlue = DYColor(lightColor: .wfAlphaBlue)
    static let wfCategoryGreen = DYColor(lightColor: .wfCategoryGreen)
    static let wfCategoryYellow = DYColor(lightColor: .wfCategoryYellow)
    static let wfCategoryRed = DYColor(lightColor: .wfCategoryRed)
    static let wfUnableCategory = DYColor(lightColor: .wfGray1, darkColor: .wfGray5)
    static let wfSubTitleText = DYColor(lightColor: .wfGray, darkColor: .wfLightGray)
    static let wfTextDarkGray = DYColor(lightColor: .wfGray5, darkColor: .wfGray1)
}

extension DYColor {
    func setScheme(_ scheme: ColorScheme) -> Color {
        switch scheme {
        case .light:
            return self.getLightColor()
        case .dark:
            return self.getDarkColor()
        @unknown default:
            return self.getLightColor()
        }
    }
}
