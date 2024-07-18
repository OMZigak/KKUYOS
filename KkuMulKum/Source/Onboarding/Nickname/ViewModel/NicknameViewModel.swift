//
//  NicknameViewModel.swift
//  KkuMulKum
//
//  Created by 이지훈 on 7/10/24.
//

import Foundation

import RxSwift
import RxCocoa
import Moya

enum NicknameState {
    case empty
    case valid
    case invalid
}

class NicknameViewModel {
    let nicknameText = BehaviorRelay<String>(value: "")
    let updateNicknameTrigger = PublishSubject<Void>()
    
    let nicknameState: BehaviorRelay<NicknameState>
    let errorMessage: Observable<String?>
    let isNextButtonEnabled: Observable<Bool>
    let isNextButtonValid: Observable<Bool>
    let characterCount: Observable<String>
    let serverResponse = PublishSubject<String?>()
    let nicknameUpdateSuccess = PublishSubject<String>()
    
    private let disposeBag = DisposeBag()
    private let nicknameRegex = "^[가-힣a-zA-Z]{1,5}$"
    private let provider: MoyaProvider<AuthTargetType>
    private let authService: AuthServiceType
    
    init(provider: MoyaProvider<AuthTargetType> = MoyaProvider<AuthTargetType>(),
         authService: AuthServiceType = AuthService()) {
        self.provider = provider
        self.authService = authService
        
        nicknameState = BehaviorRelay<NicknameState>(value: .empty)
        
        errorMessage = nicknameState
            .map { state in
                state == .invalid ? "한글, 영문만을 사용해 총 5자 이내로 입력해주세요." : nil
            }
        isNextButtonEnabled = nicknameState.map { $0 == .valid }
        isNextButtonValid = nicknameState.map { $0 == .valid }

        characterCount = nicknameText.map { "\($0.count)/5" }
        
        setupBindings()
    }
    
    private func setupBindings() {
        nicknameText
            .map { [weak self] text in
                guard let self = self else { return .empty }
                if text.isEmpty { return .empty }
                return text.range(of: self.nicknameRegex, options: .regularExpression) != nil ? .valid : .invalid
            }
            .bind(to: nicknameState)
            .disposed(by: disposeBag)

        updateNicknameTrigger
            .withLatestFrom(nicknameText)
            .flatMapLatest { [weak self] nickname -> Observable<Result<ResponseBodyDTO<NameResponseModel>, Error>> in
                guard let self = self else { return .empty() }
                return self.updateNickname(nickname: nickname)
            }
            .subscribe(onNext: { [weak self] result in
                switch result {
                case .success(let response):
                    if response.success {
                        self?.serverResponse.onNext("닉네임이 성공적으로 업데이트되었습니다.")
                        self?.nicknameUpdateSuccess.onNext(self?.nicknameText.value ?? "")
                    } else {
                        self?.serverResponse.onNext(response.error?.message ?? "알 수 없는 오류가 발생했습니다.")
                    }
                case .failure(let error):
                    self?.serverResponse.onNext("네트워크 오류: \(error.localizedDescription)")
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func updateNickname(nickname: String) -> Observable<Result<ResponseBodyDTO<NameResponseModel>, Error>> {
        return Observable.create { [weak self] observer in
            guard let self = self, let _ = self.authService.getAccessToken() else {
                observer.onNext(.failure(NSError(domain: "No access token available", code: 0, userInfo: nil)))
                observer.onCompleted()
                return Disposables.create()
            }
            self.provider.request(.updateName(name: nickname)) { result in
                switch result {
                case .success(let response):
                    do {
                        let decodedResponse = try JSONDecoder().decode(ResponseBodyDTO<NameResponseModel>.self, from: response.data)
                        observer.onNext(.success(decodedResponse))
                    } catch {
                        observer.onNext(.failure(error))
                    }
                case .failure(let error):
                    observer.onNext(.failure(error))
                }
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
}
