//
//  CarModelService.swift
//  CarMisr
//
//  Created by Muhammad Abumandour on 20/02/2022.
//

import Foundation

class CarModelService: CarModelProtocol {
    
    let apiService: ApiProtocol
    
    init(apiService: ApiProtocol) {
        self.apiService = apiService
    }
    //here we use async and await instead of serial with sync executions dispatchqueue as async and await more readable than callbacks
    func getCarModels(makeNiceName: String, pageNumber: Int) async -> Result<[Model], DataError> {
        let modelsResult = await getCarModelNames(makeNiceName: makeNiceName, pageNumber: pageNumber) as Result<[Model],ApiError>
        switch modelsResult{
        case .success(let models):
            guard !models.isEmpty else {
                return .failure(.empty(Defaults.noModelsMessage))
            }
            for model in models {
                let imagePath = await getModelImage(makeNiceName: makeNiceName, modelNiceName: model.modelNiceName)
                if let imagePath = imagePath {
                    model.imageUrl = MediaEndPoint.image(path: imagePath).url ?? URL(string: Defaults.imageUrl)!
                }
                let colors = await getModelColors(styleId: model.styleId)
                if let colors = colors {
                    model.colors = colors
                }
            }
            return.success(models)
        case .failure(let error):
            return .failure(.error(error.description))
        }
    }
    
    // we will get models name ,niceName and Id without duplicated values and only 2022
    func getCarModelNames(makeNiceName: String, pageNumber: Int) async -> Result<[Model],ApiError> {
        let modelEndPoint = MainEndPoints.models((pageNumber, makeNiceName))
        let stylesDataResult = await apiService.fetchItem(urlRequest:modelEndPoint.urlRequest) as Result<CarStyleData,ApiError>
        switch stylesDataResult{
        case .success(let carStylesData):
            guard let stylesData = carStylesData.styles , !stylesData.isEmpty else {
                return .success([Model]())
            }
            let models = stylesData.map { styleData ->  Model? in
                guard let modelId = styleData.modelId , let id = styleData.id , let name = styleData.name, let modelNiceName = styleData.modelNiceName else {
                    return nil
                }
                return Model(id: modelId,
                             name: name,
                             modelNiceName: modelNiceName,
                             imageUrl: URL(string: Defaults.imageUrl)!, // we will add image later from another API call
                             styleId: id,
                             transmissionType: styleData.transmissionType ?? "-",
                             engineType: styleData.engineType ?? "-",
                             engineSize: String(styleData.engineSize ?? 0),
                             numberOfSeats: String(styleData.numberOfSeats ?? 0),
                             vehicleType: styleData.categories?.vehicleType?.first ?? "-",
                             colors: [String]()) // we will add colors later from another API call
            }.compactMap{$0}.uniqueValues()
            return.success(models)
        case .failure(let error):
            return .failure(error)
        }
    }
    // here we will get image url only for 2022 only and without duplicated
    func getModelImage(makeNiceName: String,modelNiceName: String) async -> String? {
        let modelImagesEndPoint = MainEndPoints.modelImages((makeNiceName, modelNiceName))
        let modelIamges = await apiService.fetchItem(urlRequest: modelImagesEndPoint.urlRequest) as Result<ModelImagesData,ApiError>
        switch modelIamges{
        case .success(let modelImageData):
            guard let photosData = modelImageData.photosData,
               let photoData = photosData.first(where: { $0.category == .exterior }),
               let source = photoData.sources?.first,
               let link = source.link,
               let photoHref = link.href  else {
                return nil
            }
            return photoHref
        default:
            return nil
        }
    }
    
    // here we will get colors only for 2022 only and without duplicated
    func getModelColors(styleId: Int) async -> [String]? {
        let colorEndPoint = MainEndPoints.colors(styleId: styleId)
        let modelColorResult = await apiService.fetchItem(urlRequest: colorEndPoint.urlRequest) as Result<CarColorData,ApiError>
        switch modelColorResult {
        case .success(let modelColorData):
            guard let colors = modelColorData.colors , !colors.isEmpty else {
                return nil
            }
            return colors.compactMap { $0.colorChips?.primary?.hex }
        default:
            return nil
        }
    }
}
