//
//  UIViewControllerExtension.swift
//  Tindoggo
//
//  Created by Juan Pablo Martinez Ruiz on 22/11/18.
//  Copyright © 2018 Juan Pablo Martinez Ruiz. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController{
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func showAlert(title: String, message: String){
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(ac, animated: true)
    }
}
