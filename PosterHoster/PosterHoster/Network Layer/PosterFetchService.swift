//
//  PosterFetchService.swift
//  PosterHoster
//
//  Created by Kartik Gupta on 14/05/22.
//

import Foundation

protocol FetchDataServiceProtocol {
    func loadJson(filename fileName: String, completionHandler:@escaping (Result) -> Void)
}

enum Result {
    case success(Data)
    case failure(NetworkError)
}

class PosterFetchService: FetchDataServiceProtocol {
    
    func loadJson(filename fileName: String, completionHandler:@escaping (Result) -> Void) {
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.5, execute: {
            if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
                do {
                    let data = try Data(contentsOf: url)
                    DispatchQueue.main.async {
                        completionHandler(.success(data))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completionHandler(.failure(.dataNotFound))
                    }
                }
            } else {
                DispatchQueue.main.async {
                    completionHandler(.failure(.fetchError))
                }
            }
        })
        
    }
}
