//
//  ViewController.swift
//  SwipeMatch
//
//  Created by Shotiko Klibadze on 25.01.22.
//

import UIKit
import Firebase
import JGProgressHUD
class HomeController: UIViewController {
    
    let topStackView = TopNavigationControllsStackView()
    let cardsDeckView = UIView()
    let bottomControls = HomeBottomControlsStackView()

    var cardViewModels = [CardViewModel]()
    private var lastUser : User?
     
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayOut()
        setuPDummyCards()
        fetchUsersFromFireStore()
        bottomControls.refreshButton.addTarget(self, action: #selector(refetchUsers), for: .touchUpInside)
        topStackView.settingsButton.addTarget(self, action: #selector(settingsTapped), for: .touchUpInside)
        
        
    }
    
    @objc func settingsTapped() {
        let vc = SettingsController()
        let navController = UINavigationController(rootViewController: vc)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true)
    }
    
   
    
    @objc func refetchUsers(){
        fetchUsersFromFireStore()
    }
    
    fileprivate func fetchUsersFromFireStore() {
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Fetching Users"
        hud.show(in: view)
        let query =  Firestore.firestore().collection("users").order(by: "uid").start(after: [lastUser?.id ?? ""]).limit(to: 2)
        query.getDocuments { [weak self] snapShot, error in
            hud.dismiss(animated: true)
            if let _ = error {
                print("failed to fetch users")
            }
            snapShot?.documents.forEach({ [weak self] documentSnapshot in
                let userDictionary = documentSnapshot.data()
                let user = User(dictionary: userDictionary)
                self?.cardViewModels.append(user.toCardViewModel())
                self?.lastUser = user
                self?.setUpCardFromUser(user: user)
            })
            
        }
    }
    
    fileprivate func setUpCardFromUser(user: User) {
        let cardView = CardView()
        cardView.cardViewModel = user.toCardViewModel()
        cardsDeckView.addSubview(cardView)
        cardsDeckView.sendSubviewToBack(cardView)
        cardView.fillSuperview()
    }
    
    fileprivate func setuPDummyCards() {
        cardViewModels.forEach { cardVM in
           
        }
    }
    
    fileprivate func setupLayOut() {
        view.backgroundColor = .white
        let mainStackView = UIStackView(arrangedSubviews: [topStackView,cardsDeckView,bottomControls])
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

