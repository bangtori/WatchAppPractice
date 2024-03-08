//
//  WfColor.swift
//  WatchFocus
//
//  Created by 방유빈 on 2024/03/08.
//

import SwiftUI

struct WfColor {
    let lightColor: Color
    let darkColor: Color
    
    init(lightColor: Color, darkColor: Color) {
        self.lightColor = lightColor
        self.darkColor = darkColor
    }
    
    func returnColor(scheme: ColorScheme) -> Color {
        switch scheme {
        case .light : return lightColor
        case .dark : return darkColor
        @unknown default: return lightColor
        }
    }
}

extension WfColor {
    static let wfbackgroundColor = WfColor(lightColor: .wfBackgroundGray, darkColor: Color(hex: "#00001A"))
    static let wfRowBackgroundColor = WfColor(lightColor: .white, darkColor: Color(hex: "#333333"))
    static let wfMainPurple = WfColor(lightColor: .wfMainPurple, darkColor: .wfMainPurple.downSaturation())
    static let wfAlphaPurple = WfColor(lightColor: .wfAlphaPurple, darkColor: .wfAlphaPurple.downSaturation())
    static let wfMainBlue = WfColor(lightColor: .wfMainBlue, darkColor: .wfMainBlue.downSaturation())
    static let wfAlphaBlue = WfColor(lightColor: .wfAlphaBlue, darkColor: .wfAlphaBlue.downSaturation())
    static let wfLightGray = WfColor(lightColor: .wfLightGray, darkColor: .wfGray)
    static let wfGray = WfColor(lightColor: .wfGray, darkColor: .wfLightGray)
    static let wfBlueGray = WfColor(lightColor: .wfBlueGray, darkColor: .wfBlueGray)
}

