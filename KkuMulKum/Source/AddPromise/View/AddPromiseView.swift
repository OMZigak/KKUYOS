//
//  AddPromiseView.swift
//  KkuMulKum
//
//  Created by 김진웅 on 7/14/24.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

final class AddPromiseView: BaseView {
    private let pageNumberLabel = UILabel().then {
        $0.setText("1/3", style: .body05, color: .gray6)
    }
    
    private let titleLabel = UILabel().then {
        $0.setText("약속을\n추가해 주세요", style: .head01, color: .gray8)
    }
    
    private let descriptionStackView = UIStackView(axis: .vertical).then {
        $0.spacing = 12
        $0.alignment = .leading
    }
    
    private let promiseNameLabel = UILabel().then {
        $0.setText("약속 이름", style: .body03, color: .gray8)
    }
    
    let promiseNameTextField = CustomTextField(placeHolder: "약속 이름을 입력해 주세요").then {
        $0.addPadding(right: 12)
        $0.returnKeyType = .done
    }
    
    private let promiseNameCountLabel = UILabel().then {
        $0.setText("0/10", style: .body06, color: .gray3)
    }
    
    private let promiseNameErrorLabel = UILabel().then {
        $0.setText(" ", style: .caption02, color: .red)
    }
    
    private let promiseNameStackView = UIStackView(axis: .vertical).then {
        $0.spacing = 8
    }
    
    private let promisePlaceLabel = UILabel().then {
        $0.setText("약속 장소", style: .body03, color: .gray8)
    }
    
    let promisePlaceTextField = CustomTextField(placeHolder: "약속 장소를 검색해 주세요").then {
        $0.addPadding(right: 12)
    }
    
    private let searchIconView = UIImageView(image: .iconSearch.withTintColor(.gray3))
    
    private let promisePlaceStackView = UIStackView(axis: .vertical).then {
        $0.spacing = 8
    }
    
    override func setupView() {
        descriptionStackView.addArrangedSubviews(pageNumberLabel, titleLabel)
        
        promiseNameTextField.addSubviews(promiseNameCountLabel)
        promiseNameStackView.addArrangedSubviews(
            promiseNameLabel, promiseNameTextField, promiseNameErrorLabel
        )
        
        promisePlaceTextField.addSubviews(searchIconView)
        promisePlaceStackView.addArrangedSubviews(promisePlaceLabel, promisePlaceTextField)
        
        addSubviews(descriptionStackView, promiseNameStackView, promisePlaceStackView)
    }
    
    override func setupAutoLayout() {
        let safeArea = safeAreaLayoutGuide
        
        descriptionStackView.snp.makeConstraints {
            $0.top.equalTo(safeArea).offset(32)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        promiseNameStackView.snp.makeConstraints {
            $0.top.equalTo(descriptionStackView.snp.bottom).offset(16)
            $0.horizontalEdges.equalTo(descriptionStackView)
        }
        
        promiseNameTextField.snp.makeConstraints {
            $0.height.equalTo(CustomTextField.defaultHeight)
        }
        
        promiseNameCountLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-12)
        }
        
        promisePlaceStackView.snp.makeConstraints {
            $0.top.equalTo(promiseNameStackView.snp.bottom).offset(5)
            $0.horizontalEdges.equalTo(promiseNameStackView)
        }
        
        promisePlaceTextField.snp.makeConstraints {
            $0.height.equalTo(CustomTextField.defaultHeight)
        }
        
        searchIconView.snp.makeConstraints {
            $0.centerY.equalToSuperview().offset(4)
            $0.trailing.equalToSuperview().offset(-14)
        }
    }
}

extension AddPromiseView {
    var promiseNameTextFieldDidChange: Observable<String?> {
        promiseNameTextField.rx.text.asObservable()
    }
    
    func configureNameTextField(state: PromiseNameState) {
        switch state {
        case .basic:
            setupNameTextFieldForState(
                borderColor: .gray3,
                countLabelColor: .gray3,
                errorMessage: " "
            )
        case .success:
            setupNameTextFieldForState(
                borderColor: .maincolor,
                countLabelColor: .maincolor,
                errorMessage: " "
            )
        case .failure:
            setupNameTextFieldForState(
                borderColor: .mainred,
                countLabelColor: .mainred,
                errorMessage: "공백 포함 한글, 영문, 숫자만을 사용해 총 10자 이내로 입력해주세요."
            )
        }
    }
    
    func configurePromisePlaceTextField(with placeName: String) {
        promisePlaceTextField.text = placeName
    }
}

private extension AddPromiseView {
    func setupNameTextFieldForState(
        borderColor: UIColor,
        countLabelColor: UIColor,
        errorMessage: String
    ) {
        promiseNameTextField.setLayer(borderWidth: 1, borderColor: borderColor, cornerRadius: 8)
        promiseNameCountLabel.setText(
            "\(promiseNameTextField.text?.count ?? 0)/10",
            style: .body06,
            color: countLabelColor
        )
        promiseNameErrorLabel.setText(
            errorMessage,
            style: .caption02,
            color: .mainred
        )
    }
}
