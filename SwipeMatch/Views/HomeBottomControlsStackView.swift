//
//  HomeBottomControlsStackView.swift
//  SwipeMatch
//
//  Created by Shotiko Klibadze on 25.01.22.
//

import UIKit

class HomeBottomControlsStackView: UIStackView {
   

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let buttons = [UIImage(named: "1"),UIImage(named: "2"),UIImage(named: "3"),UIImage(named: "4"),UIImage(named: "5")].map { img -> UIView in
            let button = UIButton(type: .system)
            button.setImage(img?.withRenderingMode(.alwaysOriginal), for: .normal)
            return button
        }
        buttons.forEach { button in
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
