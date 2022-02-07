//
//  Advertiser.swift
//  SwipeMatch
//
//  Created by Shotiko Klibadze on 28.01.22.
//

import UIKit

struct Advertiser : ProducesCardViewModel {
    var title : String
    var brandName : String
    var posterPhotoName : [String]
    
    func toCardViewModel() -> CardViewModel {
        let attribudetText = NSMutableAttributedString(string: title, attributes: [.font: UIFont.systemFont(ofSize: 34, weight: .heavy)])
        attribudetText.append(NSMutableAttributedString(string: " \n\(brandName)", attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .bold)]))
        
        return CardViewModel(imageNames: posterPhotoName, attributedString: attribudetText, textAlignment: .center)
    }
}
