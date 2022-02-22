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
        XCTAssertEqual(result, .failure(.empty(Defaults.noDataMessage)))
    }
    
    func test_carMakesShouldReturnArrayOfMakes() async throws {
        // given
        let pageNumber = 1
        let expectedMakes = CarMakeData(totalNumber: nil, totalPages: nil, makes: [MakeData(id: 1 ,name: "Peugeot", niceName: "peugeot" ),MakeData(id: 2, name: "Audi", niceName: "audi"),MakeData(id: 3, name: "Sokda", niceName: "sokda"),MakeData(id: 5, name: "Honda", niceName: nil)])
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
        let expectedMakes = CarMakeData(totalNumber: nil, totalPages: nil, makes: [MakeData(id: 1 ,name: "Peugeot", niceName: "peugeot" ),MakeData(id: 2, name: "Audi", niceName: "audi"),MakeData(id: 3, name: "Sokda", niceName: "sokda"),MakeData(id: 4, name: "Honda", niceName: nil)])
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
