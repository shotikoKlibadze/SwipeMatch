//
//  Bindable.swift
//  SwipeMatch
//
//  Created by Shotiko Klibadze on 08.02.22.
//

import Foundation

class Bindable<T> {
  
    var value : T? {
        didSet {
            observer?(value)
        }
    }
    
    var observer : ((T?) -> ())?
    
    func bind(observer: @escaping (T?) -> ()) {
        self.observer = observer
    }
}
