//
//  BaseViewController.swift
//  KkuMulKum
//
//  Created by 김진웅 on 7/3/24.
//

import UIKit

class BaseViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupView()
        setupAction()
        setupDelegate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    /// 네비게이션 바 등 추가적으로 UI와 관련한 작업
    func setupView() {}
    
    /// RootView로부터 액션 설정 (addTarget)
    func setupAction() {}
    
    /// RootView 또는 ViewController 자체로부터 Delegate, DateSource 등 설정
    func setupDelegate() {}
}

extension BaseViewController {
    /// 네비게이션 바 타이틀 설정 및 경계선 숨김 또는 표시
    func setupNavigationBarTitle(with string: String, isBorderHidden: Bool = false) {
        title = string
        
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.gray8,
            .font: UIFont.pretendard(.body03)
        ]
        
        let barAppearance = UINavigationBarAppearance()
        barAppearance.backgroundColor = .white
        barAppearance.shadowColor = nil
        
        navigationController?.navigationBar.standardAppearance = barAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = barAppearance
        
        if !isBorderHidden {
            addBorder()
        }
    }
    
    /// 네비게이션 바 BackButton 구성
    func setupNavigationBarBackButton() {
        let backButton = UIBarButtonItem(
            image: .iconBack,
            style: .plain,
            target: self,
            action: #selector(backButtonDidTap)
        ).then {
            $0.tintColor = .black
        }
        
        navigationItem.leftBarButtonItem = backButton
    }
}


// MARK: - UIGestureRecognizerDelegate

extension BaseViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return navigationController?.viewControllers.count ?? 0 > 1
    }
}


// MARK: - Private Method

private extension BaseViewController {
    @objc
    func backButtonDidTap() {
        navigationController?.popViewController(animated: true)
    }
    
    func addBorder() {
        let identifier = "border"
        guard view.subviews.first(where: { $0.accessibilityIdentifier == identifier }) == nil else { return }
        
        let safeArea = view.safeAreaLayoutGuide
        let border = UIView(backgroundColor: .gray2).then {
            $0.accessibilityIdentifier = identifier
        }
        
        view.addSubview(border)
        
        border.snp.makeConstraints {
            $0.top.equalTo(safeArea)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        view.bringSubviewToFront(border)
        
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }
}
