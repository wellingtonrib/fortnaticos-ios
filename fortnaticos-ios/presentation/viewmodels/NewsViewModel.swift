//
//  NewsViewModel.swift
//  fortnaticos-ios
//
//  Created by Well on 07/11/20.
//  Copyright © 2020 JWAR. All rights reserved.
//

import Foundation

class NewsViewModel: BaseViewModel {
    
    var news = Observable<Resource<NewsDTO>>()

    func getNews() {
        news.value = .loading(data: nil)
        self.apiManager.request(requestPath: "v2/news/br") { (result: Result<NewsDTO, Error>) in
            
            switch result {
            case .success(let news):
                self.news.value = .success(data: news)
            case .failure( _):
                self.news.value = .error(message: "Não foi possível recuperar as notícias")
            }
        }
    }
}
