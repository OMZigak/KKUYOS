//
//  ProfileViewController.swift
//  KkuMulKum
//
//  Created by 이지훈 on 7/10/24.
//

import UIKit
import PhotosUI

class ProfileSetupViewController: BaseViewController {
    private let rootView = ProfileSetupView()
    private let viewModel: ProfileSetupViewModel
    private let imagePicker = UIImagePickerController()

    init(viewModel: ProfileSetupViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBarTitle(with: "프로필 설정")
        setupNavigationBarBackButton()
        setupBindings()
        setupImagePicker()
    }
    
    private func setupImagePicker() {
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
    }
    
    override func setupAction() {
        rootView.confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        rootView.skipButton.addTarget(self, action: #selector(skipButtonTapped), for: .touchUpInside)
        rootView.cameraButton.addTarget(self, action: #selector(cameraButtonTapped), for: .touchUpInside)
    }
    
    private func setupBindings() {
        viewModel.profileImage.bind { [weak self] image in
            self?.rootView.profileImageView.image = image
        }
        
        viewModel.isConfirmButtonEnabled.bind { [weak self] isEnabled in
            self?.rootView.confirmButton.isEnabled = isEnabled
            self?.rootView.confirmButton.alpha = isEnabled ? 1.0 : 0.5
        }
    }
    
    @objc private func confirmButtonTapped() {
        if viewModel.isConfirmButtonEnabled.value {
            viewModel.uploadProfileImage()
            navigateToWelcomeScreen()
        }
    }
    
    @objc private func skipButtonTapped() {
        navigateToWelcomeScreen()
    }
    
    private func navigateToWelcomeScreen() {
        let welcomeVC = WelcomeViewController(
            viewModel: WelcomeViewModel(nickname: viewModel.nickname)
        )
        welcomeVC.modalPresentationStyle = .fullScreen
        present(welcomeVC, animated: true, completion: nil)
    }
    
    @objc private func cameraButtonTapped() {
        checkPhotoLibraryPermission()
    }
    
    private func checkPhotoLibraryPermission() {
        PHPhotoLibrary.requestAuthorization { [weak self] status in
            DispatchQueue.main.async {
                switch status {
                case .authorized, .limited:
                    self?.presentImagePicker()
                case .denied, .restricted:
                    self?.showPermissionDeniedAlert()
                case .notDetermined:
                    break
                @unknown default:
                    break
                }
            }
        }
    }
    
    private func presentImagePicker() {
        present(imagePicker, animated: true)
    }
    
    private func showPermissionDeniedAlert() {
        let alert = UIAlertController(
            title: "권한 거부됨",
            message: "사진 라이브러리 접근 권한이 거부되었습니다. 설정에서 권한을 변경해주세요.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "설정", style: .default) { _ in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsURL)
            }
        })
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        present(alert, animated: true)
    }
    
    private func cropToCircle(image: UIImage) -> UIImage {
        let shorterSide = min(image.size.width, image.size.height)
        let imageBounds = CGRect(x: 0, y: 0, width: shorterSide, height: shorterSide)
        UIGraphicsBeginImageContextWithOptions(imageBounds.size, false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()!
        context.addEllipse(in: imageBounds)
        context.clip()
        image.draw(in: imageBounds)
        let circleImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return circleImage
    }
}

extension ProfileSetupViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        if let editedImage = info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage {
            let croppedImage = cropToCircle(image: editedImage)
            viewModel.updateProfileImage(croppedImage)
        }
        dismiss(animated: true)
    }
}

