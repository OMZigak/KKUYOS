//
//  EditPromiseViewController.swift
//  KkuMulKum
//
//  Created by YOUJIM on 8/25/24.
//

import UIKit

class EditPromiseViewController: BaseViewController {
    let viewModel: EditPromiseViewModel
    
    private let rootView: AddPromiseView = AddPromiseView()
    
    
    // MARK: - LifeCycle
    
    init(viewModel: EditPromiseViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rootView.promiseNameTextField.text = viewModel.promiseName?.value
        rootView.promisePlaceTextField.text = viewModel.placeName
        
        setupNavigationBarBackButton()
        setupNavigationBarTitle(with: "약속 수정하기")
        
        setupBinding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    
    // MARK: - Setup

    override func setupView() {
        rootView.titleLabel.text = "약속을\n수정해 주세요"
        rootView.confirmButton.isEnabled = true
    }
    
    override func setupAction() {
        rootView.confirmButton.addTarget(self, action: #selector(confirmButtonDidTap), for: .touchUpInside)
    }
    
    override func setupDelegate() {
        rootView.promiseNameTextField.delegate = self
    }
}


// MARK: - Extension

private extension EditPromiseViewController {
    func setupBinding() {
        viewModel.promiseNameState.bind(with: self) { owner, state in
            owner.rootView.promiseNameErrorLabel.isHidden = true
            
            
            switch state {
            case .valid:
                self.rootView.promiseNameTextField.layer.borderColor = UIColor.maincolor.cgColor
            case .invalid:
                self.rootView.promiseNameTextField.layer.borderColor = UIColor.mainred.cgColor
            case .empty:
                self.rootView.promiseNameTextField.layer.borderColor = UIColor.gray3.cgColor
            }
        }
    }
    
    @objc
    func confirmButtonDidTap() {
        let viewController = ChooseMemberViewController(viewModel: viewModel)
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc
    func textFieldDidChange() {
        
    }
}


// MARK: - UITextFieldDelegate

extension EditPromiseViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        viewModel.validateName(rootView.promiseNameTextField.text ?? "")
        rootView.promiseNameCountLabel.text = "\(viewModel.promiseName?.value.count ?? 0)/10"
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        rootView.promiseNameTextField.layer.borderColor = UIColor.maincolor.cgColor
        
        return true
    }
//    
//    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
//        viewModel.validateName(textField.text ?? "")
//        
//        return true
//    }
}
