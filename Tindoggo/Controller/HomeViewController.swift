//
//  HomeViewController.swift
//  Tindoggo
//
//  Created by Juan Pablo Martinez Ruiz on 21/11/18.
//  Copyright © 2018 Juan Pablo Martinez Ruiz. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var cardView: UIView!
    
    @IBOutlet weak var stack: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let titleView = NavigationImageView()
        titleView.image = UIImage(named: "Actions")
        self.navigationItem.titleView = titleView
        
        let homeGR = UIPanGestureRecognizer(target: self, action: #selector(swipe))
        self.cardView.addGestureRecognizer(homeGR)
    }
    
    @objc func swipe(gesture: UIPanGestureRecognizer){
        let cardPoint = gesture.translation(in: view)
        self.cardView.center = CGPoint(x: (self.view.bounds.width / 2) + cardPoint.x, y: (self.view.bounds.height / 2) + cardPoint.y - 35)
        
        let movementFromX = self.view.bounds.width / 2 - self.cardView.center.x
        var rotate = CGAffineTransform(rotationAngle: movementFromX / 200)
        let scala = min(100 / abs(movementFromX), 1)
        
        self.cardView.transform = rotate.scaledBy(x: scala, y: scala)
        
        
        if gesture.state == .ended {
            if self.cardView.center.x < (self.view.bounds.width / 2) {
                // Dislike
            }else {
                // Like
            }
            UIView.animate(withDuration: 0.5) {[unowned self] in
                self.cardView.center = CGPoint(x: (self.stack.bounds.width / 2), y: (self.stack.bounds.height / 2) - 35)
                rotate = CGAffineTransform(rotationAngle: CGFloat(integerLiteral: 0))
                self.cardView.transform = rotate.scaledBy(x: 1, y: 1)
            }
        }
        
    }
    
}

class NavigationImageView: UIImageView{
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: 76, height: 39)
    }
}
