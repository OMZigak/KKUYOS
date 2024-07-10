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

    }
    
    override func setupAction() {
        rootView.confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        rootView.skipButton.addTarget(self, action: #selector(skipButtonTapped), for: .touchUpInside)
        rootView.cameraButton.addTarget(self, action: #selector(cameraButtonTapped), for: .touchUpInside)
    }
    
    override func setupDelegate() {

    }
    
    @objc private func confirmButtonTapped() {

    }
    
    @objc private func skipButtonTapped() {

    }
    
    @objc private func cameraButtonTapped() {

    }
    
}
