//
//  RegistrationViewModel.swift
//  SwipeMatch
//
//  Created by Shotiko Klibadze on 04.02.22.
//

import UIKit
import Firebase
import FirebaseFirestore

class RegistrationViewModel {
    
    var image = Bindable<UIImage>()
    var isFormValidObserver = Bindable<Bool>()
    var isRegistering = Bindable<Bool>()
    
    
    var fullName : String? {didSet {validateState()}}
    var email : String? {didSet {validateState()}}
    var password : String? {didSet {validateState()}}
    
    func validateState() {
        let isFormValid = fullName?.isEmpty == false && email?.isEmpty == false && password?.isEmpty == false
        isFormValidObserver.value = isFormValid
    }
    
    func registerUser(completion: @escaping (Error?) -> () ) {
        isRegistering.value = true
        guard let email = email, let password = password else { return }
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] _ , error in
            if let error = error {
                completion(error)
                return
            }
            self?.uploadProfilePicture { error in
                completion(error)
            }
        }
    }
    
    func uploadProfilePicture(completion: @escaping (Error?) -> () ) {
        let randomID = UUID().uuidString
        let uploadRef = Storage.storage().reference(withPath: "profilePics/\(randomID)/.jpg")
        guard let imageData = image.value?.jpegData(compressionQuality: 0.75) else {
            print("No picture")
            return
        }
        
        let uploadMetaData = StorageMetadata.init()
        uploadMetaData.contentType = "image/jpeg"
        uploadRef.putData(imageData, metadata: uploadMetaData) { [weak self] metaData, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            uploadRef.downloadURL { url, error in
                if let error = error {
                    completion(error)
                }
                if url != nil {
                    self?.isRegistering.value = false
                }
                let imageUrl = url?.absoluteString ?? ""
                self?.saveInfoToFireStore(imageUrl: imageUrl, completion: { error in
                    if let error = error {
                        completion(error)
                    }
                })
                self?.isRegistering.value = false
                completion(nil)
            }
        }
    }
    
    func saveInfoToFireStore(imageUrl: String, completion: @escaping (Error?) -> ()) {
        let uid = Auth.auth().currentUser?.uid ?? ""
        let docData = ["fullName": fullName ?? "", "uid": uid, "photoUrl1": imageUrl]
        Firestore.firestore().collection("users").document(uid).setData(docData) { error in
            if let error = error {
                completion(error)
                return
            }
            completion(nil)
        }
    }
}

