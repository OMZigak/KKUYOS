//
//  SetReadyInfoViewController.swift
//  KkuMulKum
//
//  Created by 예삐 on 7/14/24.
//

import UIKit

import RxCocoa
import RxSwift

final class SetReadyInfoViewController: BaseViewController {
    
    
    // MARK: - Property
    
    private let rootView = SetReadyInfoView()

    private let viewModel: SetReadyInfoViewModel
    private let disposeBag = DisposeBag()
    
    
    // MARK: - Initializer
    
    init(viewModel: SetReadyInfoViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - LifeCycle
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupBinding()
        setupTapGesture()
        setupTextField()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = false
    }
    
    override func setupView() {
        setupNavigationBarBackButton()
        setupNavigationBarTitle(with: "준비 정보 입력하기")
    }
    
    override func setupDelegate() {
        setTextFieldDelegate()
    }
    
    override func setupAction() {
        setupTextField(textField: rootView.readyHourTextField)
        setupTextField(textField: rootView.readyMinuteTextField)
        setupTextField(textField: rootView.moveHourTextField)
        setupTextField(textField: rootView.moveMinuteTextField)
        
        rootView.doneButton.addTarget(
            self,
            action: #selector(doneButtonDidTap),
            for: .touchUpInside
        )
    }
    
    private func bindViewModel() {
        let input = SetReadyInfoViewModel.Input(
            readyHourText: rootView.readyHourTextField.rx.text.orEmpty.asObservable(),
            readyMinuteText: rootView.readyMinuteTextField.rx.text.orEmpty.asObservable(),
            moveHourText: rootView.moveHourTextField.rx.text.orEmpty.asObservable(),
            moveMinuteText: rootView.moveMinuteTextField.rx.text.orEmpty.asObservable()
        )
        
        let output = viewModel.transform(input: input, disposeBag: disposeBag)
        
        output.readyHourText
            .drive(with: self) { owner, text in
                owner.rootView.readyHourTextField.text = text
            }
            .disposed(by: disposeBag)
        
        output.readyMinuteText
            .drive(with: self) { owner, text in
                owner.rootView.readyMinuteTextField.text = text
            }
            .disposed(by: disposeBag)
        
        output.moveHourText
            .drive(with: self) { owner, text in
                owner.rootView.moveHourTextField.text = text
            }
            .disposed(by: disposeBag)
        
        output.moveMinuteText
            .drive(with: self) { owner, text in
                owner.rootView.moveMinuteTextField.text = text
            }
            .disposed(by: disposeBag)
    }
    
    private func setupTextField(textField: UITextField) {
        let textFieldEvent = Observable.merge(
            textField.rx.controlEvent(.editingDidBegin).map { UIColor.maincolor.cgColor },
            textField.rx.controlEvent(.editingDidEnd).map { UIColor.gray3.cgColor },
            textField.rx.controlEvent(.editingDidEndOnExit).map { UIColor.gray3.cgColor }
        )
        
        textFieldEvent
            .bind { borderColor in
                textField.layer.borderColor = borderColor
            }
            .disposed(by: disposeBag)
    }
    
    @objc
    private func doneButtonDidTap(_ sender: UIButton) {
        viewModel.updateReadyInfo()
    }
    
    
    // MARK: - Keyboard Dismissal
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc
    private func dismissKeyboard() {
        view.endEditing(true)
    }
}


// MARK: - UITextFieldDelegate

extension SetReadyInfoViewController: UITextFieldDelegate {
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
}


// MARK: - Function

private extension SetReadyInfoViewController {
    func setupTextField() {
        /// 저장된 준비 시간이 0이 아니면 텍스트 필드에 설정
        if viewModel.storedReadyHour != 0 || viewModel.storedReadyMinute != 0 {
            rootView.readyHourTextField.text = String(viewModel.storedReadyHour)
            rootView.readyMinuteTextField.text = String(viewModel.storedReadyMinute)
        }
        
        /// 저장된 이동 시간이 0이 아니면 텍스트 필드에 설정
        if viewModel.storedMoveHour != 0 || viewModel.storedMoveMinute != 0 {
            rootView.moveHourTextField.text = String(viewModel.storedMoveHour)
            rootView.moveMinuteTextField.text = String(viewModel.storedMoveMinute)
        }
        
        viewModel.checkValid(
            readyHourText: rootView.readyHourTextField.text ?? "",
            readyMinuteText: rootView.readyMinuteTextField.text ?? "",
            moveHourText: rootView.moveHourTextField.text ?? "",
            moveMinuteText: rootView.moveMinuteTextField.text ?? ""
        )
    }
    
    func setTextFieldDelegate() {
        let textFields: [(UITextField, String)] = [
            (rootView.readyHourTextField, "readyHour"),
            (rootView.readyMinuteTextField, "readyMinute"),
            (rootView.moveHourTextField, "moveHour"),
            (rootView.moveMinuteTextField, "moveMinute")
        ]
        
        textFields.forEach { (textField, identifier) in
            textField.delegate = self
            textField.keyboardType = .numberPad
            textField.accessibilityIdentifier = identifier
        }
    }
    
    func showToast(_ message: String, bottomInset: CGFloat = 128) {
        guard let view else { return }
        Toast().show(message: message, view: view, position: .bottom, inset: bottomInset)
    }
    
    // MARK: - Data Bind
    
    func setupBinding() {
        viewModel.isValid.bind { [weak self] isValid in
            self?.rootView.doneButton.isEnabled = isValid
        }
        
//        viewModel.errMessage.bind { [weak self] err in
//            if !err.isEmpty {
//                self?.showToast(err)
//            }
//        }
        
        viewModel.isSucceedToSave.bind { [weak self] _ in
            if self?.viewModel.isSucceedToSave.value == true {
                DispatchQueue.main.async {
                    let viewController = SetReadyCompletedViewController()
                    self?.navigationController?.pushViewController(
                        viewController,
                        animated: true
                    )
                }
            }
        }
    }
}
