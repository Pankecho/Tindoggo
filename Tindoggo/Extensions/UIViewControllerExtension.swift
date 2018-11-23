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
}
