//
//  ViewController.swift
//  CloneSnapchat
//
//  Created by Mehmet Ergün on 9.06.2022.
//

import UIKit
import Firebase

class SignInVC: UIViewController {
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var userNameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func signInButton(_ sender: Any) {
        
        if emailText.text != "" && passwordText.text != "" {
            
            Auth.auth().signIn(withEmail: emailText.text!, password: passwordText.text!) { result, error in
                if error != nil {
                    
                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "")
                    
                }else {
                    
                    
                    
                    let fireStore = Firestore.firestore()
                    
                    let userDictionary = ["email": self.emailText.text!, "username": self.userNameText.text!] as? [String : Any]
                    
                    fireStore.collection("userInfo").addDocument(data: userDictionary!) { error in
                        if error != nil {
                        
                            //
                        
                        }
                    }
                    self.performSegue(withIdentifier: "toTabBar", sender: nil)
                }
            }
        }else {
            self.makeAlert(titleInput: "Error", messageInput: "Username/ Email/ Password ??")
        }
    }
    
    @IBAction func signUpButton(_ sender: Any) {
       
        if emailText.text != "" && passwordText.text != "" && userNameText.text != "" {
            
            Auth.auth().createUser(withEmail: emailText.text!, password: passwordText.text!) { authData, error in
                
                if error != nil {
                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                }else {
                    self.performSegue(withIdentifier: "toTabBar", sender: nil)
                }
            }
        }else {
            makeAlert(titleInput: "Error", messageInput: "Username/Password/Email ??")
        }
    }
    
    func makeAlert(titleInput: String, messageInput: String) {
        
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
        
    }
    
}

