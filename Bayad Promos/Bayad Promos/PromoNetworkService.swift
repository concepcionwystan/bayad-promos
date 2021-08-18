//
//  PromoNetworkService.swift
//  Bayad Promos
//
//  Created by Application Developer 9 on 8/18/21.
//

import Foundation
import Alamofire

class PromoNetworkService {
    
    // MARK:Endpoint ID
    private var endpointID = "c5bef1a7a17c46adb12559a061a2181f"
    
    
    // MARK:GET all promos in homescreen
    func getAllPromos(viewController: PromosListViewController){
        AF.request("https://crudcrud.com/api/\(endpointID)/bayad").responseDecodable(of: [Promo].self) {
            response in
            let res = response.result
            switch res {
                case .success(let getAllPromosResponse):
                    viewController.handleGetAllPromosResponse(success: true, getAllPromosResponse: getAllPromosResponse, error: nil)
                
                case .failure(let error):
                    viewController.handleGetAllPromosResponse(success: false, getAllPromosResponse: nil, error: error)
                }
        }
    }
    
    // MARK:PUT promo
    func putPromo(viewController: PromoDetailsViewController, id: String, params: PUTPromoRequest){
        AF.request("https://crudcrud.com/api/\(endpointID)/bayad/\(id)", method: .put, parameters: params, encoder: JSONParameterEncoder.default, headers: nil, interceptor: nil).response { response in
            let res = response.result
            print(res)
            switch res {
                case .success( _):
                    viewController.handlePutPromoResponse(success: true, error: nil)
                
                case .failure(let error):
                    viewController.handlePutPromoResponse(success: false, error: error)
                }
        }
    }
    
    // MARK:DELETE promo
    func deletePromo(viewController: PromosListViewController, id: String){
        AF.request("https://crudcrud.com/api/\(endpointID)/bayad/\(id)", method: .delete).response { response in
            let res = response.result
            print(res)
            switch res {
                case .success( _):
                    viewController.handleDeletePromoResponse(success: true, error: nil)
                
                case .failure(let error):
                    viewController.handleDeletePromoResponse(success: false, error: error)
                }
        }
    }
    
    
    
}
