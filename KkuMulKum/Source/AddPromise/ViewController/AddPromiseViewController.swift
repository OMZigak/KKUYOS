//
//  AddPromiseViewController.swift
//  KkuMulKum
//
//  Created by 김진웅 on 7/14/24.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

final class AddPromiseViewController: BaseViewController {
    private let progressView = UIProgressView(progressViewStyle: .default).then {
        $0.progressTintColor = .maincolor
        $0.backgroundColor = .gray2
        $0.setProgress(0.33, animated: false)
    }
    
    private let viewModel: AddPromiseViewModel
    private let disposeBag = DisposeBag()
    private let rootView = AddPromiseView()
    private let promiseNameTextFieldEndEditingRelay = PublishRelay<Void>()
    private let promisePlaceTextFieldDidTapRelay = PublishRelay<Void>()
    
    // MARK: - Intializer
    
    init(viewModel: AddPromiseViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Life Cycle
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBarTitle(with: "약속 추가하기")
        setupNavigationBarBackButton()
        
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        progressView.removeFromSuperview()
    }
    
    override func setupView() {
        navigationController?.navigationBar.addSubviews(progressView)
        
        progressView.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalToSuperview()
            $0.height.equalTo(Screen.height(3))
        }
    }
    
    override func setupAction() {
        let viewTapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard)
        )
        view.addGestureRecognizer(viewTapGesture)
        
        let textFieldTapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(promisePlaceTextFieldDidTap)
        )
        rootView.promisePlaceTextField.addGestureRecognizer(textFieldTapGesture)
    }
    
    override func setupDelegate() {
        rootView.promiseNameTextField.delegate = self
    }
}


// MARK: - FindPlaceViewControllerDelegate

extension AddPromiseViewController: FindPlaceViewControllerDelegate {
    func configure(selectedPlace: Place) {
        rootView.configurePromisePlaceTextField(with: selectedPlace.location)
    }
}


// MARK: - UITextFieldDelegate

extension AddPromiseViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == rootView.promiseNameTextField {
            textField.resignFirstResponder()
            promiseNameTextFieldEndEditingRelay.accept(())
            return true
        }
        
        return false
    }
    
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        return false
    }
}

private extension AddPromiseViewController {
    func bindViewModel() {
        let input = AddPromiseViewModel.Input(
            promiseNameTextFieldDidChange: rootView.promiseNameTextFieldDidChange,
            promiseTextFieldEndEditing: promiseNameTextFieldEndEditingRelay,
            promisePlaceTextFieldDidTap: promisePlaceTextFieldDidTapRelay
        )
        
        let output = viewModel.transform(input: input, disposeBag: disposeBag)
        
        output.validateNameEditing
            .drive(with: self) { owner, state in
                owner.rootView.configureNameTextField(state: state)
            }
            .disposed(by: disposeBag)
        
        output.validateNameEndEditing
            .drive(with: self) { owner, state in
                owner.rootView.configureNameTextField(state: state)
            }
            .disposed(by: disposeBag)
        
        output.searchPlace
            .drive(with: self) { owner, _ in
                owner.navigateToFindPlace(with: owner)
            }
            .disposed(by: disposeBag)
    }
    
    @objc
    func dismissKeyboard() {
        view.endEditing(true)
        promiseNameTextFieldEndEditingRelay.accept(())
    }
    
    @objc
    func promisePlaceTextFieldDidTap() {
        promisePlaceTextFieldDidTapRelay.accept(())
    }
    
    func navigateToFindPlace(with delegate: FindPlaceViewControllerDelegate) {
        let viewController = FindPlaceViewController(
            viewModel: FindPlaceViewModel(
                service: MockFindPlaceService()
            )
        )
        navigationController?.pushViewController(viewController, animated: true)
    }
}
