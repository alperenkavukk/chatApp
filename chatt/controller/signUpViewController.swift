//
//  signUpViewController.swift
//  chatt
//
//  Created by Alperen Kavuk on 17.04.2023.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore
import FirebaseCore

class signUpViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FirebaseApp.configure()
        imageView.isUserInteractionEnabled = true
                let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
                imageView.addGestureRecognizer(gestureRecognizer)
    }
    
    
       @objc func chooseImage(){
           let pickercontroller = UIImagePickerController()
           pickercontroller.delegate = self
           pickercontroller.sourceType = .photoLibrary
           present(pickercontroller , animated: true,completion: nil)
           
       }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
           imageView.image = info[.originalImage] as? UIImage
           self.dismiss(animated: true, completion: nil)
       }
    @IBAction func signUpButton(_ sender: Any) {
        guard let email = emailText.text, let password = passwordText.text, let username = userNameTextField.text else {
                  return
              }
              
              
              Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                  if error == nil {
                      
                      let db = Firestore.firestore()
                      db.collection("users").document(result!.user.uid).setData(["username": username])
                      
                      self.performSegue(withIdentifier: "totabBarvc", sender: self)
                  } else {
                      
                      let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                      let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                      alertController.addAction(alertAction)
                      self.present(alertController, animated: true, completion: nil)
                  }
              }
              let storage = Storage.storage()
                   let storageReference = storage.reference()
                   
                   let mediaFolder = storageReference.child("media")
                   
                   
                   if let data = imageView.image?.jpegData(compressionQuality: 0.5) {
                       
                       let uuid = UUID().uuidString
                       
                       let imageReference = mediaFolder.child("\(uuid).jpg")
                       imageReference.putData(data, metadata: nil) { (metadata, error) in
                           if error != nil {
                               self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Error")
                           } else {
                               
                               imageReference.downloadURL { (url, error) in
                                   
                                   if error == nil {
                                       
                                       let imageUrl = url?.absoluteString
                                       
                                       
                                       //DATABASE
                                       
                                       let firestoreDatabase = Firestore.firestore()
                                       
                                       var firestoreReference : DocumentReference? = nil
                                       
                                       let firestorePost = ["imageUrl" : imageUrl!, "postedBy" : Auth.auth().currentUser!.email! ] as [String : Any]

                                       firestoreReference = firestoreDatabase.collection("Posts").addDocument(data: firestorePost, completion: { (error) in
                                           if error != nil {
                                               
                                               self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Error")
                                               
                                           } else {
                                             print("error")
                                           }
                                       })
                                       
                                       
                                       
                                   }
                                   
                                   
                               }
                               
                           }
                       }
                       
                       
                   }
                   
              
          }
          
          func makeAlert(titleInput: String, messageInput: String) {
                  let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
                  let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                  alert.addAction(okButton)
                  self.present(alert, animated: true, completion: nil)
              }
              
    }
    
