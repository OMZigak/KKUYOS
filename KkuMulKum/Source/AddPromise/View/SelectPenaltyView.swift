//
//  SelectPenaltyView.swift
//  KkuMulKum
//
//  Created by 김진웅 on 7/16/24.
//

import UIKit

import SnapKit
import Then

final class SelectPenaltyView: BaseView {
    private let progressView = UIProgressView(progressViewStyle: .default).then {
        $0.progressTintColor = .maincolor
        $0.backgroundColor = .gray2
        $0.setProgress(0.75, animated: false)
    }
    
    private let pageNumberLabel = UILabel().then {
        $0.setText("3/3", style: .body05, color: .gray6)
    }
    
    private let titleLabel = UILabel().then {
        $0.setText("약속 내용을\n입력해 주세요", style: .head01, color: .gray8)
    }
    
    private let descriptionStackView = UIStackView(axis: .vertical).then {
        $0.spacing = 12
        $0.alignment = .leading
    }
    
    private let levelDescriptionLabel = UILabel().then {
        $0.setText("꾸레벨", style: .body03, color: .gray7)
    }
    
    let levelOneCapsuleButton = SelectCapsuleButton(title: "LV 1. 안꾸", identifier: "LV1")
    let levelTwoCapsuleButton = SelectCapsuleButton(title: "LV 2. 꾸안꾸", identifier: "LV2")
    let levelThreeCapsuleButton = SelectCapsuleButton(title: "LV 3. 꾸꾸", identifier: "LV3")
    let levelFourCapsuleButton = SelectCapsuleButton(title: "LV 4. 꾸꾸꾸", identifier: "LV4")
    let levelFreeCapsuleButton = SelectCapsuleButton(title: "마음대로 입고 오기", identifier: "FREE")
    
    private let penaltyDescriptionLabel = UILabel().then {
        $0.setText("벌칙 설정", style: .body03, color: .gray7)
    }
    
    let penaltyReelsCapsuleButton = SelectCapsuleButton(title: "릴스 찍기")
    let penaltyCafeCapsuleButton = SelectCapsuleButton(title: "맛있는 카페 쏘기")
    let penaltyFinesCapsuleButton = SelectCapsuleButton(title: "지각비 내기")
    let penaltyBobCapsuleButton = SelectCapsuleButton(title: "인디언밥 맞기")
    let penaltyBaamCapsuleButton = SelectCapsuleButton(title: "딱밤 맞기")
    let penaltySkipCapsuleButton = SelectCapsuleButton(title: "눈 감아주기")
    
    let confirmButton = CustomButton(title: "약속 생성하기")
    
    override func setupView() {
        descriptionStackView.addArrangedSubviews(pageNumberLabel, titleLabel)
        levelButtons.forEach { addSubviews($0) }
        penaltyButtons.forEach { addSubviews($0) }
        addSubviews(
            progressView,
            descriptionStackView,
            levelDescriptionLabel,
            penaltyDescriptionLabel,
            confirmButton
        )
    }
    
    override func setupAutoLayout() {
        let safeArea = safeAreaLayoutGuide
        
        progressView.snp.makeConstraints {
            $0.top.equalTo(safeArea).offset(-2)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(Screen.height(3))
        }
        
        descriptionStackView.snp.makeConstraints {
            $0.top.equalTo(safeArea).offset(32)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        levelDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(descriptionStackView.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(20)
        }
        
        levelOneCapsuleButton.snp.makeConstraints {
            $0.top.equalTo(levelDescriptionLabel.snp.bottom).offset(12)
            $0.leading.equalToSuperview().offset(20)
            $0.width.equalTo(Screen.width(86))
            $0.height.equalTo(SelectCapsuleButton.defaultHeight)
        }
        
        levelTwoCapsuleButton.snp.makeConstraints {
            $0.top.equalTo(levelOneCapsuleButton)
            $0.leading.equalTo(levelOneCapsuleButton.snp.trailing).offset(4)
            $0.width.equalTo(Screen.width(103))
            $0.height.equalTo(SelectCapsuleButton.defaultHeight)
        }
        
        levelThreeCapsuleButton.snp.makeConstraints {
            $0.top.equalTo(levelOneCapsuleButton)
            $0.leading.equalTo(levelTwoCapsuleButton.snp.trailing).offset(4)
            $0.width.equalTo(Screen.width(89))
            $0.height.equalTo(SelectCapsuleButton.defaultHeight)
        }
        
        levelFourCapsuleButton.snp.makeConstraints {
            $0.top.equalTo(levelOneCapsuleButton.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(20)
            $0.width.equalTo(Screen.width(103))
            $0.height.equalTo(SelectCapsuleButton.defaultHeight)
        }
        
        levelFreeCapsuleButton.snp.makeConstraints {
            $0.top.equalTo(levelFourCapsuleButton)
            $0.leading.equalTo(levelFourCapsuleButton.snp.trailing).offset(4)
            $0.width.equalTo(Screen.width(140))
            $0.height.equalTo(SelectCapsuleButton.defaultHeight)
        }
        
        penaltyDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(levelFourCapsuleButton.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(20)
        }
        
        penaltyReelsCapsuleButton.snp.makeConstraints {
            $0.top.equalTo(penaltyDescriptionLabel.snp.bottom).offset(12)
            $0.leading.equalToSuperview().offset(20)
            $0.width.equalTo(Screen.width(83))
            $0.height.equalTo(SelectCapsuleButton.defaultHeight)
        }
        
        penaltyCafeCapsuleButton.snp.makeConstraints {
            $0.top.equalTo(penaltyReelsCapsuleButton)
            $0.leading.equalTo(penaltyReelsCapsuleButton.snp.trailing).offset(4)
            $0.width.equalTo(Screen.width(127))
            $0.height.equalTo(SelectCapsuleButton.defaultHeight)
        }
        
        penaltyFinesCapsuleButton.snp.makeConstraints {
            $0.top.equalTo(penaltyReelsCapsuleButton)
            $0.leading.equalTo(penaltyCafeCapsuleButton.snp.trailing).offset(4)
            $0.width.equalTo(Screen.width(96))
            $0.height.equalTo(SelectCapsuleButton.defaultHeight)
        }
        
        penaltyBobCapsuleButton.snp.makeConstraints {
            $0.top.equalTo(penaltyReelsCapsuleButton.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(20)
            $0.width.equalTo(Screen.width(110))
            $0.height.equalTo(SelectCapsuleButton.defaultHeight)
        }
        
        penaltyBaamCapsuleButton.snp.makeConstraints {
            $0.top.equalTo(penaltyBobCapsuleButton)
            $0.leading.equalTo(penaltyBobCapsuleButton.snp.trailing).offset(4)
            $0.width.equalTo(Screen.width(83))
            $0.height.equalTo(SelectCapsuleButton.defaultHeight)
        }
        
        penaltySkipCapsuleButton.snp.makeConstraints {
            $0.top.equalTo(penaltyBobCapsuleButton)
            $0.leading.equalTo(penaltyBaamCapsuleButton.snp.trailing).offset(4)
            $0.width.equalTo(Screen.width(96))
            $0.height.equalTo(SelectCapsuleButton.defaultHeight)
        }

        confirmButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(CustomButton.defaultHeight)
            $0.bottom.equalToSuperview().offset(-64)
        }
    }
}

extension SelectPenaltyView {
    var levelButtons: [SelectCapsuleButton] { [
        levelOneCapsuleButton,
        levelTwoCapsuleButton,
        levelThreeCapsuleButton,
        levelFourCapsuleButton,
        levelFreeCapsuleButton
    ] }
    
    var penaltyButtons: [SelectCapsuleButton] { [
            penaltyReelsCapsuleButton,
            penaltyCafeCapsuleButton,
            penaltyFinesCapsuleButton,
            penaltyBobCapsuleButton,
            penaltyBaamCapsuleButton,
            penaltySkipCapsuleButton
    ] }
}
