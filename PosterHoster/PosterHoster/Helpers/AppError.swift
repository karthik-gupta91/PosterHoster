//
//  AppError.swift
//  PosterHoster
//
//  Created by Kartik Gupta on 14/05/22.
//

import Foundation

enum NetworkError {
    case networkError
    case fetchError
    case decodingError
    case dataNotFound
    
    var errorMessage: String {
        switch self {
        case .networkError: return "Something went wrong!"
        case .fetchError: return "Unable to Fetch!"
        case .decodingError: return "unable to decode file"
        case .dataNotFound: return "Data not found!"
        }
    }
}
