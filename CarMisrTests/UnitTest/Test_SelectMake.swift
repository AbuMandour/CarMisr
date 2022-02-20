//
//  Test_SelectMake.swift
//  CarMisrTests
//
//  Created by Muhammad Abumandour on 17/02/2022.
//

import Foundation
import XCTest
@testable import CarMisr

class Test_SelectMake : XCTestCase{

    private var carMakeService : CarMakeService!
    private var apiServiceMock : ApiServiceMock!

    override func setUp() {
        apiServiceMock = ApiServiceMock()
        carMakeService = CarMakeService(apiService: apiServiceMock)
    }
        
    func test_carMakesShouldReturnError() async {
        // given
        apiServiceMock.behavior = .alwaysFail
        let pageNumber = 1
        //when
        let result = await carMakeService.getCarMakes(pageNumber: pageNumber) as Result<[Make], DataError>
        //then
        XCTAssertEqual(result, .failure(.error("")))
    }
    
    func test_carMakesShouldReturnEmptyArray() async {
        // given
        let pageNumber = 1
        let expectedMakes = CarMakeData(totalNumber: nil, totalPages: nil, makes: [MakeData]())
        apiServiceMock.behavior = .alwaysSucceed(expectedMakes)
        //when
        let result = await carMakeService.getCarMakes(pageNumber: pageNumber) as Result<[Make], DataError>
        //then
        XCTAssertEqual(result, .failure(.empty("No data")))
    }
    
    func test_carMakesShouldReturnArrayOfMakes() async throws {
        // given
        let pageNumber = 1
        let expectedMakes = CarMakeData(totalNumber: nil, totalPages: nil, makes: [MakeData(id: nil, name: "Peugeot", niceName: nil, adTargetID: nil, niceID: nil, useInUsed: nil, useInNew: nil, useInPreProduction: nil, useInFuture: nil, attributeGroups: nil, models: nil),MakeData(id: nil, name: "Audi", niceName: nil, adTargetID: nil, niceID: nil, useInUsed: nil, useInNew: nil, useInPreProduction: nil, useInFuture: nil, attributeGroups: nil, models: nil),MakeData(id: nil, name: "Sokda", niceName: nil, adTargetID: nil, niceID: nil, useInUsed: nil, useInNew: nil, useInPreProduction: nil, useInFuture: nil, attributeGroups: nil, models: nil),MakeData(id: nil, name: "Honda", niceName: nil, adTargetID: nil, niceID: nil, useInUsed: nil, useInNew: nil, useInPreProduction: nil, useInFuture: nil, attributeGroups: nil, models: nil)])
        apiServiceMock.behavior = .alwaysSucceed(expectedMakes)
        
        //when
        let result = await carMakeService.getCarMakes(pageNumber: pageNumber) as Result<[Make],DataError>
        let makes = try result.get()
                
        //then
        XCTAssertFalse(makes.isEmpty)
    }
    
    func test_carMakesShouldSortedAlphabetically() async throws {
        // given
        let pageNumber = 1
        let expectedMakes = CarMakeData(totalNumber: nil, totalPages: nil, makes: [MakeData(id: nil, name: "Peugeot", niceName: nil, adTargetID: nil, niceID: nil, useInUsed: nil, useInNew: nil, useInPreProduction: nil, useInFuture: nil, attributeGroups: nil, models: nil),MakeData(id: nil, name: "Audi", niceName: nil, adTargetID: nil, niceID: nil, useInUsed: nil, useInNew: nil, useInPreProduction: nil, useInFuture: nil, attributeGroups: nil, models: nil),MakeData(id: nil, name: "Sokda", niceName: nil, adTargetID: nil, niceID: nil, useInUsed: nil, useInNew: nil, useInPreProduction: nil, useInFuture: nil, attributeGroups: nil, models: nil),MakeData(id: nil, name: "Honda", niceName: nil, adTargetID: nil, niceID: nil, useInUsed: nil, useInNew: nil, useInPreProduction: nil, useInFuture: nil, attributeGroups: nil, models: nil)])
        apiServiceMock.behavior = .alwaysSucceed(expectedMakes)
        
        //when
        let result = await carMakeService.getCarMakes(pageNumber: pageNumber) as Result<[Make],DataError>
        let makes = try result.get()    
        let firstCharFromFirstWord = makes.first?.name.lowercased() ?? ""
        let firstCharFromLastWord = makes.last?.name.lowercased() ?? ""
        
        //then
        XCTAssertTrue(firstCharFromLastWord > firstCharFromFirstWord)
    }
    
    override func tearDown() {
        apiServiceMock = nil
        carMakeService = nil
    }
}
