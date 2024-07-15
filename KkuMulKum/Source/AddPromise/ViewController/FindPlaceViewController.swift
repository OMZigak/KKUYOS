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
    private let textFieldEndEditing = PublishRelay<Void>()
    private let cellIsSeleceted = PublishRelay<Place?>()
    
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
    
    override func setupDelegate() {
        rootView.placeTextField.delegate = self
        rootView.placeListView.delegate = self
    }
}


// MARK: - UITextFieldDelegate

extension FindPlaceViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.maincolor.cgColor
        rootView.confirmButton.isEnabled = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == rootView.placeTextField {
            textField.resignFirstResponder()
            textFieldEndEditing.accept(())
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
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? PlaceListCell else { return }
        cellIsSeleceted.accept(cell.place)
    }
}

private extension FindPlaceViewController {
    func bindViewModel() {
        let input = FindPlaceViewModel.Input(
            textFieldDidChange: rootView.placeTextFieldDidChange,
            textFieldEneEditing: textFieldEndEditing,
            cellIsSelected: cellIsSeleceted,
            confirmButtonDidTap: rootView.confirmButtonDidTap
        )
        
        let output = viewModel.transform(input: input, disposeBag: disposeBag)
        
        output.isEndEditingTextField
            .drive(with: self) { owner, flag in
                owner.rootView.configureTextField(flag: flag)
            }
            .disposed(by: disposeBag)
        
        output.placeList
            .drive(rootView.placeListView.rx.items(
                cellIdentifier: PlaceListCell.reuseIdentifier,
                cellType: PlaceListCell.self
            )) { index, place, cell in
                cell.configure(place: place)
            }
            .disposed(by: disposeBag)
        
        output.isEnabledConfirmButton
            .drive(with: self) { owner, flag in
                owner.rootView.confirmButton.isEnabled = flag
            }
            .disposed(by: disposeBag)
        
        output.popViewController
            .drive(with: self) { owner, place in
                guard let place else { return }
                owner.delegate?.configure(selectedPlace: place)
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
    }
}
