//
//  CardView.swift
//  SwipeMatch
//
//  Created by Shotiko Klibadze on 26.01.22.
//

import UIKit

class CardView: UIView {

    private let imageView = UIImageView()
    private let gradientLayer = CAGradientLayer()
    private let informationLabel = UILabel()
    private let barStackView = UIStackView()
    private var imageIndex = 0
    private let deselectedColor = UIColor(white: 0, alpha: 0.1)
    
    var cardViewModel : CardViewModel! {
        didSet {
            let imageName = cardViewModel.imageNames.first ?? ""
            imageView.image = UIImage(named: imageName)
            informationLabel.attributedText = cardViewModel.attributedString
            informationLabel.textAlignment = cardViewModel.textAlignment
            if cardViewModel.imageNames.count <= 1 {
                barStackView.isHidden = true
            }
            (0..<cardViewModel.imageNames.count).forEach { _ in
                let view = UIView()
                view.backgroundColor = deselectedColor
                barStackView.addArrangedSubview(view)
            }
            barStackView.arrangedSubviews.first?.backgroundColor = .white
            setUpPhoto()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayOut()
        
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        addGestureRecognizer(gesture)
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    fileprivate func setupLayOut() {
        layer.cornerRadius = 10
        clipsToBounds = true
        addSubview(imageView)
        imageView.fillSuperview()
        
        setupGradientLayer()
        setupBarStackView()
        
        addSubview(informationLabel)
        informationLabel.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 16, bottom: 16, right: 16))
        informationLabel.numberOfLines = 0
        informationLabel.textColor = .white
    }
    
    override func layoutSubviews() {
        gradientLayer.frame = self.frame
    }
    
    func setUpPhoto() {
        cardViewModel.imageIndexObserver = { [weak self] indx, image in
            guard let self = self else {return}
            self.imageView.image = image
            self.barStackView.arrangedSubviews.forEach { view in
                view.backgroundColor = self.deselectedColor
            }
            self.barStackView.arrangedSubviews[indx].backgroundColor = .white
        }
    }
    
    func setupBarStackView() {
        addSubview(barStackView)
        barStackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 8, left: 8, bottom: 0, right: 8), size: .init(width: 0, height: 4))
        barStackView.distribution = .fillEqually
        barStackView.spacing = 4
    }
    
    
    func setupGradientLayer() {
        gradientLayer.colors = [UIColor.clear.cgColor,UIColor.black.cgColor]
        gradientLayer.locations = [0.5 , 1.1]
        layer.addSublayer(gradientLayer)
    }
    
    @objc func handleTap(gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: nil)
        let shoudMoveToNextPhoto = location.x > frame.width / 2 ? true : false
        if shoudMoveToNextPhoto {
            cardViewModel.showNextPhoto()
        } else {
            cardViewModel.showPreviousPhoto()
        }
    }
    
    @objc func handlePan(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began:
            superview?.subviews.forEach({ view in
                view.layer.removeAllAnimations()
            })
        case .changed:
            handleChange(gesture)
        case .ended:
            handleEnded(gesture)
        @unknown default:
            ()
        }
    }
    
    fileprivate func handleChange(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: nil)
        //Converting radians to degrees
        let degrees : CGFloat = translation.x / 20 // << deviding makes it appear slower
        let angle = degrees * .pi / 180 //<< this makes it a degree
        let rotationalTransformation = CGAffineTransform(rotationAngle: angle)
        self.transform = rotationalTransformation.translatedBy(x: translation.x, y: translation.y)
    }
    
    fileprivate func handleEnded(_ gesture: UIPanGestureRecognizer) {
        let threshold : CGFloat = 120
//        let translationDirection: CGFloat = gesture.translation(in: nil).x > 0 ? 1 : -1
        let shouldDismissCard = abs(gesture.translation(in: nil).x) > threshold
        print(gesture.translation(in: nil).x)
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
            if shouldDismissCard {
//               self.frame = CGRect(x: 600 * translationDirection, y: 0, width: self.frame.width, height: self.frame.height)
                self.removeFromSuperview()
            } else {
                self.transform = .identity
            }
        }) { (_) in
            if shouldDismissCard {
                self.removeFromSuperview()
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
