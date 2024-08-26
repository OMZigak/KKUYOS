//
//  AddPromiseView.swift
//  KkuMulKum
//
//  Created by 김진웅 on 7/14/24.
//

import UIKit

import SnapKit
import Then

final class AddPromiseView: BaseView {
    let progressView = UIProgressView(progressViewStyle: .bar).then {
        $0.progressTintColor = .maincolor
        $0.backgroundColor = .gray1
        $0.setProgress(0.0, animated: false)
    }
    
    private let pageNumberLabel = UILabel().then {
        $0.setText("1/3", style: .body05, color: .gray6)
    }
    
    let titleLabel = UILabel().then {
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
    
    let promiseNameCountLabel = UILabel().then {
        $0.setText("0/10", style: .body06, color: .gray3)
    }
    
    let promiseNameErrorLabel = UILabel().then {
        $0.setText(
            "공백 포함 한글, 영문, 숫자만을 사용해 총 10자 이내로 입력해주세요.",
            style: .caption02,
            color: .mainred
        )
        $0.isHidden = true
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
    
    private let promiseTimeTitleLabel = UILabel().then {
        $0.setText("약속 시간", style: .body03, color: .gray8)
        $0.textAlignment = .left
    }
    
    let datePicker = UIDatePicker().then {
        $0.datePickerMode = .date
        $0.preferredDatePickerStyle = .compact
        $0.locale = Locale(identifier: "ko_KR")
        $0.minimumDate = Date()
    }
    
    let timePicker = UIDatePicker().then {
        $0.datePickerMode = .time
        $0.preferredDatePickerStyle = .compact
        $0.locale = Locale(identifier: "ko_KR")
        $0.date = Date()
    }
    
    let confirmButton = CustomButton(title: "다음")
    
    override func setupView() {
        descriptionStackView.addArrangedSubviews(
            pageNumberLabel,
            titleLabel
        )
        promiseNameTextField.addSubviews(
            promiseNameCountLabel
        )
        promiseNameStackView.addArrangedSubviews(
            promiseNameLabel,
            promiseNameTextField,
            promiseNameErrorLabel
        )
        promisePlaceTextField.addSubviews(
            searchIconView
        )
        promisePlaceStackView.addArrangedSubviews(
            promisePlaceLabel,
            promisePlaceTextField
        )
        addSubviews(
            progressView,
            descriptionStackView,
            promiseNameStackView,
            promisePlaceStackView,
            promiseTimeTitleLabel,
            datePicker,
            timePicker,
            confirmButton
        )
    }
    
    override func setupAutoLayout() {
        let safeArea = safeAreaLayoutGuide
        
        progressView.snp.makeConstraints {
            $0.top.equalTo(safeArea).offset(-1)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(Screen.height(4))
        }
        
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
            $0.top.equalTo(promiseNameTextField.snp.bottom).offset(36)
            $0.horizontalEdges.equalTo(promiseNameStackView)
        }
        
        promisePlaceTextField.snp.makeConstraints {
            $0.height.equalTo(CustomTextField.defaultHeight)
        }
        
        searchIconView.snp.makeConstraints {
            $0.centerY.equalToSuperview().offset(4)
            $0.trailing.equalToSuperview().offset(-14)
        }
        
        promiseTimeTitleLabel.snp.makeConstraints {
            $0.top.equalTo(promisePlaceStackView.snp.bottom).offset(28)
            $0.leading.equalToSuperview().offset(20)
        }
        
        datePicker.snp.makeConstraints {
            $0.top.equalTo(promiseTimeTitleLabel.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(20)
        }
        
        timePicker.snp.makeConstraints {
            $0.leading.equalTo(datePicker.snp.trailing).offset(12)
            $0.centerY.equalTo(datePicker)
        }
        
        confirmButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(CustomButton.defaultHeight)
            $0.bottom.equalToSuperview().offset(-64)
        }
    }
}
