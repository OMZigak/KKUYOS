//
//  MyPageContentSwiftUIView.swift
//  KkuMulKum
//
//  Created by SwiftUI Migration on 2025/01/08.
//

import SwiftUI
import Combine
import RxSwift

struct MyPageContentSwiftUIView: View {
    @StateObject private var viewModelWrapper: MyPageViewModelWrapper
    @State private var profileImage: UIImage? = UIImage.imgProfile
    
    init(viewModel: MyPageViewModel) {
        _viewModelWrapper = StateObject(wrappedValue: MyPageViewModelWrapper(viewModel: viewModel))
    }
    
    var body: some View {
        ZStack {
            Color(UIColor.green1)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Profile Stack - 높이 120으로 고정
                VStack(spacing: 12) {
                    // Profile Image with Edit Button
                    ZStack(alignment: .bottomTrailing) {
                        if let image = profileImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: Screen.height(82), height: Screen.height(82))
                                .clipShape(Circle())
                        } else {
                            Image(uiImage: UIImage.imgProfile)
                                .resizable()
                                .scaledToFill()
                                .frame(width: Screen.height(82), height: Screen.height(82))
                                .clipShape(Circle())
                        }
                        
                        Button(action: {
                            viewModelWrapper.viewModel.editButtonTapped.accept(())
                        }) {
                            Image(uiImage: UIImage.imgEdit)
                                .resizable()
                                .frame(width: Screen.width(24), height: Screen.width(24))
                                .background(Color.white)
                                .clipShape(Circle())
                        }
                    }
                    
                    // Name Label
                    Text(getUserName())
                        .font(.pretendard(.body01))
                        .foregroundColor(Color(UIColor.gray8))
                }
                .frame(height: Screen.height(120))
                .padding(.top, 24)
                
                // Level Badge - profileStackView 아래 12pt
                ZStack {
                    RoundedRectangle(cornerRadius: Screen.height(36) / 2)
                        .fill(Color(UIColor.maincolor))
                        .frame(height: Screen.height(36))
                    
                    HStack(spacing: 4) {
                        Text("Lv. \(viewModelWrapper.userInfo?.level ?? 1)")
                            .font(.pretendard(.body05))
                            .foregroundColor(Color(UIColor.lightGreen))
                        
                        Text(getLevelText())
                            .font(.pretendard(.body05))
                            .foregroundColor(.white)
                    }
                }
                .frame(height: Screen.height(36))
                .padding(.horizontal, 83)
                .padding(.top, 12)
                
                // Separator - levelView 아래 35pt
                Rectangle()
                    .fill(Color(UIColor.green2))
                    .frame(height: Screen.height(6))
                    .padding(.top, 35)
                
                Spacer(minLength: 25)
            }
        }
        .onAppear {
            if let urlString = viewModelWrapper.userInfo?.profileImageURL,
               let url = URL(string: urlString) {
                loadImage(from: url)
            }
        }
        .onChange(of: viewModelWrapper.userInfo) { newValue in
            if let urlString = newValue?.profileImageURL,
               let url = URL(string: urlString) {
                loadImage(from: url)
            }
        }
    }
    
    private func getUserName() -> String {
        if let name = viewModelWrapper.userInfo?.name {
            return "\(name) 님"
        }
        return "꾸물리안 님"
    }
    
    private func getLevelText() -> String {
        viewModelWrapper.viewModel.getLevelText(for: viewModelWrapper.userInfo?.level ?? 1)
    }
    
    private func loadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.profileImage = image
                }
            }
        }.resume()
    }
}

// Wrapper class to bridge RxSwift and SwiftUI
class MyPageViewModelWrapper: ObservableObject {
    @Published var userInfo: LoginUserModel?
    let viewModel: MyPageViewModel
    private let disposeBag = DisposeBag()
    
    init(viewModel: MyPageViewModel) {
        self.viewModel = viewModel
        
        // Subscribe to RxSwift BehaviorRelay and update @Published property
        viewModel.userInfo
            .subscribe(onNext: { [weak self] info in
                DispatchQueue.main.async {
                    self?.userInfo = info
                }
            })
            .disposed(by: disposeBag)
    }
}