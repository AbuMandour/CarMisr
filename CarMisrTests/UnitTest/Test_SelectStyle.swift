//
//  Test_SelectStyle.swift
//  CarMisrTests
//
//  Created by Muhammad Abumandour on 03/03/2022.
//

import Foundation
import XCTest
@testable import CarMisr


class Test_SelectStyle : XCTestCase{
    
    private var apiServiceMock: ApiServiceMock!
    private var carStyleService: CarStyleProtocol!
    
    override func setUp() {
        apiServiceMock = ApiServiceMock()
        carStyleService = CarStyleService(apiService: apiServiceMock)
    }
    
    func test_carStyleShouldReturnError() async {
        // given
        apiServiceMock.behavior = .alwaysFail
        let pageNumber = 1
        let modelNiceName = "civic"
        //when
        let result = await carStyleService.getCarStyles(modelNiceName: modelNiceName, pageNumber: pageNumber) as Result<[Style], DataError>
        //then
        XCTAssertEqual(result, .failure(.error("")))
    }
    
    func test_carStyleShouldReturnEmptyMessgae() async {
        // given
        let pageNumber = 1
        let modelNiceName = "civic"
        let emptyMessage = Defaults.noDataMessage
        let expectedStyles = [CarStyleData(totalNumber: 0, totalPages: 0, styles: [StylesData]())]
        apiServiceMock.behavior = .alwaysSucceed(expectedStyles)
        //when
        let result = await carStyleService.getCarStyles(modelNiceName: modelNiceName, pageNumber: pageNumber) as Result<[Style], DataError>
        //then
        XCTAssertEqual(result, .failure(.empty(emptyMessage)))
    }
    
    func test_carStyleShouldReturnArrayofStyles() async throws{
        // given
        let pageNumber = 1
        let modelNiceName = "civic"
        let expectedStyles = [CarStyleData(totalNumber: 1, totalPages: 1, styles: [StylesData(id: 1, modelNiceName: "civic", modelId: "1", transmissionType: "", engineType: "", engineSize: 1400, numberOfSeats: 5, categories: nil, name: "Civic", niceName: "civic")]),CarColorData(colors: [Color](), colorsCount: 0)] as [Codable]

        apiServiceMock.behavior = .alwaysSucceed(expectedStyles)

        //when
        let result = await carStyleService.getCarStyles(modelNiceName: modelNiceName, pageNumber: pageNumber) as Result<[Style],DataError>
        let models = try result.get()

        //then
        XCTAssertFalse(models.isEmpty)
    }

    func test_carStyleShouldNotReturnDuplicates() async throws{
        // given
        let pageNumber = 1
        let modelNiceName = "civic"
        let expectedStyles = [CarStyleData(totalNumber: 1, totalPages: 1, styles: [StylesData(id: 1, modelNiceName: "civic", modelId: "1", transmissionType: "", engineType: "", engineSize: 1400, numberOfSeats: 5, categories: nil, name: "Civic", niceName: "civic"),StylesData(id: 1, modelNiceName: "civic", modelId: "1", transmissionType: "", engineType: "", engineSize: 1400, numberOfSeats: 5, categories: nil, name: "Civic", niceName: "civic")]),CarColorData(colors: [Color](), colorsCount: 0)] as [Codable]
        
        apiServiceMock.behavior = .alwaysSucceed(expectedStyles)

        //when
        let result = await carStyleService.getCarStyles(modelNiceName: modelNiceName, pageNumber: pageNumber) as Result<[Style],DataError>
        let models = try result.get()
        let duplicated = Dictionary(grouping: models, by: {$0.id}).filter { $1.count > 1 }.keys
        //then
        XCTAssertTrue(duplicated.isEmpty)
    }
    
    func test_carStyleColorShouldReturnEmptyArray() async throws{
        // given
        let styleId = 1
        let expectedColors = [CarColorData(colors: [Color](), colorsCount: 0)]
        apiServiceMock.behavior = .alwaysSucceed(expectedColors)

        //when
        let result = await carStyleService.getStylesColors(styleId: styleId)

        //then
        XCTAssertNil(result)
    }

    func test_carStyleColorShouldReturnArrayOfString() async throws{
        // given
        let styleId = 2
        let expectedColors = [CarColorData(colors: [Color(id: "1", name: nil, equipmentType: nil, availability: nil, manufactureOptionName: nil, manufactureOptionCode: nil, category: nil, colorChips: ColorChips(primary: Primary(r: 0, g: 0, b: 0, hex: "123456")), fabricTypes: nil, price: nil),
                                                   Color(id: "1", name: nil, equipmentType: nil, availability: nil, manufactureOptionName: nil, manufactureOptionCode: nil, category: nil, colorChips: ColorChips(primary: Primary(r: 0, g: 0, b: 0, hex: "234567")), fabricTypes: nil, price: nil)], colorsCount: 2)]
        apiServiceMock.behavior = .alwaysSucceed(expectedColors)

        //when
        let result = await carStyleService.getStylesColors(styleId: styleId)
        
        //then
        XCTAssertNotNil(result)
        XCTAssertFalse(result?.isEmpty ?? false)
    }

}
