//
//  UserSingleton.swift
//  CloneSnapchat
//
//  Created by Mehmet Ergün on 2022-06-11.
//

import Foundation

struct UserSingleton {
    
    static var sharedUserInfo = UserSingleton()
    
    var email = ""
    var username = ""
    
}
