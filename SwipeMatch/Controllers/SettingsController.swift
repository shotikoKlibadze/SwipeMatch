//
//  SettingsController.swift
//  SwipeMatch
//
//  Created by Shotiko Klibadze on 06.05.22.
//

import UIKit

class SwipeMatchImagePickerController : UIImagePickerController {
    var button : UIButton?
}

class SettingsController: UIViewController {
    
    lazy var image1button = createButton(selector: #selector(handlePhotoSelection))
    lazy var image2button = createButton(selector: #selector(handlePhotoSelection))
    lazy var image3button = createButton(selector: #selector(handlePhotoSelection))
    
    let tableView : UITableView = {
        let table = UITableView()
        table.backgroundColor = .white
        return table
    }()
    
    lazy var headerView : UIView = {
        let headerView = UIView()
        headerView.backgroundColor = .red
        headerView.addSubviews(views:image1button,image2button,image3button)
        let padding : CGFloat = 16
        image1button.anchor(top: headerView.topAnchor, leading: headerView.leadingAnchor, bottom: headerView.bottomAnchor, trailing: nil, padding: .init(top: padding, left: padding, bottom: padding, right: 0))
        image1button.widthAnchor.constraint(equalTo: headerView.widthAnchor, multiplier: 0.45).isActive = true
        let stackView = UIStackView(arrangedSubviews: [image2button, image3button])
        headerView.addSubview(stackView)
        stackView.anchor(top: headerView.topAnchor, leading: image1button.trailingAnchor, bottom: headerView.bottomAnchor, trailing: headerView.trailingAnchor, padding: .init(top: padding, left: padding, bottom: padding, right: padding))
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 16
        return headerView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItems()
        view.backgroundColor = .white
        view.addSubview(tableView)
        tableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        tableView.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func setupNavigationItems() {
        navigationItem.title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleCancel)),
            UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleCancel))]
    }
    
    @objc func handleCancel() {
        dismiss(animated: true)
    }
    
    func createButton(selector: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("Select Photo", for: .normal)
        button.backgroundColor = .white
        button.addTarget(self, action: selector, for: .touchUpInside)
        button.imageView?.contentMode = .scaleAspectFill
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        return button
    }
    
    @objc func handlePhotoSelection(button: UIButton) {
        let imagePicker = SwipeMatchImagePickerController()
        imagePicker.delegate = self
        imagePicker.button = button
        present(imagePicker, animated: true)
    }
   
}

extension SettingsController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headerView
    }
    
     func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 300
    }

     func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
}

extension SettingsController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else { return }
        let imageButton = (picker as? SwipeMatchImagePickerController)?.button
        imageButton?.setImage(selectedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        dismiss(animated: true)
    }
}
