//
//  FindPlaceViewController.swift
//  KkuMulKum
//
//  Created by 김진웅 on 7/15/24.
//

import UIKit

import RxCocoa
import RxSwift

protocol FindPlaceViewControllerDelegate: AnyObject {
    func configure(selectedPlace: Place)
}

final class FindPlaceViewController: BaseViewController {
    weak var delegate: FindPlaceViewControllerDelegate?
    
    private let viewModel: FindPlaceViewModel
    private let rootView = FindPlaceView()
    private let disposeBag = DisposeBag()
    
    
    // MARK: - Initializer

    init(viewModel: FindPlaceViewModel) {
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
        
        setupNavigationBarTitle(with: "약속 장소")
        setupNavigationBarBackButton()
        
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.isNavigationBarHidden = true
    }
    
    override func setupAction() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    override func setupDelegate() {
        rootView.placeTextField.delegate = self
        rootView.placeListView.delegate = self
    }
}


// MARK: - UITextFieldDelegate

extension FindPlaceViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == rootView.placeTextField {
            textField.resignFirstResponder()
            
            // TODO: 키보드 입력 끝난 이벤트 처리
            
            return true
        }
        
        return false
    }
}

// MARK: - UICollectionViewDelegate

extension FindPlaceViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {        
        for i in 0..<collectionView.numberOfItems(inSection: indexPath.section) {
            guard i != indexPath.item else { continue }
            let otherIndexPath = IndexPath(item: i, section: indexPath.section)
            guard let cell = collectionView.cellForItem(at: otherIndexPath) as? PlaceListCell else {
                continue
            }
            cell.isSelected = false
        }
        
        // TODO: 선택된 셀의 위치 처리
    }
}

private extension FindPlaceViewController {
    func bindViewModel() {
        
    }
    
    @objc
    func dismissKeyboard() {
        view.endEditing(true)
        
        // TODO: 키보드 입력 끝난 이벤트 처리
        
    }
}
