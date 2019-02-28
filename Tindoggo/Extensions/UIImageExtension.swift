//
//  UIImageExtension.swift
//  Tindoggo
//
//  Created by Juan Pablo Martinez Ruiz on 27/02/19.
//  Copyright © 2019 Juan Pablo Martinez Ruiz. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView{
    func roundImage(){
        self.layer.cornerRadius = self.bounds.size.height / 2
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 1.0
        self.clipsToBounds = true
    }
}
