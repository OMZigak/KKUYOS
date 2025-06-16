//
//  MyPageEditViewController.swift
//  KkuMulKum
//
//  Created by 이지훈 on 8/21/24.
//

import UIKit

import RxSwift
import RxCocoa
import Kingfisher

class MyPageEditViewController: BaseViewController {
    private let rootView = MyPageEditView()
    private let viewModel: MyPageEditViewModel
    private let disposeBag = DisposeBag()
    private var selectedImage: UIImage?
    let profileImageUpdated = PublishSubject<String?>()
    
    init(viewModel: MyPageEditViewModel) {
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
        viewModel.fetchUserInfo()
    }
    
    override func setupView() {
        super.setupView()
        setupBindings()
    }
    
    override func setupAction() {
        super.setupAction()
        
        rootView.cameraButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.showImagePicker()
            })
            .disposed(by: disposeBag)
        
        rootView.confirmButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.handleConfirmButtonTap()
            })
            .disposed(by: disposeBag)
        
        rootView.skipButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.handleSkipButtonTap()
            })
            .disposed(by: disposeBag)
    }
    
    private func setupBindings() {
        let input = MyPageEditViewModel.Input(
            confirmButtonTap: rootView.confirmButton.rx.tap.asObservable(),
            skipButtonTap: rootView.skipButton.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(input: input, disposeBag: disposeBag)
        
        output.isConfirmButtonEnabled
            .drive(rootView.confirmButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.userInfo
            .drive(onNext: { [weak self] userInfo in
                self?.updateProfileImage(with: userInfo?.profileImageURL)
            })
            .disposed(by: disposeBag)
    }
    
    private func updateProfileImage(with urlString: String?) {
        guard let urlString = urlString, let url = URL(string: urlString) else {
            rootView.profileImageView.image = UIImage.imgProfile
            return
        }
        
        rootView.profileImageView.kf.setImage(
            with: url,
            placeholder: UIImage.imgProfile,
            options: [
                .transition(.fade(0.2)),
                .cacheOriginalImage
            ],
            completionHandler: { result in
                switch result {
                case .success(_):
                    print("Profile image loaded successfully")
                case .failure(let error):
                    print("Failed to load profile image: \(error.localizedDescription)")
                    self.rootView.profileImageView.image = UIImage.imgProfile
                }
            }
        )
    }
    
    private func showImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true)
    }
    
    private func handleConfirmButtonTap() {
        if let selectedImage = selectedImage {
            viewModel.updateProfileImage(selectedImage)
        }
        navigationController?.popViewController(animated: true)
    }
    
    private func handleSkipButtonTap() {
        viewModel.setDefaultProfileImage()
        navigationController?.popViewController(animated: true)
    }
}

extension MyPageEditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        if let editedImage = info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage {
            let croppedImage = cropToCircle(image: editedImage)
            selectedImage = croppedImage
            rootView.profileImageView.image = croppedImage
            rootView.confirmButton.isEnabled = true
        }
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
