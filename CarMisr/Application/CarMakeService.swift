//
//  MakeCarService.swift
//  CarMisr
//
//  Created by Muhammad Abumandour on 18/02/2022.
//

import Foundation


class CarMakeService : CarMakeProtocol{
    
    let apiService: ApiProtocol
    
    init(apiService: ApiProtocol) {
        self.apiService = apiService
    }
    
    func getCarMakes(pageNumber: Int) async -> Result<[Make], DataError> {
        let makesResult = await apiService.fetchItem(urlString: Urls.getMakesUrl(pageNumber: pageNumber, pageSize: 10)) as Result<CarMakeData,ApiError>
        switch makesResult{
        case .success(let carMakesData):
            guard let makesData = carMakesData.makes , !makesData.isEmpty else {
                return .failure(.empty("No data"))
            }
            let makes = makesData.compactMap({ Make(name: $0.name ?? "default") }).sorted { $0.name < $1.name }
            return .success(makes)
        case .failure(let error):
            return .failure(.error(error.description))
        }
    }
    
}
