//
//  CustomActionSheetController.swift
//  KkuMulKum
//
//  Created by 김진웅 on 8/17/24.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

protocol CustomActionSheetDelegate: AnyObject {
    /// CustomActionSheetController의 ActionButton이 눌렸을 때, 어떤 작업을 할 지 정의합니다.
    func actionButtonDidTap()
}

final class CustomActionSheetController: BaseViewController {
    private let contentView = UIView(backgroundColor: .white).then {
        $0.layer.cornerRadius = 12
    }
    
    private let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
    }
    
    private let titleLabel = UILabel().then {
        $0.setText(style: .body01, color: .gray8)
        $0.textAlignment = .center
    }
    
    private let descriptionLabel = UILabel().then {
        $0.setText(style: .body06)
        $0.textAlignment = .center
    }
    
    private let labelStackView = UIStackView(axis: .vertical).then {
        $0.spacing = 12
    }
    
    private let actionButton = UIButton().then {
        $0.setTitle("", style: .body04, color: .gray8)
        $0.backgroundColor = .gray1
        $0.layer.cornerRadius = 8
    }
    
    private let cancelButton = UIButton().then {
        $0.setTitle("취소", style: .body03, color: .white)
        $0.backgroundColor = .gray7
        $0.layer.cornerRadius = 8
    }
    
    private let buttonStackView = UIStackView(axis: .horizontal).then {
        $0.spacing = 6
        $0.distribution = .fillEqually
    }
    
    
    // MARK: - Property

    weak var delegate: CustomActionSheetDelegate?
    
    private let kind: ActionSheetKind
    private let disposeBag = DisposeBag()
    
    
    // MARK: - Initializer

    init(kind: ActionSheetKind) {
        self.kind = kind
        super.init(nibName: nil, bundle: nil)
        
        setupModalStyle()
    }
    
    required init?(coder: NSCoder) {
        self.kind = .logout
        super.init(coder: coder)
        
        setupModalStyle()
    }
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAutoLayout()
    }

    override func setupView() {
        titleLabel.updateText(kind.title)
        
        descriptionLabel.updateText(kind.description)
        descriptionLabel.textColor = kind.descriptionColor
        
        actionButton.setTitle(kind.actionButtonTitle, style: .body04, color: .gray8)
        
        imageView.image = kind.image
        imageView.isHidden = kind.image == nil
        
        labelStackView.addArrangedSubviews(titleLabel, descriptionLabel)
        buttonStackView.addArrangedSubviews(actionButton, cancelButton)
        contentView.addSubviews(imageView, labelStackView, buttonStackView)
        
        view.addSubview(contentView)
        view.backgroundColor = .black.withAlphaComponent(0.6)
    }
    
    override func setupAction() {
        actionButton.rx.tap
            .subscribe(with: self) { owner, _ in
                owner.delegate?.actionButtonDidTap()
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        
        cancelButton.rx.tap
            .subscribe(with: self) { owner, _ in
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
    }
}


// MARK: - ActionSheetKind

extension CustomActionSheetController {
    enum ActionSheetKind {
        case exitMeeting
        case exitPromise
        case deletePromise
        case logout
        case unsubscribe
        
        var image: UIImage? {
            switch self {
            case .exitMeeting:
                    .imgExitMeeting
            case .exitPromise:
                    .imgExitPromise
            case .deletePromise:
                    .imgDeletePromise
            case .logout, .unsubscribe:
                nil
            }
        }
        
        var imageHeight: CGFloat {
            switch self {
            case .exitMeeting:
                Screen.height(90)
            case .exitPromise, .deletePromise:
                Screen.height(86)
            case .logout, .unsubscribe:
                0
            }
        }
        
        var title: String {
            switch self {
            case .exitMeeting:
                "모임에서 나가시겠어요?"
            case .exitPromise:
                "약속에서 나가시겠어요?"
            case .deletePromise:
                "정말 약속을 삭제하시겠어요?"
            case .logout:
                "로그아웃 하시겠어요?"
            case .unsubscribe:
                "정말 탈퇴 하시겠어요?"
            }
        }
        
        var description: String {
            switch self {
            case .exitMeeting:
                "모임에서 나가도\n초대 코드를 통해 다시 들어올 수 있어요."
            case .exitPromise:
                "약속에서 나가도\n참여 인원 추가를 통해 다시 참여 가능해요."
            case .deletePromise:
                "약속을 삭제하면 해당 약속이\n모든 참여 인원의 약속 목록에서 사라져요."
            case .logout:
                "로그아웃 시, 다시 로그인 하셔야 해요."
            case .unsubscribe:
                "탈퇴 버튼 선택시,\n계정은 삭제되며 복구되지 않습니다."
            }
        }
        
        var descriptionColor: UIColor {
            switch self {
            case .exitMeeting, .exitPromise, .logout:
                    .gray6
            case .deletePromise, .unsubscribe:
                    .red
            }
        }
        
        var actionButtonTitle: String {
            switch self {
            case .exitMeeting, .exitPromise:
                "나가기"
            case .deletePromise:
                "삭제하기"
            case .logout:
                "로그아웃"
            case .unsubscribe:
                "탈퇴하기"
            }
        }
    }
}

private extension CustomActionSheetController {
     func setupModalStyle() {
        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .overCurrentContext
    }
    
    func setupAutoLayout() {
        contentView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        actionButton.snp.makeConstraints {
            $0.width.equalTo(Screen.width(138))
        }
        
        buttonStackView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(12)
            $0.bottom.equalToSuperview().offset(-12)
            $0.height.equalTo(Screen.height(50))
        }
        
        labelStackView.snp.makeConstraints {
            $0.bottom.equalTo(buttonStackView.snp.top).offset(-36)
            $0.centerX.equalToSuperview()
        }
        
        imageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(imageView.isHidden ? 0 : 40)
            $0.bottom.equalTo(labelStackView.snp.top).offset(-32)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(kind.imageHeight)
        }
    }
}
