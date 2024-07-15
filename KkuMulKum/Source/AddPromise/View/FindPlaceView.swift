//
//  FindPlaceView.swift
//  KkuMulKum
//
//  Created by 김진웅 on 7/15/24.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

final class FindPlaceView: BaseView {
    let placeTextField = CustomTextField(placeHolder: "약속 장소를 검색해 주세요").then {
        $0.returnKeyType = .done
    }
    
    let placeListView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout().then {
            $0.scrollDirection = .vertical
            $0.itemSize = .init(
                width: PlaceListCell.defaultWidth,
                height: PlaceListCell.defaultHeight
            )
            $0.minimumInteritemSpacing = 8
        }
    ).then {
        $0.register(PlaceListCell.self, forCellWithReuseIdentifier: PlaceListCell.reuseIdentifier)
    }
    
    let confirmButton = CustomButton(title: "확인")
    
    override func setupView() {
        addSubviews(placeTextField, placeListView, confirmButton)
    }
    
    override func setupAutoLayout() {
        let safeArea = safeAreaLayoutGuide
        
        placeTextField.snp.makeConstraints {
            $0.top.equalTo(safeArea).offset(24)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(CustomTextField.defaultHeight)
        }
        
        placeListView.snp.makeConstraints {
            $0.top.equalTo(placeTextField.snp.bottom).offset(8)
            $0.horizontalEdges.equalTo(placeTextField)
            $0.bottom.equalTo(safeArea).offset(-140)
        }
        
        confirmButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(CustomButton.defaultHeight)
            $0.bottom.equalToSuperview().offset(-64)
        }
    }
}

extension FindPlaceView {
    var placeTextFieldDidChange: Observable<String?> { placeTextField.rx.text.asObservable() }
    var confirmButtonDidTap: Observable<Void> { confirmButton.rx.tap.asObservable() }
    
    func configureTextField(flag: Bool) {
        placeTextField.layer.borderColor = flag ? UIColor.gray3.cgColor : UIColor.maincolor.cgColor
    }
}
