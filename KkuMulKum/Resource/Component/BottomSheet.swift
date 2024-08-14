//
//  UIBottomSheet+.swift
//  KkuMulKum
//
//  Created by 이지훈 on 8/14/24.
//// ref: https://velog.io/@minsang/iOS-Bottom-Sheet

import UIKit
import SnapKit
import Then

enum BottomSheetViewState {
    case expanded
    case normal
}

class BottomSheetViewController: UIViewController {
    private lazy var dimmedView = UIView().then {
        $0.backgroundColor = UIColor.darkGray.withAlphaComponent(self.dimmedAlpha)
        $0.alpha = 0
    }
    
    private lazy var bottomSheetView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = self.cornerRedius
        $0.layer.cornerCurve = .continuous
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        $0.clipsToBounds = true
    }
    
    private let dragIndicatorView = UIView().then {
        $0.backgroundColor = .black
        $0.tintColor = .black
        $0.layer.cornerRadius = 1.5
        $0.alpha = 0
    }
    
    // 열린 BottomSheet의 기본 높이를 지정하기 위한 프로퍼티
    var defaultHeight: CGFloat = 500
    // bottomSheetView의 상단 CornerRadius 값
    var cornerRedius: CGFloat = 8
    // dimmedView의 alpha값
    var dimmedAlpha: CGFloat = 0.6
    // Bottom Sheet과 safe Area Top 사이의 최소값을 지정하기 위한 프로퍼티
    var bottomSheetPanMinTopConstant: CGFloat = 40
    // pannedGesture 활성화 여부
    var isPannedable: Bool = false
    // 드래그 하기 전에 Bottom Sheet의 top Constraint value를 저장하기 위한 프로퍼티
    private lazy var bottomSheetPanStartingTopConstant: CGFloat = bottomSheetPanMinTopConstant
    
    private let contentViewController: UIViewController
    
    init(contentViewController: UIViewController, defaultHeight: CGFloat, cornerRadius: CGFloat = 8, dimmedAlpha: CGFloat = 0.6, isPannedable: Bool = false) {
        self.contentViewController = contentViewController
        self.defaultHeight = defaultHeight
        self.cornerRedius = cornerRadius
        self.dimmedAlpha = dimmedAlpha
        self.isPannedable = isPannedable
        
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .overFullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
        self.configureLayout()
        self.configureDimmedTapGesture()
        self.dragIndicatorView.alpha = 1
        }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.showBottomSheet()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate { [weak self] _ in
            self?.showBottomSheet()
        }
    }
    
    private func showBottomSheet(atState: BottomSheetViewState = .normal) {
        let screenHeight: CGFloat = view.frame.height
        
        if atState == .normal {
            bottomSheetView.snp.updateConstraints {
                $0.height.equalTo(defaultHeight)
            }
        } else {
            bottomSheetView.snp.updateConstraints {
                $0.height.equalTo(screenHeight - bottomSheetPanMinTopConstant)
            }
        }
        
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
            self.dimmedView.alpha = self.dimmedAlpha
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}

// MARK: Configure
extension BottomSheetViewController {
    private func configureUI() {
        view.addSubviews(dimmedView, bottomSheetView, dragIndicatorView)
        
        addChild(contentViewController)
        bottomSheetView.addSubview(contentViewController.view)
        bottomSheetView.addSubview(dragIndicatorView)
        contentViewController.didMove(toParent: self)
        dragIndicatorView.backgroundColor = .black

    }
    
    private func configureLayout() {
        dimmedView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        bottomSheetView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(defaultHeight)
        }
        
        contentViewController.view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        dragIndicatorView.snp.makeConstraints {
            $0.width.equalTo(60)
            $0.height.equalTo(3)
            $0.centerX.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(bottomSheetView.snp.top).offset(12)
        }
    }
    
    private func configureDimmedTapGesture() {
        let dimmedTap = UITapGestureRecognizer(target: self, action: #selector(dimmedViewTapped(_:)))
        dimmedView.addGestureRecognizer(dimmedTap)
        dimmedView.isUserInteractionEnabled = true
    }

}

// MARK: Gesture
extension BottomSheetViewController {
    @objc private func dimmedViewTapped(_ tapRecognizer: UITapGestureRecognizer) {
        self.hideBottomSheetAndGoBack()
    }
    

}

extension BottomSheetViewController {
    private func hideBottomSheetAndGoBack() {
        bottomSheetView.snp.updateConstraints {
            $0.height.equalTo(0)
        }
        
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
            self.dimmedView.alpha = 0.0
            self.view.layoutIfNeeded()
        }) { _ in
            if self.presentingViewController != nil {
                self.dismiss(animated: false, completion: nil)
            }
        }
    }
    
    private func nearest(to number: CGFloat, inValues values: [CGFloat]) -> CGFloat {
        guard let nearestVal = values.min(by: { abs(number - $0) < abs(number - $1) })
        else { return number }
        return nearestVal
    }
    
    private func dimAlphaWithBottomSheetTopConstraint(value: CGFloat) -> CGFloat {
        let fullDimAlpha: CGFloat = self.dimmedAlpha
        let safeAreaHeight = view.safeAreaLayoutGuide.layoutFrame.height
        let bottomPadding = view.safeAreaInsets.bottom
        let fullDimPosition = (safeAreaHeight + bottomPadding - defaultHeight) / 2
        let noDimPosition = safeAreaHeight + bottomPadding
        
        if value < fullDimPosition {
            return fullDimAlpha
        }
        
        if value > noDimPosition {
            return 0.0
        }
        
        return fullDimAlpha * (1 - ((value - fullDimPosition) / (noDimPosition - fullDimPosition)))
    }
}
