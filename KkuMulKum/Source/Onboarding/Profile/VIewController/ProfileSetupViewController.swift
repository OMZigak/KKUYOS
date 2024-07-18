//
//  ProfileViewController.swift
//  KkuMulKum
//
//  Created by 이지훈 on 7/10/24.
//

import UIKit

import RxSwift
import RxCocoa

class ProfileSetupViewController: BaseViewController {
    private let rootView = ProfileSetupView()
    private let viewModel: ProfileSetupViewModel
    private let disposeBag = DisposeBag()

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
    }
    
    private func setupBindings() {
        viewModel.profileImage
            .bind(to: rootView.profileImageView.rx.image)
            .disposed(by: disposeBag)
        
        viewModel.isConfirmButtonEnabled
            .bind(to: rootView.confirmButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        viewModel.isConfirmButtonEnabled
            .map { $0 ? 1.0 : 0.5 }
            .bind(to: rootView.confirmButton.rx.alpha)
            .disposed(by: disposeBag)
        
        rootView.confirmButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.uploadProfileImage()
            })
            .disposed(by: disposeBag)
        
        rootView.skipButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.navigateToWelcome()
            })
            .disposed(by: disposeBag)
        
        rootView.cameraButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.showImagePicker()
            })
            .disposed(by: disposeBag)
        
        viewModel.uploadSuccess
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.navigateToWelcome()
            })
            .disposed(by: disposeBag)
    }
    
    private func showImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true)
    }
    
    private func navigateToWelcome() {
        let welcomeVM = WelcomeViewModel(nickname: viewModel.nickname)
        let welcomeVC = WelcomeViewController(viewModel: welcomeVM)
        welcomeVC.modalPresentationStyle = .fullScreen
        present(welcomeVC, animated: true, completion: nil)
    }
}
   
extension ProfileSetupViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage {
            let croppedImage = cropToCircle(image: editedImage)
            viewModel.updateProfileImage(croppedImage)
        }
        dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
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
    
