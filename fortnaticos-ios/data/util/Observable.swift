//
//  Observable.swift
//  ios-base
//
//  Created by Wellington Ribeiro on 30/03/20.
//  Copyright © 2020 JWAR. All rights reserved.
//

import Foundation

class Observable<T> {
    
    typealias Listener = (T) -> Void
    
    var listener: Listener?
    
    private let thread : DispatchQueue
    
    func observe(_ listener: Listener?) {
        self.listener = listener
        self.fire()
    }
    
    func fire() {
        if let value = self.value {
            thread.async {
                self.listener?(value)
            }
        }
    }
        
    var value: T? {
        didSet {
            self.fire()
        }
    }
    
    init(_ v: T? = nil, thread dispatcherThread: DispatchQueue = .main) {
        value = v
        thread = dispatcherThread
    }
}
