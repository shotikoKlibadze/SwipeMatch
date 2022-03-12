//
//  User.swift
//  SwipeMatch
//
//  Created by Shotiko Klibadze on 26.01.22.
//

import UIKit

struct User : ProducesCardViewModel {
    var name : String?
    var profession : String?
    var age : Int?
    var imageUrl : String?
    var id : String?
    
    init(dictionary: [String: Any]) {
        self.name = dictionary["fullName"] as? String
        self.age = dictionary["age"] as? Int
        self.profession =  dictionary["profession"] as? String
        self.imageUrl = dictionary["photoUrl1"] as? String
        self.id = dictionary["uid"] as? String
        
    }
    
    func toCardViewModel() -> CardViewModel {
        let attribudetText = NSMutableAttributedString(string: name ?? "" , attributes: [.font: UIFont.systemFont(ofSize: 32, weight: .heavy)])
        let ageString = age != nil ? "\(age!)" : "N\\A"
        attribudetText.append(NSMutableAttributedString(string: " \(ageString)", attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .regular)]))
        
        let professionString = profession != nil ?  profession! : "Not available"
        
        attribudetText.append(NSMutableAttributedString(string: " \n\(professionString)", attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .regular)]))
        
        return CardViewModel(imageNames: [imageUrl ?? "" ] , attributedString: attribudetText, textAlignment: .left)
    }
}
