//
//  ViewController.swift
//  SwipeMatch
//
//  Created by Shotiko Klibadze on 25.01.22.
//

import UIKit
import Firebase
class HomeController: UIViewController {
    
    let topStackView = TopNavigationControllsStackView()
    let cardsDeckView = UIView()
    let bottomStackView = HomeBottomControlsStackView()

    var cardViewModels = [CardViewModel]()
     
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayOut()
        setuPDummyCards()
        fetchUsersFromFireStore()
    }
    
    fileprivate func fetchUsersFromFireStore() {
        Firestore.firestore().collection("users").getDocuments { [weak self] snapShot, error in
            if let error = error {
                print("failed to fetch users")
            }
            
            snapShot?.documents.forEach({ [weak self] documentSnapshot in
                let userDictionary = documentSnapshot.data()
                let user = User(dictionary: userDictionary)
                self?.cardViewModels.append(user.toCardViewModel())
            })
            self?.setuPDummyCards()
        }
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
        view.backgroundColor = .white
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

