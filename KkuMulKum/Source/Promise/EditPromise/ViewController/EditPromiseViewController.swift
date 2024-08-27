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
    private let findPlaceViewController = FindPlaceViewController(
        viewModel: FindPlaceViewModel(
            service: UtilService()
        )
    )
    
    
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
    
        setupNavigationBarBackButton()
        setupNavigationBarTitle(with: "약속 수정하기", isBorderHidden: true)
        
        setupBinding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = false
    }
    
    
    // MARK: - Setup

    override func setupView() {
        rootView.promiseNameTextField.text = viewModel.promiseName?.value
        rootView.promiseNameCountLabel.text = "\(viewModel.promiseName?.value.count ?? 0)/10"
        rootView.promisePlaceTextField.text = viewModel.placeName?.value
        rootView.titleLabel.text = "약속을\n수정해 주세요"
        rootView.confirmButton.isEnabled = true
        
        setupDatePicker()
    }
    
    override func setupAction() {
        rootView.confirmButton.addTarget(self, action: #selector(confirmButtonDidTap), for: .touchUpInside)
        rootView.promiseNameTextField.addTarget(self, action: #selector(nameTextFieldDidChange), for: .editingChanged)
        rootView.promisePlaceTextField.addTarget(self, action: #selector(placeTextFieldDidTap), for: .touchDown)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        )
    }
    
    override func setupDelegate() {
        findPlaceViewController.delegate = self
        rootView.promiseNameTextField.delegate = self
    }
}


// MARK: - Extension

private extension EditPromiseViewController {
    func setupBinding() {
        viewModel.promiseNameState.bind(with: self) { owner, state in
            owner.rootView.promiseNameErrorLabel.isHidden = true
            owner.rootView.confirmButton.isEnabled = true
            
            switch state {
            case .valid:
                owner.rootView.promiseNameTextField.layer.borderColor = UIColor.maincolor.cgColor
            case .invalid:
                owner.rootView.promiseNameTextField.layer.borderColor = UIColor.mainred.cgColor
                owner.rootView.promiseNameErrorLabel.isHidden = false
                owner.rootView.confirmButton.isEnabled = false
            case .empty:
                owner.rootView.promiseNameTextField.layer.borderColor = UIColor.gray3.cgColor
            }
        }
        
        viewModel.promiseName?.bind(with: self, { owner, name in
            owner.rootView.promiseNameCountLabel.text = "\(owner.viewModel.promiseName?.value.count ?? 0)/10"
        })
        
        viewModel.placeName?.bind(with: self, { owner, name in
            owner.rootView.promisePlaceTextField.text = owner.viewModel.placeName?.value ?? ""
        })
    }
    
    func setupDatePicker() {
        let inputDateFormatter = DateFormatter()
        inputDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        guard let date = inputDateFormatter.date(from: viewModel.time ?? "") else {
            return
        }
        
        rootView.datePicker.minimumDate = .none
        rootView.datePicker.date = date
        rootView.timePicker.date = date
    }
    
    @objc
    func confirmButtonDidTap() {
        viewModel.updateDateInfo(
            date: rootView.datePicker.date,
            time: rootView.timePicker.date
        )
        
        let viewController = ChooseMemberViewController(viewModel: viewModel)
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc
    func nameTextFieldDidChange() {
        viewModel.validateName(rootView.promiseNameTextField.text ?? "")
    }
    
    @objc
    func placeTextFieldDidTap() {
        findPlaceViewController.navigationController?.isNavigationBarHidden = false
        self.navigationController?.pushViewController(findPlaceViewController, animated: true)
    }
    
    @objc
    func dismissKeyboard() {
        viewModel.validateName(rootView.promiseNameTextField.text ?? "")
        view.endEditing(true)
    }
}


// MARK: - UITextFieldDelegate

extension EditPromiseViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        rootView.promiseNameTextField.layer.borderColor = UIColor.maincolor.cgColor
        
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        viewModel.validateName(textField.text ?? "")
        
        return true
    }
}


// MARK: - FindPlaceViewControllerDelegate

extension EditPromiseViewController: FindPlaceViewControllerDelegate {
    func configure(selectedPlace: Place) {
        viewModel.updatePlaceInfo(place: selectedPlace)
    }
}
