//
//  PromiseSegmentedControl.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/9/24.
//

import UIKit

import SnapKit

class BasePromiseSegmentedControl: UISegmentedControl {
    private let backgroundLineView: UIView = UIView(backgroundColor: .gray2)
    
    let selectedUnderLineView: UIView = UIView(backgroundColor: .black).then {
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
        addSubviews(backgroundLineView, selectedUnderLineView)
        
        selectedSegmentIndex = 0
    }
    
    private func setupBackgroundAndDivider() {
        setBackgroundImage(UIImage(), for: .normal, barMetrics: .default)
        setBackgroundImage(UIImage(), for: .selected, barMetrics: .default)
        setBackgroundImage(UIImage(), for: .highlighted, barMetrics: .default)
        
        setDividerImage(
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
