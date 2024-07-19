//
//  TardyViewModel.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/14/24.
//

import Foundation

class TardyViewModel {
    
    
    // MARK: Property

    private let tardyService: TardyServiceType
    let promiseID: Int
    
    var hasTardy: ObservablePattern<Bool> = ObservablePattern<Bool>(false)
    var isPastDue: ObservablePattern<Bool> = ObservablePattern<Bool>(false)
    var penalty: ObservablePattern<String> = ObservablePattern<String>("")
    var comers: ObservablePattern<[Comer]?> = ObservablePattern<[Comer]?>(nil)
    var errorMessage: ObservablePattern<String> = ObservablePattern<String>("")
    
    
    // MARK: Initialize

    init(
        tardyService: TardyServiceType,
        promiseID: Int
    ) {
        self.tardyService = tardyService
        self.promiseID = promiseID
    }
}

extension TardyViewModel {
    func fetchTardyInfo() {
        Task {
            do {
                let responseBody = try await
                tardyService.fetchTardyInfo(with: promiseID)
                
                guard let success = responseBody?.success, success == true
                else {
                    return
                }
                
                guard let data = responseBody?.data else {
                    return
                }
                
                hasTardy.value = data.lateComers.isEmpty
                isPastDue.value = data.isPastDue
                penalty.value = data.penalty
                comers.value = data.lateComers
                
            } catch {
                print(">>>>> \(error.localizedDescription) : \(#function)")
            }
        }
    }
    
    func updatePromiseCompletion() {
        Task {
            do {
                let responseBody = try await tardyService.updatePromiseCompletion(with: promiseID)
                
                guard let success = responseBody?.success,
                      success == true
                else {
                    handleError(errorResponse: responseBody?.error)
                    
                    return
                }
            } catch {
                print(">>>>> \(error.localizedDescription) : \(#function)")
            }
        }
    }
}

private extension TardyViewModel {
    func handleError(errorResponse: ErrorResponse?) {
        guard let error = errorResponse else {
            errorMessage.value = "알 수 없는 에러"
            return
        }
        
        switch error.code {
        case 40051:
            errorMessage.value = "도착하지 않은 참여자가 있습니다."
            
        default:
            errorMessage.value = "알 수 없는 에러"
        }
    }
}
