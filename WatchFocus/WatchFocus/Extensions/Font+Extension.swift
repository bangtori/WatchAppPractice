//
//  Font+Extension.swift
//  WatchFocus
//
//  Created by 방유빈 on 2024/02/13.
//

import SwiftUI

@available(iOS 13.0, *)
public extension Font {
    /// size 40, bold
    static var wfLargeTitleFont: Font {
        return Font.custom("AppleSDGothicNeo-Regular", size: 40)
            .bold()
    }
    
    /// size 20, bold
    static var wfTitleFont: Font {
        return Font.custom("AppleSDGothicNeo-Regular", size: 20)
            .bold()
    }
    
    /// size 17, bold
    static var wfBody1Font: Font {
        return Font.custom("AppleSDGothicNeo-Regular", size: 17)
            .bold()
    }
    
    // size 14, semibold
    static var wfBody2Font: Font {
        return Font.custom("AppleSDGothicNeo-Bold", size: 14)
            .weight(.semibold)
    }

    
    /// size 12, semibold
    static var wfCalloutFont: Font {
        return Font.custom("AppleSDGothicNeo-Bold", size: 12)
            .weight(.semibold)
    }

}
