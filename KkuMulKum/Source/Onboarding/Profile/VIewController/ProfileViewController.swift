//
//  ProfileViewController.swift
//  KkuMulKum
//
//  Created by 이지훈 on 7/10/24.
//
import UIKit

class ProfileSetupViewController: BaseViewController {
    private let rootView = ProfileSetupView()
    
    override func loadView() {
        view = rootView
    }
    
    override func setupView() {
        // 추가적인 UI 설정이 필요하다면 여기에 구현
    }
    
    override func setupAction() {
        rootView.confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        rootView.skipButton.addTarget(self, action: #selector(skipButtonTapped), for: .touchUpInside)
        rootView.cameraButton.addTarget(self, action: #selector(cameraButtonTapped), for: .touchUpInside)
    }
    
    override func setupDelegate() {
        // Delegate 설정이 필요하다면 여기에 구현
    }
    
    @objc private func confirmButtonTapped() {
        // 확인 버튼 탭 시 동작 구현
    }
    
    @objc private func skipButtonTapped() {
        // 건너뛰기 버튼 탭 시 동작 구현
    }
    
    @objc private func cameraButtonTapped() {
        // 카메라 버튼 탭 시 동작 구현
    }
}
