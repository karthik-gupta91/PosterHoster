//
//  PosterModel.swift
//  PosterHoster
//
//  Created by Kartik Gupta on 15/05/22.
//

import Foundation

// MARK: - PosterViewModel
struct PosterModel: Decodable {
    let page: PosterPage
}

// MARK: - PosterPage
struct PosterPage: Decodable {
    let title, totalContentItems, pageNum, pageSize: String
    let contentItems: PosterContentItems

    enum CodingKeys: String, CodingKey {
        case title
        case totalContentItems = "total-content-items"
        case pageNum = "page-num"
        case pageSize = "page-size"
        case contentItems = "content-items"
    }
}

// MARK: - PosterContentItems
struct PosterContentItems: Decodable {
    let content: [PosterContent]
}

// MARK: - PosterContent
struct PosterContent: Decodable {
    let name, posterImage: String

    enum CodingKeys: String, CodingKey {
        case name
        case posterImage = "poster-image"
    }
}
