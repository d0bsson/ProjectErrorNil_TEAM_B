//
//  VKManager.swift
//  ProjectErrorNil_TEAM_B
//
//  Created by d0bsson on 29.03.2024.
//

import Foundation

//MARK: - Запрос на авторизацию пользователя
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
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "scope", value: "offline")
        ]
        
        guard let requestURL = urlComponents.url else { return nil }
        let req = URLRequest(url: requestURL)
        print(requestURL)
        return req
    }
    
    //MARK: - Получение URL для запроса данных со стены сообщества
    private func getNewsUrl() -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.vk.com"
        urlComponents.path = "/method/wall.get"
        
        urlComponents.queryItems = [
            URLQueryItem(name: "access_token", value: Session.shared.token),
            URLQueryItem(name: "owner_id", value: "-222251367"),
            URLQueryItem(name: "v", value: "5.199")
        ]
        
        guard let url = urlComponents.url else { return nil }
        return url
    }
    
    private func getUserInfoRequest() -> URL? {
        var urlComponents = URLComponents()
        //
        urlComponents.scheme = "https"
        urlComponents.host = "api.vk.com"
        urlComponents.path = "/method/account.getProfileInfo"
        
        urlComponents.queryItems = [
            URLQueryItem(name: "access_token", value: Session.shared.token),
            URLQueryItem(name: "v", value: "5.199")
        ]
        
        guard let url = urlComponents.url else { return nil }
        return url
    }
    
    func getVideo(comlition: @escaping ([Video])->()) {
        if let url = getNewsUrl() {
            let request = URLRequest(url: url)
            
            URLSession.shared.dataTask(with: request) { data, resp, error in
                guard error == nil else {
                    print(error!.localizedDescription)
                    return
                }
                if let data = data {
                    do {
                        let news = try JSONDecoder().decode(VKNews.self, from: data)
                        let items = news.response.items
                        
                        var videos: [Video] = []
                        for i in items {
                            let attachments = i.attachments
                            for attachment in attachments {
                                if let video = attachment.video {
                                    videos.append(video)
                                }
                            }
                        }
                        comlition(videos)
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }.resume()
        }
    }
    
    func getInfo(comlition: @escaping (UserInfo)->()) {
        if let url = getUserInfoRequest() {
            let request = URLRequest(url: url)
            
            URLSession.shared.dataTask(with: request) { data, resp, error in
                guard error == nil else {
                    print(error!.localizedDescription)
                    return
                }
                if let data = data {
                    do {
                        let userInfo = try JSONDecoder().decode(UserInfo.self, from: data)
                        comlition(userInfo)
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }.resume()
        }
    }
}

//MARK:- извлечение Data из ссылки на изображение
class ImageManager {
    static let shared = ImageManager()
    private init () {}
    
    func loadImage(url: URL, comletion: @escaping (Data) -> Void) {
        URLSession.shared.dataTask(with: url) {data, _, error in
            guard let data = data else {
                print(error?.localizedDescription ?? "No info error")
                return
            }
            DispatchQueue.main.async {
                comletion(data)
            }
        }.resume()
    }
}

//Отдельный класс синглтон для токена ВК
class Session {
    static let shared = Session()
    private init() {}
    
    var token = ""
}
