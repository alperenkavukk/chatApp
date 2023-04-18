//
//  ViewController.swift
//  chatt
//
//  Created by Alperen Kavuk on 17.04.2023.
//

import UIKit
import FirebaseAuth
class ViewController: UIViewController {

    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func registerButtonClicked(_ sender: Any) {
        performSegue(withIdentifier: "toSignUp", sender: nil)
    }
    @IBAction func loginbuttonClicked(_ sender: Any) {
        if emailTextField.text != "" && passwordText.text != "" {
                 Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordText.text!){
                     authdata , error in
                     if error != nil {
                         let errorMessage = error?.localizedDescription
                         self.makeAlert(titleInput: "Error!", messageInput:errorMessage ?? "")
                     }else{
                         
                         self.performSegue(withIdentifier: "totabBar", sender: nil)
                 }
                 
             }
         }
             else {
                 self.makeAlert(titleInput: "EROR", messageInput: "USERNAME/PASSWORD NOT Found")
             }
        
    }
    func makeAlert(titleInput: String, messageInput: String) {
            let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: .alert)
            let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okButton)
            self.present(alert, animated: true, completion: nil)
        }
}

