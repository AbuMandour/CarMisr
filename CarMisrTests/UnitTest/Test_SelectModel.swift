//
//  Test_SelectModel.swift
//  CarMisrTests
//
//  Created by Muhammad Abumandour on 19/02/2022.
//

import Foundation
import XCTest

@testable import CarMisr


class Test_SelectModel : XCTestCase{
    
    private var apiServiceMock: ApiServiceMock!
    private var carModelService: CarModelProtocol!
    
    override func setUp() {
        apiServiceMock = ApiServiceMock()
        carModelService = CarModelService(apiService: apiServiceMock)
    }
    
    func test_carModelShouldReturnError() async {
        // given
        apiServiceMock.behavior = .alwaysFail
        let pageNumber = 1
        let makeNiceName = ""
        //when
        let result = await carModelService.getCarModels(makeNiceName: makeNiceName, pageNumber: pageNumber) as Result<[Model], DataError>
        //then
        XCTAssertEqual(result, .failure(.error("")))
    }
    
    func test_carModelShouldReturnEmpty() async {
        // given
        let pageNumber = 1
        let makeNiceName = ""
//        let expectedMakes =
//        apiServiceMock.behavior = .alwaysSucceed(expectedMakes)
        //when
        let result = await carModelService.getCarModels(makeNiceName: makeNiceName,pageNumber: pageNumber) as Result<[Model], DataError>
        //then
        XCTAssertEqual(result, .failure(.empty(Defaults.noDataString)))
    }
    
    func test_carModelShouldReturnArrayofModels() async throws{
        // given
        let pageNumber = 1
        let makeNiceName = ""
//        let expectedMakes =
//        apiServiceMock.behavior = .alwaysSucceed(expectedMakes)
        
        //when
        let result = await carModelService.getCarModels(makeNiceName: makeNiceName,pageNumber: pageNumber) as Result<[Model],DataError>
        let models = try result.get()
                
        //then
        XCTAssertFalse(models.isEmpty)
    }
    
    func test_carModelShouldReturnOnly2022Models() async throws{
        // given
        let pageNumber = 1
        let makeNiceName = ""
//        let expectedMakes =
//        apiServiceMock.behavior = .alwaysSucceed(expectedMakes)
        
        //when
        let result = await carModelService.getCarModels(makeNiceName: makeNiceName,pageNumber: pageNumber) as Result<[Model],DataError>
        let models:[Model] = try result.get()
        let hasModelsOtherThan2022 = models.contains { $0.year != 2022 }
        //then
        XCTAssertFalse(hasModelsOtherThan2022)
    }
    
    func test_carModelShouldReturnOnlyNewCars() async throws {
        // given
        let pageNumber = 1
        let makeNiceName = ""
//        let expectedMakes =
//        apiServiceMock.behavior = .alwaysSucceed(expectedMakes)
        
        //when
        let result = await carModelService.getCarModels(makeNiceName: makeNiceName,pageNumber: pageNumber) as Result<[Model],DataError>
        let models:[Model] = try result.get()
        let hasNoNewCars = models.contains { !$0.isNew }
        //then
        XCTAssertFalse(hasNoNewCars)
    }
    
    func test_carModelShouldNotReturnDuplicates() async throws{
        // given
        let pageNumber = 1
        let makeNiceName = ""
//        let expectedMakes =
//        apiServiceMock.behavior = .alwaysSucceed(expectedMakes)
        
        //when
        let result = await carModelService.getCarModels(makeNiceName: makeNiceName,pageNumber: pageNumber) as Result<[Model],DataError>
        let models = try result.get()
        let duplicated = Dictionary(grouping: models, by: {$0}).filter { $1.count > 1 }.keys
        //then
        XCTAssertTrue(duplicated.isEmpty)
    }
}
