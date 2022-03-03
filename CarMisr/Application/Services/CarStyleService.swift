//
//  CarStyleService.swift
//  CarMisr
//
//  Created by Muhammad Abumandour on 03/03/2022.
//

import Foundation

class CarStyleService: CarStyleProtocol {
    
    let apiService: ApiProtocol
    
    init(apiService: ApiProtocol) {
        self.apiService = apiService
    }
    
    func getCarStyles(modelNiceName: String, pageNumber: Int) async -> Result<[Style], DataError> {
        let styleEndPoint = MainEndPoints.styles((pageNumber,modelNiceName))
        let stylesDataResult = await apiService.fetchItem(urlRequest: styleEndPoint.urlRequest) as Result<CarStyleData,ApiError>
        switch stylesDataResult{
        case .success(let carStylesData):
            guard let stylesData = carStylesData.styles , !stylesData.isEmpty else {
                return .failure(.empty(Defaults.noDataMessage))
            }
            let styles = stylesData.map { styleData ->  Style? in
                guard let id = styleData.id , let name = styleData.name else {
                    return nil
                }
                return Style(id: id,
                             name: name,
                             niceName: styleData.niceName ?? name.lowercased().trimmingCharacters(in: CharacterSet.whitespacesAndNewlines),
                             transmissionType: styleData.transmissionType ?? "-",
                             engineType: styleData.engineType ?? "-",
                             engineSize: String(styleData.engineSize ?? 0),
                             numberOfSeats: String(styleData.numberOfSeats ?? 0),
                             vehicleStyle: styleData.categories?.vehicleStyle?.first ?? "-",
                             vehicleType: styleData.categories?.vehicleType?.first ?? "-",
                             colors: [String]()) //this default value and we will add colors later from another API call
            }.compactMap{$0}.uniqueValues()
            //get colors for each style
            for style in styles {
                let colors = await getStylesColors(styleId: style.id)
                if let colors = colors {
                    style.colors = colors
                }
            }
            return.success(styles)
        case .failure(let error):
            return .failure(.error(error.description))
        }
    }
    
    // here we will get colors only for 2022 only and without duplicated
    func getStylesColors(styleId: Int) async -> [String]? {
        let colorEndPoint = MainEndPoints.colors(styleId: styleId)
        let modelColorResult = await apiService.fetchItem(urlRequest: colorEndPoint.urlRequest) as Result<CarColorData,ApiError>
        switch modelColorResult {
        case .success(let modelColorData):
            guard let colors = modelColorData.colors , !colors.isEmpty else {
                return nil
            }
            return colors.compactMap {  $0.colorChips?.primary?.hex }
        default:
            return nil
        }
    }
}
