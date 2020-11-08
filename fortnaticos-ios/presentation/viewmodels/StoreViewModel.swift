//
//  StoreViewModel.swift
//  fortnaticos-ios
//
//  Created by Well on 04/11/20.
//  Copyright © 2020 JWAR. All rights reserved.
//

import Foundation

class StoreViewModel: BaseViewModel {

    var store = Observable<Resource<StoreDTO>>()

    func getStore() {
        store.value = .loading(data: nil)
        self.apiManager.request(requestPath: "v2/shop/br?language=pt-BR") { (result: Result<StoreDTO, Error>) in
            
            switch result {
            case .success(let store):
                self.store.value = .success(data: store)
            case .failure( _):
                self.store.value = .error(message: "Não foi possível recuperar a loja")
            }
        }
    }
    
}
