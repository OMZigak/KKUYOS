//
//  MyPageEtcSettingSwiftUIView.swift
//  KkuMulKum
//
//  Created by SwiftUI Migration on 2025/01/08.
//

import SwiftUI
import RxSwift

struct MyPageEtcSettingSwiftUIView: View {
    let viewModel: MyPageViewModel
    @State private var showLogoutAlert = false
    @State private var showUnsubscribeAlert = false
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 12) {
                // 버전정보
                SettingRow(
                    title: "버전정보",
                    subtitle: "1.0.2",
                    action: {
                        print("버전정보 탭됨")
                    }
                )
                .frame(height: (geometry.size.height - 44 - 48) / 5) // padding 44, spacing 48
                
                // 이용약관
                SettingRow(
                    title: "이용약관",
                    action: {
                        NotificationCenter.default.post(
                            name: Notification.Name("ShowTerms"),
                            object: nil
                        )
                    }
                )
                .frame(height: (geometry.size.height - 44 - 48) / 5)
                
                // 문의하기
                SettingRow(
                    title: "문의하기",
                    action: {
                        NotificationCenter.default.post(
                            name: Notification.Name("ShowAsk"),
                            object: nil
                        )
                    }
                )
                .frame(height: (geometry.size.height - 44 - 48) / 5)
                
                // 로그아웃
                SettingRow(
                    title: "로그아웃",
                    action: {
                        viewModel.logoutButtonTapped.accept(())
                    }
                )
                .frame(height: (geometry.size.height - 44 - 48) / 5)
                
                // 탈퇴하기
                SettingRow(
                    title: "탈퇴하기",
                    action: {
                        viewModel.unsubscribeButtonTapped.accept(())
                    }
                )
                .frame(height: (geometry.size.height - 44 - 48) / 5)
            }
            .padding(22)
            .background(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color(UIColor.gray2), lineWidth: 1)
            )
            .cornerRadius(8)
        }
    }
}

struct SettingRow: View {
    let title: String
    var subtitle: String? = nil
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(alignment: .center) {
                Text(title)
                    .font(.pretendard(.body03))
                    .foregroundColor(Color(UIColor.gray7))
                
                Spacer()
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.pretendard(.body03))
                        .foregroundColor(Color(UIColor.gray8))
                }
            }
            .frame(maxHeight: .infinity)
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }
}
