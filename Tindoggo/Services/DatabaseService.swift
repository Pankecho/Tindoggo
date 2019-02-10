//
//  DatabaseService.swift
//  Tindoggo
//
//  Created by Juan Pablo Martinez Ruiz on 22/11/18.
//  Copyright © 2018 Juan Pablo Martinez Ruiz. All rights reserved.
//

import Foundation
import Firebase

let DB_ROOT = Database.database().reference()

class DatabaseService{
    static let instance = DatabaseService()
    private let _base_ref = DB_ROOT
    private let _user_ref = DB_ROOT.child("users")
    
    var base_ref: DatabaseReference{
        return _base_ref
    }
    
    var user_ref: DatabaseReference{
        return _user_ref
    }
    
    func createFirebaseUser(uid: String, userData: [String: Any]){
        user_ref.child(uid).updateChildValues(userData)
    }
    
    func observeUserProfile(handler: @escaping(_ userProfile: Usuario?) -> Void){
        if let user = Auth.auth().currentUser {
            DatabaseService.instance.user_ref.child(user.uid).observe(.value) { (snap) in
                if let usuario = Usuario(snapshot: snap){
                    handler(usuario)
                }
            }
        }
    }
    
}
