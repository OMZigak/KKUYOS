//
//  MyPageEditViewController.swift
//  KkuMulKum
//
//  Created by 이지훈 on 8/21/24.
//

import UIKit

import RxSwift
import RxCocoa

class MyPageEditViewController: BaseViewController {
    private let rootView = MyPageEditView()
    private let viewModel: MyPageEditViewModel
    private let disposeBag = DisposeBag()
    private let newProfileImageSubject = PublishSubject<UIImage?>()
    
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
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func setupBindings() {
        let input = MyPageEditViewModel.Input(
            profileImageTap: rootView.cameraButton.rx.tap.asObservable(),
            confirmButtonTap: rootView.confirmButton.rx.tap.asObservable(),
            newProfileImage: newProfileImageSubject.asObservable()
        )
        
        let output = viewModel.transform(input: input, disposeBag: disposeBag)
        
        output.profileImage
            .drive(rootView.profileImageView.rx.image)
            .disposed(by: disposeBag)
        
        output.isConfirmButtonEnabled
            .drive(rootView.confirmButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.isConfirmButtonEnabled
            .map { $0 ? 1.0 : 0.5 }
            .drive(rootView.confirmButton.rx.alpha)
            .disposed(by: disposeBag)
    }
    
    private func showImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true)
    }
}

extension MyPageEditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        if let editedImage = info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage {
            let croppedImage = cropToCircle(image: editedImage)
            newProfileImageSubject.onNext(croppedImage)
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
