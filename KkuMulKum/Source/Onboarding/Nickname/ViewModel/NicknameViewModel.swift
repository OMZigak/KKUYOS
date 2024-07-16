//
//  NicknameViewModel.swift
//  KkuMulKum
//
//  Created by 이지훈 on 7/10/24.
//

import Foundation

import Moya

enum NicknameState {
    case empty
    case valid
    case invalid
}

class NicknameViewModel {
    let nickname = ObservablePattern<String>("")
    let nicknameState = ObservablePattern<NicknameState>(.empty)
    let errorMessage = ObservablePattern<String?>(nil)
    let isNextButtonEnabled = ObservablePattern<Bool>(false)
    let characterCount = ObservablePattern<String>("0/5")
    
    private let nicknameRegex = "^[가-힣a-zA-Z0-9]{1,5}$"
    private let provider = MoyaProvider<NicknameTargetType>()
    let serverResponse = ObservablePattern<String?>(nil)
    
    private let authService: AuthServiceType
    
    init(authService: AuthServiceType = AuthService()) {
        self.authService = authService
    }
    
    func validateNickname(_ name: String) {
        nickname.value = name
        characterCount.value = "\(name.count)/5"
        
        if name.isEmpty {
            nicknameState.value = .empty
            errorMessage.value = nil
            isNextButtonEnabled.value = false
        } else if name.range(of: nicknameRegex, options: .regularExpression) != nil {
            nicknameState.value = .valid
            errorMessage.value = nil
            isNextButtonEnabled.value = true
        } else {
            nicknameState.value = .invalid
            errorMessage.value = "한글, 영문, 숫자만을 사용해 총 5자 이내로 입력해주세요."
            isNextButtonEnabled.value = false
        }
    }
    
    func updateNickname(completion: @escaping (Bool) -> Void) {
        guard nicknameState.value == .valid else {
            completion(false)
            return
        }
        
        guard let accessToken = authService.getAccessToken() else {
            print("No access token available")
            completion(false)
            return
        }
        
        print("닉네임 업데이트 요청 시작: \(nickname.value)")
        
        let headers = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        
        print("요청 헤더: \(headers)")
        print("요청 바디: \(["name": nickname.value])")
        
        provider.request(.updateName(name: nickname.value)) { [weak self] result in
            switch result {
            case .success(let response):
                print("서버 응답: \(String(data: response.data, encoding: .utf8) ?? "Unable to decode response")")
                do {
                    let decodedResponse = try JSONDecoder().decode(ResponseBodyDTO<NameResponseModel>.self, from: response.data)
                    if decodedResponse.success {
                        self?.serverResponse.value = "닉네임이 성공적으로 업데이트되었습니다."
                        print("닉네임 업데이트 성공: \(self?.nickname.value ?? "")")
                        completion(true)
                    } else {
                        if let errorCode = decodedResponse.error?.code {
                            switch errorCode {
                            case 40420:
                                self?.serverResponse.value = "사용자를 찾을 수 없습니다."
                            default:
                                self?.serverResponse.value = decodedResponse.error?.message ?? "알 수 없는 오류가 발생했습니다."
                            }
                        } else {
                            self?.serverResponse.value = decodedResponse.error?.message ?? "알 수 없는 오류가 발생했습니다."
                        }
                        print("닉네임 업데이트 실패: \(self?.serverResponse.value ?? "알 수 없는 오류")")
                        completion(false)
                    }
                } catch {
                    self?.serverResponse.value = "데이터 디코딩 중 오류가 발생했습니다."
                    print("닉네임 업데이트 실패: 데이터 디코딩 오류 - \(error)")
                    completion(false)
                }
            case .failure(let error):
                self?.serverResponse.value = "네트워크 오류: \(error.localizedDescription)"
                print("닉네임 업데이트 실패: 네트워크 오류 - \(error.localizedDescription)")
                completion(false)
            }
        }
    }
    
}
