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
        
        let modelsResult = await apiService.fetchItem(urlString: Urls.getModelsUrl(makeNiceName: makeNiceName, pageNumber: pageNumber, pageSize: 10)) as Result<CarModelData,ApiError>
        switch modelsResult{
        case .success(let carModelsData):
            guard let modelsData = carModelsData.models , !modelsData.isEmpty else {
                return .failure(.empty(Defaults.noDataString))
            }
            let models = modelsData.map { modelData -> Model in
                Model(name: modelData.name!, niceName: modelData.niceName ?? "", imageUrl: "", year: 2022, isNew: true)
            }.compactMap{$0}
            return.success(models)
        case .failure(let error):
            return .failure(.error(error.description))
        }
    }
}
