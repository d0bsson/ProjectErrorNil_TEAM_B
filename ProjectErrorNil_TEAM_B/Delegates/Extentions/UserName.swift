//
//  UserName.swift
//  ProjectErrorNil_TEAM_B
//
//  Created by d0bsson on 18.04.2024.
//

import Foundation

class UserName {
    static let shared = UserName()
    private init() {}
    
    var name = ""
    var secondName = ""
}
