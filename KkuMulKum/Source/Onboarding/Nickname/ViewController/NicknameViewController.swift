//
//  NicknameViewController.swift
//  KkuMulKum
//
//  Created by 이지훈 on 7/10/24.
//

import UIKit

import RxSwift
import RxCocoa

class NicknameViewController: BaseViewController {
    
    private let nicknameView = NicknameView()
    private let viewModel: NicknameViewModel
    private let disposeBag = DisposeBag()
    
    init(viewModel: NicknameViewModel = NicknameViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = nicknameView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        setupTextField()
        setupTapGesture()
        setupNavigationBarTitle(with: "닉네임 설정")
    }
    
    private func setupBindings() {
        nicknameView.nicknameTextField.rx.text.orEmpty
            .bind(to: viewModel.nicknameText)
            .disposed(by: disposeBag)
        
        viewModel.nicknameState
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] state in
                self?.updateUIForNicknameState(state)
            })
            .disposed(by: disposeBag)
        
        viewModel.errorMessage
            .bind(to: nicknameView.errorLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.isNextButtonEnabled
            .bind(to: nicknameView.nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        viewModel.isNextButtonValid
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isValid in
                self?.updateNextButtonAppearance(isValid: isValid)
            })
            .disposed(by: disposeBag)
        
        viewModel.characterCount
            .bind(to: nicknameView.characterCountLabel.rx.text)
            .disposed(by: disposeBag)
        
        nicknameView.nextButton.rx.tap
            .bind(to: viewModel.updateNicknameTrigger)
            .disposed(by: disposeBag)
        
        viewModel.nicknameUpdateSuccess
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] nickname in
                self?.navigateToProfileSetup(with: nickname)
            })
            .disposed(by: disposeBag)
        
        viewModel.serverResponse
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { response in
                print("서버 응답: \(response ?? "")")
            })
            .disposed(by: disposeBag)
        
        nicknameView.nicknameTextField.rx.controlEvent(.editingDidEnd)
            .withLatestFrom(viewModel.nicknameState)
            .subscribe(onNext: { [weak self] state in
                self?.updateUIForNicknameState(state)
            })
            .disposed(by: disposeBag)
    }
    
    private func updateUIForNicknameState(_ state: NicknameState) {
           switch state {
           case .empty:
               nicknameView.nicknameTextField.layer.borderColor = UIColor.gray3.cgColor
               nicknameView.errorLabel.isHidden = true
           case .valid:
               nicknameView.nicknameTextField.layer.borderColor = UIColor.maincolor.cgColor
               nicknameView.errorLabel.isHidden = true
           case .invalid:
               nicknameView.nicknameTextField.layer.borderColor = UIColor.red.cgColor
               nicknameView.errorLabel.isHidden = false
           }
           updateNextButtonAppearance(isValid: state == .valid)
       }

       private func updateNextButtonAppearance(isValid: Bool) {
           nicknameView.nextButton.backgroundColor = isValid ? .maincolor : .gray2
           nicknameView.nextButton.isEnabled = isValid
       }

    
    private func navigateToProfileSetup(with nickname: String) {
        let profileSetupVM = ProfileSetupViewModel(nickname: nickname)
        let profileSetupVC = ProfileSetupViewController(viewModel: profileSetupVM)
        navigationController?.pushViewController(profileSetupVC, animated: true)
    }
    
    private func setupTextField() {
        nicknameView.nicknameTextField.delegate = self
        nicknameView.nicknameTextField.returnKeyType = .done
    }
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer()
        tapGesture.rx.event
            .subscribe(onNext: { [weak self] _ in
                self?.view.endEditing(true)
                self?.updateUIForNicknameState(self?.viewModel.nicknameState.value ?? .empty)
            })
            .disposed(by: disposeBag)
        view.addGestureRecognizer(tapGesture)
    }
}

extension NicknameViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        updateUIForNicknameState(viewModel.nicknameState.value)
        return true
    }
}
