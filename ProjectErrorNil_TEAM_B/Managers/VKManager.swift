//
//  VKManager.swift
//  ProjectErrorNil_TEAM_B
//
//  Created by d0bsson on 29.03.2024.
//

import Foundation

//https://oauth.vk.com/authorize?client_id=51891179&redirect_uri=/blank.html&display=mobile&scope=offline&response_type=token&v=5.199

class VKManager {
    func getAuthRequest() -> URLRequest? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "oauth.vk.com"
        urlComponents.path = "/authorize"
        
        urlComponents.queryItems = [
        
            URLQueryItem(name: "client_id", value: "51891179"),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "response_type", value: "token")
        ]
        
        guard let requestURL = urlComponents.url else { return nil }
        let req = URLRequest(url: requestURL)
        
        return req
    }
}

