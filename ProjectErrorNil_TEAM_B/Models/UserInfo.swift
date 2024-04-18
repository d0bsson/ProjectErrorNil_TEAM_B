//
//  UserInfo.swift
//  ProjectErrorNil_TEAM_B
//
//  Created by d0bsson on 18.04.2024.
//

import Foundation

struct UserInfo: Codable {
    let response: Info
}

struct Info: Codable {
    let firstName: String
    let lastName: String
    
    enum CodingKeys: String, CodingKey{
        case firstName = "first_name"
        case lastName = "last_name"
    }
    
}
