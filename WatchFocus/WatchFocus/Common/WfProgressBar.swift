//
//  wfProgressBar.swift
//  WatchFocus
//
//  Created by 방유빈 on 2024/02/13.
//

import SwiftUI

struct WfProgressBar: View {
    var progress: Double
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading) {
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: geometry.size.width, height: 10)
                        .foregroundStyle(Color.wfLightGray)
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: min(CGFloat(self.progress) * geometry.size.width, geometry.size.width), height: 10)
                        .foregroundStyle(Color.wfMainBlue)
                }
                Text("\(progress.toPercent())%")
                    .font(.wfCalloutFont)
                    .foregroundStyle(Color.wfLightGray)
                    .offset(x: progress == 0 ? 0 : min(CGFloat(self.progress) * geometry.size.width, geometry.size.width) - 15, y: 0)
            }
        }
    }
}

#Preview {
    WfProgressBar(progress: 0.5)
}
