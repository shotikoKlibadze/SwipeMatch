//
//  TopNavigationControllsStackView.swift
//  SwipeMatch
//
//  Created by Shotiko Klibadze on 25.01.22.
//

import UIKit

class TopNavigationControllsStackView: UIStackView {
    
    let settingsButton = UIButton(type: .system)
    let messageButton = UIButton(type: .system)
    let fireImageView = UIImageView(image: UIImage(named: "7"))

    override init(frame: CGRect) {
        super.init(frame: frame)
        settingsButton.setImage(UIImage(named: "6")?.withRenderingMode(.alwaysOriginal), for: .normal)
        messageButton.setImage(UIImage(named: "8")?.withRenderingMode(.alwaysOriginal), for: .normal)
        fireImageView.contentMode = .scaleAspectFit
        
        let subviews = [settingsButton,UIView(),fireImageView,UIView(),messageButton]
        subviews.forEach { view in
            addArrangedSubview(view)
        }
        
        
        heightAnchor.constraint(equalToConstant: 80).isActive = true
        distribution = .equalCentering
        
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = .init(top: 0, left: 24, bottom: 0, right: 24)

    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
