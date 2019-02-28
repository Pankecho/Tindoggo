//
//  HomeViewController.swift
//  Tindoggo
//
//  Created by Juan Pablo Martinez Ruiz on 21/11/18.
//  Copyright © 2018 Juan Pablo Martinez Ruiz. All rights reserved.
//

import UIKit
import RevealingSplashView
import Firebase

class HomeViewController: UIViewController {
    
    @IBOutlet weak var cardView: UIView!
    
    @IBOutlet weak var stack: UIStackView!
    
    @IBOutlet weak var like: UIImageView!
    
    @IBOutlet weak var nope: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var imageActual: UIImageView!
    let leftButton = UIButton(type: .custom)
    let rightButton = UIButton(type: .custom)
    
    var usuario: Usuario?
    
    var usuarioActualID: String?
    
    var match: Match?
    
    var users: [Usuario]! = []
    
    let splashScreen = RevealingSplashView(iconImage: UIImage(named: "splash_icon")!, iconInitialSize: CGSize(width: 80, height: 80), backgroundColor: .white)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.addSubview(self.splashScreen)
        self.splashScreen.animationType = .swingAndZoomOut
        self.splashScreen.startAnimation()
        
        let titleView = NavigationImageView()
        titleView.image = UIImage(named: "Actions")
        self.navigationItem.titleView = titleView
        
        self.leftButton.imageView?.contentMode = .scaleAspectFit
        
        let leftBarButton = UIBarButtonItem(customView: leftButton)
        navigationItem.leftBarButtonItem = leftBarButton
        
        self.rightButton.setImage(UIImage(named: "match_inactive"), for: .normal)
        self.rightButton.imageView?.contentMode = .scaleAspectFit
        let rightBarButton = UIBarButtonItem(customView: rightButton)
        navigationItem.rightBarButtonItem = rightBarButton
        
        let homeGR = UIPanGestureRecognizer(target: self, action: #selector(swipe))
        self.cardView.addGestureRecognizer(homeGR)
        
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                
            }else{
                
            }
            DatabaseService.instance.observeUserProfile { (user) in
                self.usuario = user
            }
            self.getUsers()
        }
        WatchDBService.instance.observeMatch { (match) in
            if let _ = match{
                if let user = self.usuario{
                    if !user.onMatch{
                        self.changeRightButton(status: true)
                    }
                }
            }else{
                self.changeRightButton(status: false)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.leftButton.removeTarget(nil, action: nil, for: .allEvents)
        if let _ = Auth.auth().currentUser {
            self.leftButton.setImage(UIImage(named: "login_active")!, for: .normal)
            self.leftButton.addTarget(self, action: #selector(presentProfile(sender:)), for: .touchUpInside)
        }else{
            self.leftButton.setImage(UIImage(named: "login")!, for: .normal)
            self.leftButton.addTarget(self, action: #selector(presentModal), for: .touchUpInside)
        }
    }
    
    func changeRightButton(status: Bool){
        if status{
            self.rightButton.setImage(UIImage(named: "match_active"), for: .normal)
            self.rightButton.addTarget(self, action: #selector(presentMatch), for: .touchUpInside)
        }else{
            self.rightButton.setImage(UIImage(named: "match_inactive"), for: .normal)
            self.rightButton.removeTarget(self, action: #selector(presentMatch), for: .touchUpInside)
        }
    }
    
    @objc func swipe(gesture: UIPanGestureRecognizer){
        let cardPoint = gesture.translation(in: view)
        self.cardView.center = CGPoint(x: (self.view.bounds.width / 2) + cardPoint.x, y: (self.view.bounds.height / 2) + cardPoint.y - 35)
        
        let movementFromX = self.view.bounds.width / 2 - self.cardView.center.x
        var rotate = CGAffineTransform(rotationAngle: movementFromX / 200)
        let scala = min(100 / abs(movementFromX), 1)
        
        self.cardView.transform = rotate.scaledBy(x: scala, y: scala)
        
        
        if gesture.state == .ended {
            if self.cardView.center.x < (self.view.bounds.width / 2 - 100) {
                // Dislike
            }
            if self.cardView.center.x > (self.view.bounds.width / 2 + 100) {
                // Like
                if let uid2 = usuarioActualID, let user = self.usuario{
                    DatabaseService.instance.createFirebaseMatch(uidUno: user.uid, uidDos: uid2)
                }
            }
            if self.users.count > 0{
                self.updateImage(uid: self.users[self.random(range: 0..<self.users.count)].uid)
            }
            
            UIView.animate(withDuration: 0.5) {[unowned self] in
                self.cardView.center = CGPoint(x: (self.stack.bounds.width / 2), y: (self.stack.bounds.height / 2) - 35)
                rotate = CGAffineTransform(rotationAngle: CGFloat(integerLiteral: 0))
                self.cardView.transform = rotate.scaledBy(x: 1, y: 1)
            }
        }
    }
    
    @objc func presentModal(sender: UIButton){
        let story = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = story.instantiateViewController(withIdentifier: "loginVC")
        present(vc, animated: true)
    }
    
    @objc func presentProfile(sender: UIButton){
        let story = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = story.instantiateViewController(withIdentifier: "profileVC") as! ProfileViewController
        vc.usuario = self.usuario
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func presentMatch(sender: UIButton){
        let story = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = story.instantiateViewController(withIdentifier: "match_vc") as! MatchViewController
        vc.currentUserProfile = self.usuario
        vc.currentMatch = self.match
        present(vc, animated: true)
    }
    
    func getUsers(){
        DatabaseService.instance.user_ref.observeSingleEvent(of: .value) { [unowned self](data) in
            let users = data.children.compactMap{ Usuario(snapshot: $0 as! DataSnapshot)}
            for user in users{
                if self.usuario?.uid != user.uid{
                    self.users?.append(user)
                }
            }
            
            if self.users.count > 0{
                self.updateImage(uid: (self.users.first?.uid)!)
            }
        }
    }
    
    func updateImage(uid: String){
        DatabaseService.instance.user_ref.child(uid).observeSingleEvent(of: .value) { (data) in
            if let user = Usuario(snapshot: data){
                self.imageActual.sd_setImage(with: URL(string: user.imagen), completed: nil)
                self.nameLabel.text = user.username
                self.usuarioActualID = user.uid
            }
        }
    
    }
    
    func random(range: Range<Int>) -> Int{
        return range.lowerBound + Int(arc4random_uniform(UInt32(range.upperBound - range.lowerBound)))
    }
}

class NavigationImageView: UIImageView{
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: 76, height: 39)
    }
}
