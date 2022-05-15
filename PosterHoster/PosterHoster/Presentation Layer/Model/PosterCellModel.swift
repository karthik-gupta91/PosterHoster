//
//  PosterCellModel.swift
//  PosterHoster
//
//  Created by Kartik Gupta on 14/05/22.
//

import Foundation
import UIKit

protocol PosterDisplayableProtocol {
    var imageURL: String { get set }
    var title: String  { get set }
}

struct PosterCellModel: PosterDisplayableProtocol {
    var imageURL: String
    var title: String

    init(content: PosterContent) {
        self.imageURL = content.posterImage
        self.title = content.name
    }
}
