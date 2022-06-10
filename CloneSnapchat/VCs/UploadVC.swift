//
//  UploadVC.swift
//  CloneSnapchat
//
//  Created by Mehmet Ergün on 2022-06-09.
//

import UIKit
import PhotosUI

class UploadVC: UIViewController, PHPickerViewControllerDelegate {

    
    @IBOutlet weak var uploadImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        uploadImageView.backgroundColor = .gray
        
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
            
            itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                if let image = image as? UIImage {
                    
                    self.uploadImageView.image = image
                    
                    picker.dismiss(animated: true,completion: nil)
                }
            }
            
        }
        
    }

    @IBAction func uploadButton(_ sender: Any) {
    }
    
}
