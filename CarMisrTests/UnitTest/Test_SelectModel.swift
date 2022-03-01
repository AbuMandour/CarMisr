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
    
    func test_carModelShouldReturnNoModelsMessage() async {
        // given
        let pageNumber = 1
        let makeNiceName = "honda"
        let noModelsMessage = Defaults.noModelsMessage
        let expectedMakes = CarModelData(totalNumber: 0, totalPages: 0, models: [ModelData]())
        apiServiceMock.behavior = .alwaysSucceed(expectedMakes)
        //when
        let result = await carModelService.getCarModels(makeNiceName: makeNiceName,pageNumber: pageNumber) as Result<[Model], DataError>
        //then
        XCTAssertEqual(result, .failure(.empty(noModelsMessage)))
    }
    
    func test_carModelShouldReturnArrayofModelNames() async throws{
        // given
        let pageNumber = 1
        let makeNiceName = "honda"
        let expectedMakes = CarModelData(totalNumber: 1, totalPages: 1, models: [ModelData(id: "1", name: "Civic", niceName: "civic")])
        apiServiceMock.behavior = .alwaysSucceed(expectedMakes)
        
        //when
        let result = await carModelService.getCarModelNames(makeNiceName: makeNiceName,pageNumber: pageNumber) as Result<[Model],ApiError>
        let models = try result.get()
                
        //then
        XCTAssertFalse(models.isEmpty)
    }
    
    func test_carModelShouldReturnEmptyString() async throws{
        // given
        let makeNiceName = "honda"
        let modelNiceName = "civic"
        let expectedMakes = ModelImagesData(photosData: [PhotoData(title: nil, category: nil, tags: nil, provider: nil,
                                                                   sources: [Source(link: Link(rel: nil, href: nil), sourceExtension: nil, size: nil)], years: nil, submodels: nil, trims: nil, modelYearID: nil, shotTypeAbbreviation: nil, styleIDS: nil,
                                                                   exactStyleIDS: nil)], photosCount: 1, links: nil)
        apiServiceMock.behavior = .alwaysSucceed(expectedMakes)
        
        //when
        let result = await carModelService.getModelImage(makeNiceName: makeNiceName, modelNiceName: modelNiceName)
        
                
        //then
        XCTAssertNil(result)
    }
    
    func test_carModelShouldReturnExteriorModelImage() async throws{
        // given
        let makeNiceName = "honda"
        let modelNiceName = "civic"
        let category : ImageCategory = .exterior
        let expectedMakes = ModelImagesData(photosData: [PhotoData(title: nil, category: category, tags: nil, provider: nil,
                                                                   sources: [Source(link: Link(rel: nil, href: "audi/s7/2013/oem/2013_audi_s7_sedan_prestige_fq_oem_6_1600.jpg"), sourceExtension: nil, size: nil)], years: nil, submodels: nil, trims: nil, modelYearID: nil, shotTypeAbbreviation: nil, styleIDS: nil,
                                                                   exactStyleIDS: nil)], photosCount: 1, links: nil)
        apiServiceMock.behavior = .alwaysSucceed(expectedMakes)
        
        //when
        let result = await carModelService.getModelImage(makeNiceName: makeNiceName, modelNiceName: modelNiceName)
                        
        //then
        XCTAssertNotNil(result)
    }
    
    func test_carModelShouldNotReturnDuplicates() async throws{
        // given
        let pageNumber = 1
        let makeNiceName = ""
        let expectedMakes = CarModelData(totalNumber: 1, totalPages: 1, models: [ModelData(id: "1", name: "Civic", niceName: "civic"),
                                                                                 ModelData(id: "1", name: "Civic", niceName: "civic")])
        apiServiceMock.behavior = .alwaysSucceed(expectedMakes)
        
        //when
        let result = await carModelService.getCarModelNames(makeNiceName: makeNiceName,pageNumber: pageNumber) as Result<[Model],ApiError>
        let models = try result.get()
        let duplicated = Dictionary(grouping: models, by: {$0.id}).filter { $1.count > 1 }.keys
        //then
        XCTAssertTrue(duplicated.isEmpty)
    }
}
