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
            let models = modelsData.map { modelData -> Model? in
                guard let modelName = modelData.name,let niceName = modelData.niceName else {
                    return nil
                }
                return Model(name: modelName, niceName: niceName, imageUrl: "")
            }.compactMap{$0}
            return.success(models)
        case .failure(let error):
            return .failure(.error(error.description))
        }
    }
}
