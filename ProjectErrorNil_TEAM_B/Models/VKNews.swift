//
//  VKFeed.swift
//  ProjectErrorNil_TEAM_B
//
//  Created by d0bsson on 14.04.2024.
//

import Foundation

struct VKNews: Codable {
    let response: Response
}

struct Response: Codable {
    let count: Int
    let items: [ResponseItems]
}

struct ResponseItems: Codable {
    let attachments: [Attachment]
    let date: Int
    let text: String
}

struct Attachment: Codable {
    let video: Video?
}

struct Video: Codable {
    let description: String //описание видео на стене
    let title: String
    let date: Int // дата поста
    let image: [Image] //картинка поста
}

struct Image: Codable {
    let url: String
}







