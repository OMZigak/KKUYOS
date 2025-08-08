//
//  MyPageSwiftUIView.swift
//  KkuMulKum
//
//  Created by SwiftUI Migration on 2025/01/08.
//

import SwiftUI
import RxSwift

struct MyPageSwiftUIView: View {
    @StateObject private var viewModelWrapper: MyPageViewModelWrapper
    
    init(viewModel: MyPageViewModel) {
        _viewModelWrapper = StateObject(wrappedValue: MyPageViewModelWrapper(viewModel: viewModel))
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color(UIColor.green1)
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    MyPageContentSwiftUIView(viewModel: viewModelWrapper.viewModel)
                        .frame(height: 24 + Screen.height(120) + 12 + Screen.height(36) + 35 + Screen.height(6) + 25)
                    
                    let contentHeight = 24 + Screen.height(120) + 12 + Screen.height(36) + 35 + Screen.height(6) + 25
                    let etcHeight = geometry.size.height - contentHeight - 12 - 127
                    
                    MyPageEtcSettingSwiftUIView(viewModel: viewModelWrapper.viewModel)
                        .frame(height: max(0, etcHeight))
                        .padding(.horizontal, 20)
                        .padding(.top, 12)
                    
                    Spacer(minLength: 127)
                }
            }
        }
    }
}
