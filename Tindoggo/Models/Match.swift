//
//  Match.swift
//  Tindoggo
//
//  Created by Juan Pablo Martinez Ruiz on 13/02/19.
//  Copyright © 2019 Juan Pablo Martinez Ruiz. All rights reserved.
//

import Foundation
import Firebase

class Match {
    let uidUno: String
    let uidDos: String
    let isMatchAccepted: Bool
    
    init?(snapshot: DataSnapshot) {
        let uidUno = snapshot.key
        guard let dic = snapshot.value as? [String: Any],
        let uidDos = dic["uidDos"] as? String,
            let match = dic["isMatchAccepted"] as? Bool else{
                return nil
        }
        
        self.uidUno = uidUno
        self.uidDos = uidDos
        self.isMatchAccepted = match
    }
}
