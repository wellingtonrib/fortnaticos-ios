//
//  Resource.swift
//  ios-base
//
//  Created by Wellington Ribeiro on 30/03/20.
//  Copyright © 2020 JWAR. All rights reserved.
//

import Foundation

enum Status {
    case LOADING
    case SUCCESS
    case ERROR
}

class Resource<T> {
    var status: Status
    var data: T? = nil
    var message: String? = nil
    
    init(status: Status, data: T? = nil, message: String? = nil) {
        self.status = status
        self.data = data
        self.message = message
    }
    
    static func loading(data: T? = nil) -> Resource {
        return Resource(status: .LOADING, data: data)
    }
    
    static func success(data: T) -> Resource {
        return Resource(status: .SUCCESS, data: data)
    }
    
    static func error(data: T? = nil, message: String) -> Resource {
        return Resource(status: .ERROR, message: message)
    }
}
