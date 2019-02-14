//
//  ProfileViewController.swift
//  Tindoggo
//
//  Created by Juan Pablo Martinez Ruiz on 22/11/18.
//  Copyright © 2018 Juan Pablo Martinez Ruiz. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    var usuario: Usuario?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.profileImage.layer.cornerRadius = self.profileImage.bounds.size.height / 2
        self.profileImage.layer.borderColor = UIColor.white.cgColor
        self.profileImage.layer.borderWidth = 1.0
        self.profileImage.clipsToBounds = true
        
        self.emailLabel.text = self.usuario?.email
        self.usernameLabel.text = self.usuario?.username
        self.profileImage.sd_setImage(with: URL(string: (self.usuario?.imagen)!), completed: nil)
    }
    
    @IBAction func logOut(_ sender: UIButton) {
        try! Auth.auth().signOut()
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func addUsers(_ sender: UIButton) {
        let users  = [["email": "bruno@asd.com", "password": "123456", "displayName": "Bruno", "photoURL":"https://i.imgur.com/YYqOgZB.jpg"],
                      ["email": "bublie@asd.com", "password": "123456", "displayName": "Bublie", "photoURL":"https://i.imgur.com/rmBXzbv.jpg"],
                      ["email": "buddy@asd.com", "password": "123456", "displayName": "Buddy", "photoURL":"https://i.imgur.com/piEDB2T.jpg"],
                      ["email": "boss@asd.com", "password": "123456", "displayName": "Boss", "photoURL":"https://i.imgur.com/gCclkXK.jpg"],
                      ["email": "chipotle@asd.com", "password": "123456", "displayName": "Chipotle", "photoURL":"https://i.imgur.com/ocNYvgJ.jpg"]]
        
        for user in users{
            Auth.auth().createUser(withEmail: user["email"]!, password: user["password"]!) { [unowned self](data, error) in
                if let e = error {
                    self.showAlert(title: "Error", message: e.localizedDescription)
                }else{
                    if let datos = data {
                        let info = ["provider": datos.user.providerID, "email": datos.user.email, "profileImage": user["photoURL"]!, "displayName": user["displayName"], "userIsOnMatch": false] as [String : Any]
                        DatabaseService.instance.createFirebaseUser(uid: datos.user.uid, userData: info as [String : Any])
                    }
                }
            }
        }
    }
}
