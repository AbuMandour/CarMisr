//
//  Test_ApiService.swift
//  CarMisrTests
//
//  Created by Muhammad Abumandour on 21/02/2022.
//

import Foundation
import XCTest
@testable import CarMisr

class Test_ApiService: XCTestCase {
    
    var apiService: ApiProtocol!
    var apiCallStub: UserStubData?
    var errorMessage: String?
    
    override func setUp() {
        super.setUp()
        apiService = ApiService()
    }
    
    func test_Fetch_Method_From_Api() async {
        // given
        let url = "https://randomuser.me/api/"
        let urlRequest = URLRequest(url: URL(string: url)!)
        // when
        let result = await apiService.fetchItem(urlRequest: urlRequest) as Result<UserStubData,ApiError>
        switch result{
        case .success(let apiCallSubData):
            self.apiCallStub = apiCallSubData
        case .failure(let error):
            self.errorMessage = error.description
        }
        // then
        XCTAssertTrue(errorMessage?.isEmpty ?? true)
        XCTAssertNotNil(apiCallStub)
    }
    
}
