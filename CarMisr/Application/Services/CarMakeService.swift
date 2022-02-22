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
        let makeEndPoint = MainEndPoints.makes(pageNumber: pageNumber)
        let makesResult = await apiService.fetchItem(urlRequest: makeEndPoint.urlRequest) as Result<CarMakeData,ApiError>
        switch makesResult{
        case .success(let carMakesData):
            guard let makesData = carMakesData.makes , !makesData.isEmpty else {
                return .failure(.empty(Defaults.noDataString))
            }
            let makes = makesData.map { makeData -> Make? in
                if let name = makeData.name, let niceName = makeData.niceName {
                    return Make(name: name , niceName: niceName)
                } else {
                    return nil
                }
            }.compactMap({ $0 }).sorted(by: {$0.name < $1.name})
            return .success(makes)
        case .failure(let error):
            return .failure(.error(error.description))
        }
    }
    
}
