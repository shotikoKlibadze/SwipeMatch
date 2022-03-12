//
//  HomeBottomControlsStackView.swift
//  SwipeMatch
//
//  Created by Shotiko Klibadze on 25.01.22.
//

import UIKit

class HomeBottomControlsStackView: UIStackView {
   
    static func createButton(image: String) -> UIButton {
        let button = UIButton()
        button.setImage(UIImage(named: image)?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }
    
    
    let refreshButton = createButton(image: "1")
    let dislikeButton = createButton(image: "2")
    let starButton = createButton(image: "3")
    let likeButton = createButton(image: "4")
    let boostButton = createButton(image: "5")

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        [refreshButton, dislikeButton, starButton, likeButton, boostButton].forEach { button in
            addArrangedSubview(button)
        }
        heightAnchor.constraint(equalToConstant: 100).isActive = true
        distribution = .fillEqually
        isLayoutMarginsRelativeArrangement = true
        
        layoutMargins = .init(top: 10, left: 0, bottom: 10, right: 0)
        

    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
