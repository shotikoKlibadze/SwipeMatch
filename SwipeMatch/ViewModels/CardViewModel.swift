//
//  CardViewModel.swift
//  SwipeMatch
//
//  Created by Shotiko Klibadze on 28.01.22.
//

import UIKit

protocol ProducesCardViewModel {
    func toCardViewModel() -> CardViewModel
}

class CardViewModel {
    
    let imageNames : [String]
    let attributedString : NSAttributedString
    let textAlignment : NSTextAlignment
    var imageIndex = 0 {
        didSet {
            let imageUrl = imageNames[imageIndex]
            
            imageIndexObserver?(imageIndex,imageUrl)
        }
    }
    
    var imageIndexObserver: ((Int, String) -> ())?
    
    init(imageNames: [String], attributedString: NSAttributedString, textAlignment: NSTextAlignment) {
        self.imageNames = imageNames
        self.attributedString = attributedString
        self.textAlignment = textAlignment
    }

    func showNextPhoto() {
        imageIndex = min(imageIndex + 1, imageNames.count - 1)
    }
    
    func showPreviousPhoto() {
        imageIndex = max(0, imageIndex - 1)
    }
    
    
}
