//
//  PosterFetchServiceTest.swift
//  PosterHosterTests
//
//  Created by Kartik Gupta on 15/05/22.
//

import XCTest

@testable import PosterHoster

class MockFetchPosterService: FetchDataServiceProtocol {
        
    func loadJson(filename fileName: String, completionHandler: @escaping (Result) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now(), execute: {
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

class PosterFetchServiceTest: XCTestCase {
    
    var mockService: MockFetchPosterService?
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        var mockService = MockFetchPosterService()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        mockService = nil
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    

    func testFetchPhotoServiceSuccess() throws {
        mockService?.loadJson(filename: "CONTENTLISTINGPAGE-PAGE1", completionHandler: { result in
            var isNetWorkResultSuccess = false
            switch result {
            case .success(_):
                isNetWorkResultSuccess = true
            case .failure(_):
                isNetWorkResultSuccess = false
            }
            XCTAssert(isNetWorkResultSuccess == true , "Failed")
        })
    }

}
