//
//  JoinButtonView.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/11/24.
//

import UIKit

class JoinButtonView: BaseView {
    
    
    // MARK: Property

    private let subTitleLabel: UILabel = UILabel().then {
        $0.setText("subTitleLabel", style: .caption02, color: .gray5)
    }
    
    private let mainTitleLabel: UILabel = UILabel().then {
        $0.setText("mainTitleLabel", style: .body03, color: .gray8)
    }
    
    private let chevronImageView: UIImageView = UIImageView().then {
        $0.image = .iconRight.withTintColor(.gray3)
        $0.contentMode = .scaleAspectFit
    }
    
    
    // MARK: - Setup
    
    init(mainTitle: String, subTitle: String) {
        super.init(frame: .zero)
        
        mainTitleLabel.setText(mainTitle, style: .body03, color: .gray8)
        subTitleLabel.setText(subTitle, style: .caption02, color: .gray5)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupView() {
        self.backgroundColor = .green1
        
        self.addSubviews(
            subTitleLabel,
            mainTitleLabel,
            chevronImageView
        )
    }
    
    override func setupAutoLayout() {
        subTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(14)
            $0.leading.equalToSuperview().offset(20)
        }
        
        mainTitleLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(14)
            $0.leading.equalToSuperview().offset(20)
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(2)
        }
        
        chevronImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(17)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(Screen.height(24))
            $0.width.equalTo(chevronImageView.snp.height)
        }
    }
}
