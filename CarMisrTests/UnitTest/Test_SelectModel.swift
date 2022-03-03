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
        let makeNiceName = "honda"
        //when
        let result = await carModelService.getCarModels(makeNiceName: makeNiceName, pageNumber: pageNumber) as Result<[Model], DataError>
        //then
        XCTAssertEqual(result, .failure(.error("")))
    }
    
    func test_carModelShouldReturnNoModelsMessage() async {
        // given
        let pageNumber = 1
        let makeNiceName = "honda"
        let emptyMessage = Defaults.noModelsMessage
        let expectedModels = [CarModelData(totalNumber: 0, totalPages: 0, models: [ModelData]())]
        apiServiceMock.behavior = .alwaysSucceed(expectedModels)
        //when
        let result = await carModelService.getCarModels(makeNiceName: makeNiceName,pageNumber: pageNumber) as Result<[Model], DataError>
        //then
        XCTAssertEqual(result, .failure(.empty(emptyMessage)))
    }
    
    func test_carModelShouldReturnArrayofModels() async throws{
        // given
        let pageNumber = 1
        let makeNiceName = "honda"
        let expectedModels = [CarModelData(totalNumber: 1, totalPages: 1, models: [ModelData(id: "1", name: "civic", niceName: "civic")]),
                             ModelImagesData(photosData: [PhotoData(title: nil, category: nil, tags: nil, provider: nil, sources: [Source(link: Link(rel: nil, href: nil), sourceExtension: nil, size: nil)], years: nil, submodels: nil, trims: nil, modelYearID: nil, shotTypeAbbreviation: nil, styleIDS: nil, exactStyleIDS: nil)], photosCount: 1, links: nil)] as [Codable]
        apiServiceMock.behavior = .alwaysSucceed(expectedModels)

        //when
        let result = await carModelService.getCarModels(makeNiceName: makeNiceName,pageNumber: pageNumber) as Result<[Model],DataError>
        let models = try result.get()

        //then
        XCTAssertFalse(models.isEmpty)
    }

    func test_carModelShouldNotReturnDuplicates() async throws{
        // given
        let pageNumber = 1
        let makeNiceName = ""
        let expectedModels = [CarModelData(totalNumber: 1, totalPages: 1, models: [ModelData(id: "1", name: "civic", niceName: "civic"),ModelData(id: "1", name: "civic", niceName: "civic")]),
                                                         ModelImagesData(photosData: [PhotoData(title: nil, category: nil, tags: nil, provider: nil, sources: [Source(link: Link(rel: nil, href: nil), sourceExtension: nil, size: nil)], years: nil, submodels: nil, trims: nil, modelYearID: nil, shotTypeAbbreviation: nil, styleIDS: nil, exactStyleIDS: nil)], photosCount: 1, links: nil)] as [Codable]
        apiServiceMock.behavior = .alwaysSucceed(expectedModels)

        //when
        let result = await carModelService.getCarModels(makeNiceName: makeNiceName,pageNumber: pageNumber) as Result<[Model],DataError>
        let models = try result.get()
        let duplicated = Dictionary(grouping: models, by: {$0.id}).filter { $1.count > 1 }.keys
        //then
        XCTAssertTrue(duplicated.isEmpty)
    }
    
    func test_carModelImageShouldReturnEmptyString() async throws{
        // given
        let makeNiceName = "honda"
        let modelNiceName = "civic"
        let expectedModelImages = [ModelImagesData(photosData: [PhotoData(title: nil, category: nil, tags: nil, provider: nil,
                                                                   sources: [Source(link: Link(rel: nil, href: nil), sourceExtension: nil, size: nil)], years: nil, submodels: nil, trims: nil, modelYearID: nil, shotTypeAbbreviation: nil, styleIDS: nil,
                                                                   exactStyleIDS: nil)], photosCount: 1, links: nil)]
        apiServiceMock.behavior = .alwaysSucceed(expectedModelImages)

        //when
        let result = await carModelService.getCarModelImage(makeNiceName: makeNiceName, modelNiceName: modelNiceName)


        //then
        XCTAssertNil(result)
    }

    func test_carModelShouldReturnExteriorModelImage() async throws{
        // given
        let makeNiceName = "honda"
        let modelNiceName = "civic"
        let category : ImageCategory = .exterior
        let expectedModelImages = [ModelImagesData(photosData: [PhotoData(title: nil, category: category, tags: nil, provider: nil,
                                                                   sources: [Source(link: Link(rel: nil, href: "audi/s7/2013/oem/2013_audi_s7_sedan_prestige_fq_oem_6_1600.jpg"), sourceExtension: nil, size: nil)], years: nil, submodels: nil, trims: nil, modelYearID: nil, shotTypeAbbreviation: nil, styleIDS: nil,
                                                                   exactStyleIDS: nil)], photosCount: 1, links: nil)]
        apiServiceMock.behavior = .alwaysSucceed(expectedModelImages)

        //when
        let result = await carModelService.getCarModelImage(makeNiceName: makeNiceName, modelNiceName: modelNiceName)

        //then
        XCTAssertNotNil(result)
    }
}
