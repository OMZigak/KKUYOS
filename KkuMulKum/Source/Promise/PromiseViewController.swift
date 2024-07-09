//
//  PromiseViewController.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/9/24.
//

import UIKit

class PromiseViewController: BaseViewController {
    
    private let promiseView = PromiseView()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupView() {
        view.backgroundColor = .white
        
        // TODO: 서버 연결할 때 약속 이름으로 바인딩 필요
        
        self.navigationItem.title = "기말고사 모각작"
        
        view.addSubview(promiseView)
        
        promiseView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func setupAction() {
        promiseView.promiseSegmentedControl.addTarget(self, action: #selector(didSegmentedControlIndexUpdated), for: .valueChanged)
    }
    
    
    @objc private func didSegmentedControlIndexUpdated() {
        promiseView.promiseSegmentedControl.selectedUnderLineView.snp.updateConstraints {
            $0.leading.equalToSuperview().offset((promiseView.promiseSegmentedControl.bounds.width / CGFloat(promiseView.promiseSegmentedControl.numberOfSegments)) * CGFloat(promiseView.promiseSegmentedControl.selectedSegmentIndex))
        }
    }
}
