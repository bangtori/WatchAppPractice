//
//  WfToastMessageView.swift
//  WatchFocus
//
//  Created by 방유빈 on 2024/03/14.
//

import SwiftUI
import DYColor

enum ToastStyle {
    case error
    case success
    case info
}

extension ToastStyle {
    var themeColor: DYColor {
        switch self {
        case .error: return .wfCategoryRed
        case .info: return .wfMainBlue
        case .success: return .wfMainPurple
        }
    }
    
    var iconFileName: String {
        switch self {
        case .info: return "info.circle.fill"
        case .success: return "checkmark.circle.fill"
        case .error: return "xmark.circle.fill"
        }
    }
}
struct Toast: Equatable {
  var style: ToastStyle
  var message: String
  var duration: Double = 3
  var width: Double = .infinity
}

struct WFToastMessageView: View {
    @Environment(\.colorScheme) var scheme
    
    var style: ToastStyle
    var message: String
    var width = CGFloat.infinity
    
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            Image(systemName: style.iconFileName)
                .foregroundStyle(style.themeColor.dynamicColor)
            Text(message)
                .font(.wfCalloutFont)
                .foregroundStyle(DYColor.wfTextDarkGray.dynamicColor)
            
            Spacer()
            
        }
        .padding()
        .frame(minWidth: 0, maxWidth: width)
        .background(DYColor.wfRowBackgroundColor.dynamicColor)
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius:20)
                .stroke(style.themeColor.dynamicColor, style: StrokeStyle(lineWidth: 1))
                .opacity(0.6)
        )
        .padding(.horizontal, 16)
    }
}
