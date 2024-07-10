//
//  PromiseSegmentedControl.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/9/24.
//

import UIKit

import SnapKit

class PromiseSegmentedControl: UISegmentedControl {
    private let backgroundLineView: UIView = UIView().then {
        $0.backgroundColor = .gray2
    }
    
    let selectedUnderLineView: UIView = UIView().then {
        $0.backgroundColor = .black
        $0.layer.cornerRadius = 1
    }
    
    override init(items: [Any]?) {
        super.init(items: items)
        
        setupSegment()
        setupTextAttribute()
        setupBackgroundLineView()
        setupBackgroundAndDivider()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupSegment() {
        [
            backgroundLineView,
            selectedUnderLineView
        ].forEach { addSubview($0) }
        
        self.selectedSegmentIndex = 0
    }
    
    private func setupBackgroundAndDivider() {
        self.setBackgroundImage(UIImage(), for: .normal, barMetrics: .default)
        self.setBackgroundImage(UIImage(), for: .selected, barMetrics: .default)
        self.setBackgroundImage(UIImage(), for: .highlighted, barMetrics: .default)
        
        self.setDividerImage(
            UIImage(),
            forLeftSegmentState: .selected,
            rightSegmentState: .normal,
            barMetrics: .default
        )
    }
    
    private func setupTextAttribute() {
        setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.gray3,
            NSAttributedString.Key.font: UIFont.pretendard(.body05)
        ], for: .normal)
        setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: UIFont.pretendard(.body05)
        ], for: .selected)
    }
    
    private func setupBackgroundLineView() {
        backgroundLineView.snp.makeConstraints {
            $0.bottom.leading.trailing.equalToSuperview()
            $0.height.equalTo(2)
        }
        
        selectedUnderLineView.snp.makeConstraints {
            $0.bottom.leading.equalToSuperview()
            $0.width.equalToSuperview().dividedBy(numberOfSegments)
            $0.height.equalTo(backgroundLineView)
        }
    }
}
