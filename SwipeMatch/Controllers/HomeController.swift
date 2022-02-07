//
//  ViewController.swift
//  SwipeMatch
//
//  Created by Shotiko Klibadze on 25.01.22.
//

import UIKit

class HomeController: UIViewController {
    
    let topStackView = TopNavigationControllsStackView()
    let cardsDeckView = UIView()
    let bottomStackView = HomeBottomControlsStackView()

    var cardViewModels = ([
        User(name: "Name 1", profession: "Profession 1", age: 20, imageNames: ["jane1","jane2","jane3"]),
        User(name: "Name 2", profession: "Profession 2", age: 21, imageNames: ["kelly1","kelly2","kelly3"]),
        Advertiser(title: "Slide Out Menu", brandName: "Let's build that app", posterPhotoName: ["addvertisement"])
    ] as! [ProducesCardViewModel]).map { producer -> CardViewModel in
        return producer.toCardViewModel()
    }

  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayOut()
        setuPDummyCards()
    }
    
    fileprivate func setuPDummyCards() {
        cardViewModels.forEach { cardVM in
            let cardView = CardView()
            cardView.cardViewModel = cardVM
            cardsDeckView.addSubview(cardView)
            cardView.fillSuperview()
        }
    }
    
    fileprivate func setupLayOut() {
        let mainStackView = UIStackView(arrangedSubviews: [topStackView,cardsDeckView,bottomStackView])
        view.addSubview(mainStackView)
        mainStackView.axis = .vertical
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
        mainStackView.isLayoutMarginsRelativeArrangement = true
        mainStackView.layoutMargins = .init(top: 0, left: 10, bottom: 0, right: 10)
        
        // Function to move the card view to cover other stacks
        mainStackView.bringSubviewToFront(cardsDeckView)
        
    }


}

