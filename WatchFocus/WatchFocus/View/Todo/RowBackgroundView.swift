//
//  RowBackgroundView.swift
//  WatchFocus
//
//  Created by 방유빈 on 2024/03/12.
//

import SwiftUI
import DYColor

struct RowBackgroundView: View {
    @Environment(\.colorScheme) var scheme
    
    var body: some View {
        RoundedRectangle(cornerRadius: 15)
            .stroke(Color.wfGray4,style: StrokeStyle(lineWidth: scheme == .light ? 0 : 2))
            .fill(DYColor.wfRowBackgroundColor.dynamicColor)
            .background(.clear)
            .padding(2)
            .shadow(color: scheme == .light ? Color(hex: "F0F3FF") : Color(hex: "F0F3FF", opacity: 0), radius: 5, x: 5, y: 4)
    }
}

#Preview {
    RowBackgroundView()
}
