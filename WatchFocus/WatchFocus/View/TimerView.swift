//
//  TimerView.swift
//  WatchFocus
//
//  Created by 방유빈 on 2024/02/13.
//

import SwiftUI

struct TimerView: View {
    var body: some View {
        Form {
            Section("오늘의 공부 시간") {
                Text("00:00:00")
                    .font(.wfLargeTitleFont)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .listRowSeparator(.hidden)
                    .listRowBackground(
                        RoundedRectangle(cornerRadius: 15)
                            .background(.clear)
                            .foregroundColor(.white)
                            .padding(
                                EdgeInsets(
                                    top: 10,
                                    leading: 10,
                                    bottom: 10,
                                    trailing: 10
                                )
                            )
                            .shadow(color: Color(hex: "F0F3FF"), radius: 5, x: 5, y: 4)
                    )
            }
            Section {
                VStack {
                    Text("Pomodoro 60/10")
                        .font(.wfTitleFont)
                        .foregroundStyle(Color.wfGray)
                    TimerProgressView()
                        .padding()
                        .padding(.bottom)
                    Button {
                        
                    } label: {
                        Text("START")
                            .frame(width: 150, height: 50)
                            .font(.wfTitleFont)
                            .foregroundStyle(Color.white)
                            .background(Color.wfAlphaPurple)
                            .clipShape(RoundedRectangle(cornerRadius: 40))
                    }
                    .buttonStyle(.plain)
                }
            }
            .listRowBackground(Color.wfBackgroundGray)
            .listRowSeparator(.hidden)
        }
        .scrollContentBackground(.hidden)
        .background(Color.wfBackgroundGray, ignoresSafeAreaEdges: .all)
        .navigationTitle("Timer")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button{
                    
                }label: {
                    Image(systemName: "gearshape.fill")
                        .foregroundStyle(Color.wfGray)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        TimerView()
    }
}

struct TimerProgressView: View {
    var progress: Double = 0.5
    var progressColor: Color = .wfMainPurple
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.wfLightGray, lineWidth: 20)
            VStack {
                Text("Session 1")
                    .font(.wfBody1Font)
                    .foregroundStyle(progressColor)
                Text("00:00:00")
                    .font(.wfLargeTitleFont)
            }
            Circle()
                .trim(from: 0.0, to: CGFloat(min(self.progress, 1.0)))
                .stroke(progressColor, style: StrokeStyle(lineWidth: 20, lineCap: .round))
                .rotationEffect(Angle(degrees: -90))
        }
    }
}
