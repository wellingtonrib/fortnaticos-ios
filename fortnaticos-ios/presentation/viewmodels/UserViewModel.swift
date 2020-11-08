//
//  UserViewModel.swift
//  ios-base
//
//  Created by Wellington Ribeiro on 25/03/20.
//  Copyright © 2020 JWAR. All rights reserved.
//

import Foundation
import UIKit

class UserViewModel: BaseViewModel {
    
    var refreshedStats = Observable<Resource<StatsDTO>>()
    
    func refreshStats() {
        refreshedStats.value = .loading(data: self.getCachedUserStats())
        self.getStats { userStats in
            if let userStats = userStats {
                self.refreshedStats.value = .success(data: self.cacheUserStats(user: userStats))
            } else {
                self.refreshedStats.value = .error(message: "Não foi possível atualizar o status do usuário")
            }
        }
    }
    
    func getStats(completion: @escaping (StatsDTO?) -> Void) {
        
        self.apiManager.request(requestPath: "v1/stats/br/v2?name=\(self.getNickname()!)") { (result: Result<StatsDTO, Error>) in
            
            switch result {
            case .success(let user):
                completion(user)
            case .failure( _): 
                completion(nil)
            }
        }
    }
    
    func getNickname() -> String? {
        return self.userDefaultsManager.standard.string(forKey: "nickname") ?? nil
    }
    
    func setNickname(nickname: String) {
        self.userDefaultsManager.standard.set(nickname, forKey: "nickname")
    }
    
    func cacheUserStats(user: StatsDTO) -> StatsDTO {
        self.userDefaultsManager.standard
            .set(value: user, forKey: "userStats")
        return user
    }
    
    func getCachedUserStats() -> StatsDTO? {
        return self.userDefaultsManager.standard
            .decodable(forKey: "userStats")
    }
        
    
}
