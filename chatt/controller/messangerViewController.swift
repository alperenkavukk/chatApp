//
//  messangerViewController.swift
//  chatt
//
//  Created by Alperen Kavuk on 18.04.2023.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import SDWebImage
class messangerViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var imageArray = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        getDataFromFirestore()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messangerTableViewCell", for: indexPath) as! messangerTableViewCell
        cell.nameLabel.text = "Alperen"
        if imageArray.isEmpty {
            cell.imagePerson.image = UIImage(named: "profil")
        } else {
            if let url = URL(string: imageArray[indexPath.row]) {
                cell.imagePerson.sd_setImage(with: url) { (image, error, cacheType, url) in
                    if let error = error {
                        print("Error loading image: \(error.localizedDescription)")
                    }
                }
            } else {
                print("Invalid URL")
            }
        }
        
        return cell
    }
    
    public func getDataFromFirestore(){
        let db = Firestore.firestore()
        let userRef = db.collection("Posts")
        let query = userRef.whereField("postedBy", in: [Auth.auth().currentUser?.email!])
        query.addSnapshotListener {  snapshot, error in
            if error != nil
            {
                print("error11")
            }
            else
            {
                if snapshot?.isEmpty != true && snapshot != nil
                {
                    
                    for document in  snapshot!.documents {
                        
                        let documentId = document.documentID
                        let data = document.data()
                        let imgurl = data["imageUrl"] as? String ?? ""
                        //  self.imageView.sd_setImage(with: URL(string: imgurl))
                        self.imageArray.append(imgurl)
                        print(self.imageArray)
                        
                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    print(self.imageArray)
                    
                    
                    
                }
                print(self.imageArray)

                
            }
            
        }
        
        print(self.imageArray)

    }
}
