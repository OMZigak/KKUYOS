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
    private let viewModel: AddPromiseViewModel
    private let disposeBag = DisposeBag()
    private let rootView = AddPromiseView()
    private let promiseNameTextFieldEndEditingRelay = PublishRelay<Void>()
    private let searchPlaceCompleted = PublishRelay<Place>()
    
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func setupAction() {
        /// progressView의 progress 설정
        rootView.promiseNameTextField.rx.text.orEmpty
            .map { !$0.isEmpty ? 0.25 : 0.0 }
            .bind(to: rootView.progressView.rx.progress)
            .disposed(by: disposeBag)
        
        rootView.promiseNameTextField.rx.text
            .map { "\($0?.count ?? 0)/10" }
            .bind(to: rootView.promiseNameCountLabel.rx.text)
            .disposed(by: disposeBag)
        
        rootView.confirmButton.rx.tap
            .map { _ in }
            .subscribe(with: self) { owner, temp in
                
                // TODO: 다음화면으로 넘어가기
                
            }
            .disposed(by: disposeBag)
    }
    
    override func setupDelegate() {
        rootView.promiseNameTextField.delegate = self
    }
}


// MARK: - FindPlaceViewControllerDelegate

extension AddPromiseViewController: FindPlaceViewControllerDelegate {
    func configure(selectedPlace: Place) {
        rootView.promisePlaceTextField.text = selectedPlace.location
        searchPlaceCompleted.accept(selectedPlace)
    }
}


// MARK: - UITextFieldDelegate

extension AddPromiseViewController: UITextFieldDelegate {
    /// done을 눌렀을 때
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == rootView.promiseNameTextField {
            textField.resignFirstResponder()
            return true
        }
        return false
    }
    
    /// 위치 텍스트필드의 사용자 입력 차단
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        if textField == rootView.promisePlaceTextField {
            return false
        }
        return true
    }
}

private extension AddPromiseViewController {
    func bindViewModel() {
        let promiseTextFieldEndEditing = Observable.merge(
            rootView.promiseNameTextField.rx.controlEvent(.editingDidEndOnExit).asObservable(),
            rootView.promiseNameTextField.rx.controlEvent(.editingDidEnd).asObservable()
        )
        
        let input = AddPromiseViewModel.Input(
            promiseNameText: rootView.promiseNameTextField.rx.text.orEmpty.asObservable(),
            promiseTextFieldEndEditing: promiseTextFieldEndEditing,
            date: rootView.datePicker.rx.date.asObservable(),
            time: rootView.timePicker.rx.date.asObservable()
        )
        
        let output = viewModel.transform(input: input, disposeBag: disposeBag)
        
        output.validationPromiseNameResult
            .subscribe(with: self) { owner, result in
                owner.configurePromiseName(result: result)
            }
            .disposed(by: disposeBag)
    }
    
    func configurePromiseName(result: TextFieldVailidationResult) {
        print(">>> \(viewModel.combinedDataTime) : \(#function)")

        switch result {
        case .basic:
            rootView.do {
                $0.promiseNameTextField.layer.borderColor = UIColor.gray3.cgColor
                $0.promiseNameCountLabel.textColor = .gray3
                $0.promiseNameErrorLabel.isHidden = true
            }
        case .onWriting:
            rootView.do {
                $0.promiseNameTextField.layer.borderColor = UIColor.maincolor.cgColor
                $0.promiseNameCountLabel.textColor = .maincolor
                $0.promiseNameErrorLabel.isHidden = true
            }
        case .error:
            rootView.do {
                $0.promiseNameTextField.layer.borderColor = UIColor.mainred.cgColor
                $0.promiseNameCountLabel.textColor = .mainred
                $0.promiseNameErrorLabel.isHidden = false
            }
        }
    }
}
