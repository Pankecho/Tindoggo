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
    private let _match_ref = DB_ROOT.child("match")
    
    var base_ref: DatabaseReference{
        return _base_ref
    }
    
    var user_ref: DatabaseReference{
        return _user_ref
    }
    
    var match_ref: DatabaseReference{
        return _match_ref
    }
    
    func createFirebaseUser(uid: String, userData: [String: Any]){
        user_ref.child(uid).updateChildValues(userData)
    }
    
    func createFirebaseMatch(uidUno: String, uidDos: String){
        match_ref.child(uidUno).updateChildValues(["userDos": uidDos, "isMatchAccepted": false])
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
