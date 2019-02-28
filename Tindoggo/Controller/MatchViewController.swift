//
//  MatchViewController.swift
//  Tindoggo
//
//  Created by Juan Pablo Martinez Ruiz on 27/02/19.
//  Copyright © 2019 Juan Pablo Martinez Ruiz. All rights reserved.
//

import UIKit

class MatchViewController: UIViewController {
    
    @IBOutlet weak var matchDescription: UILabel!
    
    @IBOutlet weak var userMatchOne: UIImageView!
    @IBOutlet weak var userMatchTwo: UIImageView!
    
    
    @IBOutlet weak var boton: UIButton!
    
    var currentUserProfile: Usuario?
    var currentMatch: Match?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userMatchTwo.roundImage()
        self.userMatchOne.roundImage()
        // Do any additional setup after loading the view.
        
        if let match = currentMatch {
            if let user = currentUserProfile{
                var second = ""
                if user.uid == match.uidUno{
                    second = match.uidDos
                }else{
                    second = match.uidUno
                }
                
                DatabaseService.instance.getUserById(id: second) { [unowned self](usuario) in
                    if let userD = usuario{
                        if user.uid == match.uidUno{
                            // init match
                            self.userMatchOne.sd_setImage(with: URL(string: user.imagen), completed: nil)
                            self.userMatchTwo.sd_setImage(with: URL(string: userD.imagen), completed: nil)
                            self.matchDescription.text = "Esperando a \(userD.username)"
                            self.boton.alpha = 0
                        }else{
                            // match
                            self.userMatchOne.sd_setImage(with: URL(string: userD.imagen), completed: nil)
                            self.userMatchTwo.sd_setImage(with: URL(string: user.imagen), completed: nil)
                            self.matchDescription.text = "Tu mascota le gusta a \(userD.username)"
                            self.boton.alpha = 1
                        }
                    }
                }
                
                
            }
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
    @IBAction func aceptarButton(_ sender: UIButton) {
        if let match = currentMatch {
            if !match.isMatchAccepted {
                DatabaseService.instance.updateMatch(id: match.uidUno)
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
}
