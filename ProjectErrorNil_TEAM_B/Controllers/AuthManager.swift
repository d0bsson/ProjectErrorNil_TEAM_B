//
//  AuthManager.swift
//  ProjectErrorNil_TEAM_B
//
//  Created by Руслан Алиджанов on 31.03.2024.
//

import Foundation

protocol SceneRouteDelegate{
    func setLoginStatus(isLogin: Bool)
}

class AuthManager{
    static let shared = AuthManager()
    let userDef = UserDefaults.standard
    
    //функция на вход
    func isLoggedIn() -> Bool{
        return userDef.bool(forKey: "isLogin")
    }
   // статус входа
    func setLoginStatus(isLogin: Bool){
        userDef.set(isLogin, forKey: "isLogin")
    }
    private init(){}
}
