//
//  PosterViewModel.swift
//  PosterHoster
//
//  Created by Kartik Gupta on 14/05/22.
//

import Foundation

typealias CompletionClosure = (()->Void)
typealias FailedClosure = ((_ error: String?) -> Void)

protocol PosterViewModelProtocol {
    var completionClosure: CompletionClosure? {get set}
    var failedClosure: FailedClosure? {get set}
    
    var posterModel: PosterModel? {get set}
    var dataSource: [PosterCellModel]? {get set}
    
    func getTotalPhotosCount() -> Int
    func fetchPosters(for page: Int)
}

class PosterViewModel: PosterViewModelProtocol {
    var dataSource: [PosterCellModel]? = []
    
    var posterModel: PosterModel?
    
    var completionClosure: CompletionClosure?
    var failedClosure: FailedClosure?
    
    let fetchPosterService = PosterFetchService()
    
    func getTotalPhotosCount() -> Int {
        guard let totalPhotos = self.posterModel?.page.totalContentItems else { return 0 }
        return Int(totalPhotos) ?? 0
    }
    
    func getPosters() -> [PosterContent]? {
        return posterModel?.page.contentItems.content
    }
    
    func setDataSource() {
        if let posters = getPosters() {
            for poster in posters {
                self.dataSource?.append(PosterCellModel(content: poster))
            }
        }
    }
    
    func fetchPosters(for page: Int) {
        
        fetchPosterService.loadJson(filename: AppURL.jsonName + "\(page)") { result in
            switch result {
            case .failure(let error):
                self.failedClosure?(error.errorMessage)
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let posterModel = try decoder.decode(PosterModel.self, from: data)
                    self.posterModel = posterModel
                    self.setDataSource()
                    self.completionClosure?()
                } catch {
                    self.failedClosure?(NetworkError.decodingError.errorMessage)
                }
            }
        }
    }
    
}
