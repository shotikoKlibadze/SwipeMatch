//
//  User.swift
//  SwipeMatch
//
//  Created by Shotiko Klibadze on 26.01.22.
//

import UIKit

struct User : ProducesCardViewModel {
    var name : String
    var profession : String
    var age : Int
    var imageNames : [String]
    
    func toCardViewModel() -> CardViewModel {
        let attribudetText = NSMutableAttributedString(string: name, attributes: [.font: UIFont.systemFont(ofSize: 32, weight: .heavy)])
        attribudetText.append(NSMutableAttributedString(string: " \(age)", attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .regular)]))
        attribudetText.append(NSMutableAttributedString(string: " \n\(profession)", attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .regular)]))
        
        return CardViewModel(imageNames: imageNames, attributedString: attribudetText, textAlignment: .left)
    }
}
