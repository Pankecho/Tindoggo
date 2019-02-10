//
//  Usuario.swift
//  Tindoggo
//
//  Created by Juan Pablo Martinez Ruiz on 24/11/18.
//  Copyright © 2018 Juan Pablo Martinez Ruiz. All rights reserved.
//

import Foundation
import Firebase

class Usuario {
    let uid: String
    let email: String
    let provider: String
    let imagen: String
    let username: String
    
    init?(snapshot: DataSnapshot){
        let uid = snapshot.key
        guard let diccionario = snapshot.value as? [String: Any],
            let email = diccionario["email"] as? String,
            let provider = diccionario["provider"] as? String,
            let imagen = diccionario["profileImage"] as? String,
            let username = diccionario["displayName"] as? String else { return nil }
        
        self.uid = uid
        self.email = email
        self.provider = provider
        self.imagen = imagen
        self.username = username
    }
}
