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
    
    func getCarModels(makeNiceName: String, pageNumber: Int) async -> Result<[Model], DataError> {
        let modelEndPoint = MainEndPoints.models((pageNumber, makeNiceName))
        let modelsResult = await apiService.fetchItem(urlRequest:modelEndPoint.urlRequest) as Result<CarModelData,ApiError>
        switch modelsResult{
        case .success(let carModelsData):
            guard let modelsData = carModelsData.models , !modelsData.isEmpty else {
                return .failure(.empty(Defaults.noDataString))
            }
            let models = modelsData.map { modelData ->  Model? in
                guard let modelName = modelData.name,let niceName = modelData.niceName else {
                    return nil
                }
                return Model(id: modelData.id ?? "\(makeNiceName)_\(niceName)" ,name: modelName, niceName: niceName, imageUrl: URL(string: Defaults.imageUrl)!)
            }.compactMap{$0}
            for model in models {
                let imagePath = await getModelImage(makeNiceName: makeNiceName, modelNiceName: model.niceName)
                model.imageUrl = MediaEndPoint.image(path: imagePath).url ?? URL(string: Defaults.imageUrl)!
            }
            return.success(models)
        case .failure(let error):
            return .failure(.error(error.description))
        }
    }
    
    func getModelImage(makeNiceName: String,modelNiceName: String) async -> String {
        let modelImagesEndPoint = MainEndPoints.modelImages((makeNiceName, modelNiceName))
        let modelIamges = await apiService.fetchItem(urlRequest: modelImagesEndPoint.urlRequest) as Result<ModelImagesData,ApiError>
        switch modelIamges{
        case .success(let modelImageData):
            guard let photosData = modelImageData.photosData,
               let photoData = photosData.first(where: { $0.category == .exterior }),
               let source = photoData.sources?.first,
               let link = source.link,
               let photoHref = link.href  else {
                return ""
            }
            return photoHref
        default:
            return ""
        }
    }
    
    actor Store {
        var reviewIds: [Int] = []
        func append(ids: [Int]) {
            reviewIds.append(contentsOf: ids)
        }
    }
}