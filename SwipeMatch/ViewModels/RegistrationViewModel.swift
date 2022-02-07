//
//  RegistrationViewModel.swift
//  SwipeMatch
//
//  Created by Shotiko Klibadze on 04.02.22.
//

import UIKit

class RegistrationViewModel {
    
    var fullName : String? {didSet {validateState()}}
    var email : String? {didSet {validateState()}}
    var password : String? {didSet {validateState()}}
    
    func validateState() {
        let isFormValid = fullName?.isEmpty == false && email?.isEmpty == false && password?.isEmpty == false
        isFormValidObserver?(isFormValid)
    }
    
    var isFormValidObserver: ((Bool) -> ())?
    
}

