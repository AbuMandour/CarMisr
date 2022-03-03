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
        let modelEndPoint = MainEndPoints.models((pageNumber, makeNiceName))
        let modelsResult = await apiService.fetchItem(urlRequest:modelEndPoint.urlRequest) as Result<CarModelData,ApiError>
        switch modelsResult{
        case .success(let carModelsData):
            guard let modelsData = carModelsData.models , !modelsData.isEmpty else {
                return .failure(.empty(Defaults.noModelsMessage))
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
            for model in models {
                let imagePath = await getCarModelImage(makeNiceName: makeNiceName, modelNiceName: model.niceName)
                if let imagePath = imagePath {
                    model.imageUrl = MediaEndPoint.image(path: imagePath).url ?? URL(string: Defaults.imageUrl)!
                }
            }
            return.success(models)
        case .failure(let error):
            return .failure(.error(error.description))
        }
    }
    
    
    // here we will get image url only for 2022 only and without duplicated
    func getCarModelImage(makeNiceName: String,modelNiceName: String) async -> String? {
        let modelImagesEndPoint = MainEndPoints.modelImages((makeNiceName, modelNiceName))
        let modelIamges = await apiService.fetchItem(urlRequest: modelImagesEndPoint.urlRequest) as Result<CarImageData,ApiError>
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
