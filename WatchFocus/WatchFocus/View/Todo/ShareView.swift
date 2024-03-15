//
//  ShareView.swift
//  WatchFocus
//
//  Created by 방유빈 on 2024/03/13.
//

import SwiftUI
import DYColor
import Photos
import UIKit

struct ShareView: View {
    @Environment(\.colorScheme) var scheme
    @EnvironmentObject var todoStore: TodoStore
    @State private var selectedMode: String = "Light"
    @State private var isShowingAlert: Bool = false
    @State private var toast: Toast? = nil
    @State private var image: UIImage? = nil
    private var modes = ["Light", "Dark"]

    var shareView: some View {
        PhotoShareView(mode: selectedMode == "Light" ? .light : .dark)
    }
    
    var body: some View {
        ZStack{
            DYColor.wfbackgroundColor.dynamicColor
            VStack {
                Picker("", selection: $selectedMode, content: {
                    ForEach(modes, id: \.self) {
                        Text($0)
                    }
                })
                .pickerStyle(SegmentedPickerStyle())
                .frame(width: 200)
                .padding()
                
                shareView
                    .padding(.bottom, 30)

                Button {
                    saveToGallery()
                } label: {
                    Text("갤러리에 저장")
                }
                
            }
        }
        .toastView(toast: $toast)
        .ignoresSafeArea()
        .navigationTitle("Share")
        .onAppear {
            selectedMode = scheme == .light ? "Light" : "Dark"
        }
    }
    

    func saveToGallery() {
        let image = shareView.environmentObject(todoStore).snapshot()
        PHPhotoLibrary.requestAuthorization(for: .addOnly) { status in
            DispatchQueue.main.async {
                guard status == .authorized, let image = image else { return }
                PHPhotoLibrary.shared().performChanges({
                    PHAssetChangeRequest.creationRequestForAsset(from: image)
                }) { _, error in
                    if let error = error {
                        print("Error: 이미지 저장 실패\n\(error)")
                        toast = Toast(style: .error, message: "이미지 저장에 실패하였습니다.")
                        return
                    }
                    toast = Toast(style: .success, message: "이미지 저장 성공! 갤러리를 확인해주세요.")
                }
            }
        }
    }

}

#Preview {
    NavigationStack {
        ShareView()
            .environmentObject(TodoStore())
    }
}


struct PhotoShareView: View {
    enum Mode {
        case light
        case dark
        
        var returnScheme: ColorScheme {
            switch self {
            case .light:
                return .light
            case .dark:
                return .dark
            }
        }
    }
    
    @EnvironmentObject var todoStore: TodoStore
    
    var mode: Mode
    var body: some View {
        VStack {
            Text(Date().toString())
                .font(.wfTitleFont)
                .foregroundStyle(DYColor.wfBlackWhite.setScheme(mode.returnScheme))
                .padding()
            ForEach(todoStore.categorys) { category in
                Spacer()
                HStack(alignment: .center) {
                    CategoryProgressBar(progress: todoStore.getCategoryProgress(category.id), title: category.name, color: category.color.getDYColor.setScheme(mode.returnScheme))
                            .padding(.horizontal, 10)
                    Text("\(todoStore.getCategoryProgress(category.id).toPercent())%")
                        .font(.wfBody1Font)
                        .foregroundStyle(DYColor.wfBlackWhite.setScheme(mode.returnScheme))
                        .frame(width: 50)
                }
                Spacer()
            }
        }
        .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.width * 0.9)
        .background(
            Rectangle()
                .fill(DYColor.wfRowBackgroundColor.setScheme(mode.returnScheme))
        )
    }
}

struct CategoryProgressBar: View {
    var progress: Double
    var title: String
    var color: Color
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 20)
                    .frame(width: geometry.size.width, height: 30)
                    .foregroundStyle(color.opacity(0.15))
                RoundedRectangle(cornerRadius: 20)
                    .frame(width: min(CGFloat(self.progress) * geometry.size.width, geometry.size.width), height: 30)
                    .foregroundStyle(color)
                Text(title)
                    .font(.wfBody1Font)
                    .padding(.leading)
                    .foregroundStyle(Color.white)
                    .lineLimit(1)
            }
        }
        .frame(height: 30)
    }
}
