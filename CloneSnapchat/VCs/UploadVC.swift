//
//  UploadVC.swift
//  CloneSnapchat
//
//  Created by Mehmet Ergün on 2022-06-09.
//

import UIKit
import PhotosUI
import Firebase

class UploadVC: UIViewController, PHPickerViewControllerDelegate {

    
    @IBOutlet weak var uploadImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        uploadImageView.backgroundColor = .gray
        
        uploadImageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        uploadImageView.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func chooseImage() {
        
        var config = PHPickerConfiguration()
        config.selectionLimit = 1
        config.filter = .images
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
        
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
       
        
        
        let itemProvider = results.first?.itemProvider
        
        if let itemProvider = itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
            
            itemProvider.loadObject(ofClass: UIImage.self) {image, error in
                if let image = image as? UIImage {
                    
                    DispatchQueue.main.async {
                        self.uploadImageView.image = image
                        picker.dismiss(animated: true,completion: nil)
                    }
                }
            }
            
        }
        
    }

    @IBAction func uploadButton(_ sender: Any) {
        
        //MARK: - Storage
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        
        let mediaFolder = storageRef.child("media")
        
        if let data = uploadImageView.image?.jpegData(compressionQuality: 0.5) {
            
            let uuid = UUID().uuidString
            
            let imageRef = mediaFolder.child("\(uuid).jpg")
            
            imageRef.putData(data, metadata: nil) { metadata, error in
                if error != nil {
                    
                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                    
                }else {
                    
                    imageRef.downloadURL { url, error in
                        if error == nil {
                            
                            let imageUrl = url?.absoluteString
                            
                            //MARK: - Firestore
                            
                            let firestore = Firestore.firestore()
                            
                            firestore.collection("Snaps").whereField("snapOwner", isEqualTo: UserSingleton.sharedUserInfo.username).getDocuments { snapshot, error in
                                
                                if error != nil {
                                    
                                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                                    
                                }else {
                                    
                                    if snapshot?.isEmpty == false && snapshot != nil {
                                        
                                        for document in snapshot!.documents {
                                            
                                            let documentId = document.documentID
                                            
                                            if var imageUrlArray = document.get("imageUrlArray") as? [String] {
                                                
                                                imageUrlArray.append(imageUrl!)
                                                
                                                let additionalArray = ["imageUrlArray": imageUrlArray] as [String : Any]
                                                
                                                firestore.collection("Snaps").document(documentId).setData(additionalArray, merge: true) { error in
                                                    
                                                    if error == nil {
                                                        self.tabBarController?.selectedIndex = 0
                                                    }
                                                }
                                            }
                                        }
                                        
                                    }else {
                                        
                                        let snapDictionary = ["imageUrl": imageUrl!, "snapOwner": UserSingleton.sharedUserInfo.username, "date": FieldValue.serverTimestamp()] as [String : Any]
                                        
                                        firestore.collection("Snaps").addDocument(data: snapDictionary) { error in
                                            
                                            if error != nil {
                                                
                                                self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                                                
                                            }else {
                                                
                                                self.tabBarController?.selectedIndex = 0
                                                
                                            }
                                            
                                        }
                                        
                                    }
                                    
                                }
                            }
                            
                            
                           
                            
                        }
                    }
                    
                }
            }
            
        }
        
    }
    
    func makeAlert(titleInput titleInput: String, messageInput messageInput: String) {

        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)

    }
    
}
