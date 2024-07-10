//
//  ProfileViewController.swift
//  KkuMulKum
//
//  Created by 이지훈 on 7/10/24.
//

import UIKit

class ProfileSetupViewController: BaseViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private let rootView = ProfileSetupView()
    private let viewModel = ProfileSetupViewModel()
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        setupAction()
    }
    
    private func setupBindings() {
        viewModel.profileImage.bind(with: self) { (vc, image) in
            vc.rootView.profileImageView.image = image
        }
        
        viewModel.isConfirmButtonEnabled.bind(with: self) { (vc, isEnabled) in
            vc.rootView.confirmButton.isEnabled = isEnabled
            vc.rootView.confirmButton.alpha = isEnabled ? 1.0 : 0.5
        }
    }
    
    override func setupAction() {
        rootView.confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        rootView.skipButton.addTarget(self, action: #selector(skipButtonTapped), for: .touchUpInside)
        rootView.cameraButton.addTarget(self, action: #selector(cameraButtonTapped), for: .touchUpInside)
    }
    
    @objc private func confirmButtonTapped() {
        // TODO: 확인 버튼 탭 시 동작 구현
        print("프로필 이미지 설정 완료")
    }
    
    @objc private func skipButtonTapped() {
        // TODO: 건너뛰기 버튼 탭 시 동작 구현
        print("프로필 이미지 설정 건너뛰기")
    }
    
    @objc private func cameraButtonTapped() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true)
    }
    
    // MARK: - UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.editedImage] as? UIImage {
            viewModel.updateProfileImage(editedImage)
        } else if let originalImage = info[.originalImage] as? UIImage {
            viewModel.updateProfileImage(originalImage)
        }
        dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
}
