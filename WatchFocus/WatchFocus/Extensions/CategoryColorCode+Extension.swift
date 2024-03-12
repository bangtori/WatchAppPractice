//
//  CategoryColorCode+Extension.swift
//  WatchFocus
//
//  Created by 방유빈 on 2024/03/12.
//

import Foundation
import DYColor

extension CategoryColorCode {
    var getDYColor: DYColor {
        switch self {
        case .blue:
            return .wfMainBlue
        case .purple:
            return .wfMainPurple
        case .yellow:
            return .wfCategoryYellow
        case .green:
            return .wfCategoryGreen
        case .red:
            return .wfCategoryRed
        }
    }
}
