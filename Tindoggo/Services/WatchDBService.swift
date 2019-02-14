//
//  WatchDBService.swift
//  Tindoggo
//
//  Created by Juan Pablo Martinez Ruiz on 13/02/19.
//  Copyright © 2019 Juan Pablo Martinez Ruiz. All rights reserved.
//

import Foundation
import Firebase

class WatchDBService {
    static let instance = WatchDBService()
    
    func observeMatch(handler: @escaping(_ match: Match?)->Void ){
        DatabaseService.instance.match_ref.observe(.value) { (data) in
            if let match = data.children.allObjects as? [DataSnapshot]{
                if match.count > 0{
                    for m in match{
                        if m.hasChild("uidDos") && m.hasChild("isMatchAccepted"){
                            if let matchDic = Match(snapshot: m){
                                handler(matchDic)
                            }
                        }
                    }
                }else{
                    handler(nil)
                }
            }
        }
    }
}
