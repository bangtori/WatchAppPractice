//
//  wfProgressBar.swift
//  WatchFocus
//
//  Created by 방유빈 on 2024/02/13.
//

import SwiftUI
import DYColor

struct WfProgressBar: View {
    @Environment(\.colorScheme) var scheme
    
    var progress: Double
    var progressColor: DYColor
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading) {
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: geometry.size.width, height: 10)
                        .foregroundStyle(Color.wfGray1)
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: min(CGFloat(self.progress) * geometry.size.width, geometry.size.width), height: 10)
                        .foregroundStyle(progressColor.dynamicColor)
                }
                Text("\(progress.toPercent())%")
                    .font(.wfCalloutFont)
                    .foregroundStyle(DYColor.wfSubTitleText.dynamicColor)
                    .offset(x: progress == 0 ? 0 : min(CGFloat(self.progress) * geometry.size.width, geometry.size.width) - 15, y: 0)
            }
        }
    }
}

#Preview {
    WfProgressBar(progress: 0.5, progressColor: DYColor.wfMainBlue)
}
