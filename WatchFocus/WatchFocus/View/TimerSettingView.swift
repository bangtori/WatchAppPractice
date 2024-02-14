//
//  TimerSettingView.swift
//  WatchFocus
//
//  Created by 방유빈 on 2024/02/14.
//

import SwiftUI

struct TimerSettingView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var focusTimeValue = 50.0
    @State private var restTimeValue = 10.0
    @State private var iterationCount = 1
    @State private var isShowingAlert: Bool = false
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("집중 시간(분)")
                Spacer()
                Text("\(Int(focusTimeValue))")
            }
            .font(.wfTitleFont)
            HStack {
                Text("10")
                    .font(.wfCalloutFont)
                    .foregroundStyle(Color.wfLightGray)
                Slider(value: $focusTimeValue, in: 10...120, step: 5)
                    .tint(Color.wfMainPurple)
                Text("120")
                    .font(.wfCalloutFont)
                    .foregroundStyle(Color.wfLightGray)
            }
            .padding(.bottom, 30)
            
            HStack {
                Text("휴식 시간(분)")
                Spacer()
                Text("\(Int(restTimeValue))")
            }
            .font(.wfTitleFont)
            HStack {
                Text("0")
                    .font(.wfCalloutFont)
                    .foregroundStyle(Color.wfLightGray)
                Slider(value: $restTimeValue, in: 0...30, step: 5)
                    .tint(Color.wfMainBlue)
                Text("120")
                    .font(.wfCalloutFont)
                    .foregroundStyle(Color.wfLightGray)
            }
            .padding(.bottom, 30)
            HStack {
                VStack(alignment: .leading) {
                    Text("반복 횟수")
                        .font(.wfTitleFont)
                    Text("min: 1 / max: 10")
                        .font(.wfCalloutFont)
                        .foregroundStyle(Color.wfLightGray)
                }
                Spacer()
                Button {
                    if iterationCount > 0 {
                        iterationCount -= 1
                    }
                } label: {
                    Image(systemName: "minus")
                }
                .foregroundStyle(Color.wfGray)
                Text("\(iterationCount)")
                    .frame(width: 50)
                Button {
                    if iterationCount < 10 {
                        iterationCount += 1
                    }
                } label: {
                    Image(systemName: "plus")
                }
                .foregroundStyle(Color.wfGray)
            }
            .font(.wfBody1Font)
            Spacer()
            
            Button {
                isShowingAlert.toggle()
            } label: {
                Text("Save Task")
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .font(.wfBody1Font)
                    .foregroundStyle(Color.white)
                    .background(Color.wfMainBlue)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
            }
            .alert("타이머 설정", isPresented: $isShowingAlert) {
                Button("취소", role: .none) {}
                Button("저장", role: .none) {
                    dismiss()
                }
            }message: {
                Text("설정 값으로 타이머를 초기화합니다.")
            }
        }
        .padding()
        .navigationTitle("Timer Setting")
    }
}

#Preview {
    NavigationStack {
        TimerSettingView()
    }
}
