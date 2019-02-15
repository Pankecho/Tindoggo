//
//  LoginViewController.swift
//  Tindoggo
//
//  Created by Juan Pablo Martinez Ruiz on 22/11/18.
//  Copyright © 2018 Juan Pablo Martinez Ruiz. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var accountAlreadyLabel: UILabel!
    @IBOutlet weak var goToLoginButton: UIButton!
    
    var modoRegistro = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.bindKeyboard()
    }
    
    @IBAction func login(_ sender: UIButton) {
        if self.emailTextField.text == "" || self.passwordTextField.text == "" {
            showAlert(title: "Error", message: "Por favor, revisa los campos")
        }else{
            if let email = self.emailTextField.text, let password = self.passwordTextField.text {
                if self.modoRegistro {
                    Auth.auth().createUser(withEmail: email, password: password) { [unowned self](data, error) in
                        if let e = error {
                            self.showAlert(title: "Error", message: e.localizedDescription)
                        }else{
                            if let datos = data {
                                let info = ["provider": datos.user.providerID, "email": datos.user.email, "profileImage": "", "displayName": "", "userIsOnMatch": false] as [String: Any]
                                DatabaseService.instance.createFirebaseUser(uid: datos.user.uid, userData: info as [String : Any])
                            }
                        }
                    }
                }else{
                    Auth.auth().signIn(withEmail: email, password: password) { (data, error) in
                        if let e = error {
                            self.showAlert(title: "Error", message: e.localizedDescription)
                        }else{
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func alreadyLogin(_ sender: UIButton) {
        if self.modoRegistro {
            self.loginButton.setTitle("Login", for: .normal)
            self.accountAlreadyLabel.text = "Eres nuevo?"
             self.goToLoginButton.setTitle("Registrate", for: .normal)
            self.modoRegistro = false
        }else{
            self.loginButton.setTitle("Crear cuenta", for: .normal)
            self.accountAlreadyLabel.text = "Ya tienes cuenta?"
            self.goToLoginButton.setTitle("Login", for: .normal)
            self.modoRegistro = true
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func closeButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
