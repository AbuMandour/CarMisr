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
                let imagePath = await getModelImage(makeNiceName: makeNiceName, modelNiceName: model.niceName)
                if let imagePath = imagePath {
                    model.imageUrl = MediaEndPoint.image(path: imagePath).url ?? URL(string: Defaults.imageUrl)!
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
        let modelsDataResult = await apiService.fetchItem(urlRequest:modelEndPoint.urlRequest) as Result<CarModelData,ApiError>
        switch modelsDataResult{
        case .success(let carModelsData):
            guard let modelsData = carModelsData.models , !modelsData.isEmpty else {
                return .success([Model]())
            }
            let models = modelsData.map { modelData ->  Model? in
                guard let modelName = modelData.name,let niceName = modelData.niceName else {
                    return nil
                }
                return Model(id: modelData.id ?? "\(makeNiceName)_\(niceName)" ,
                             name: modelName,
                             niceName: niceName,
                             imageUrl: URL(string: Defaults.imageUrl)!)
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
}
