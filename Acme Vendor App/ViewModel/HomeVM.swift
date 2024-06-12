//
//  HomeVM.swift
//  Acme Vendor App
//
//  Created by acme on 04/06/24.
//

import UIKit
import Alamofire

class HomeVM: NSObject {
    
    var homeModel: FetchDataModel?
    
    func fetchApi(_ code: String, _ completion: @escaping (Bool,String) -> Void) {
        Proxy.shared.loadAnimation()
        WebService.callApi(api: .fetchApi(code), method: .get, param: [:], header: true) { status, msg, response in
            Proxy.shared.stopAnimation()
            if status == true {
                if let data = response as? [String:Any] {
                    if let data2 = data["data"] as? [String:Any] {
                        self.homeModel = FetchDataModel(JSON: data2)
                        completion(true, "")
                    }
                }
            } else {
                completion(false, msg)
            }
        }
    }
    
    
    func uploadSiteDetails(param:[String:Any],dictImage: [String: UIImage], _ completion: @escaping (Bool,String) -> Void){
        Proxy.shared.loadAnimation()
        WebService.uploadImageWithURL(api: .uploadSiteDetails, dictImage: dictImage, parameter: param) { status, msg, response in
            Proxy.shared.stopAnimation()
            if status == true {
                if let data = response as? [String:Any] {
                    completion(true, msg)
                }
            }else{
                completion(false, msg)
            }
        }
    }
    
    func logoutApi(_ completion: @escaping (Bool,String) -> Void) {
        Proxy.shared.loadAnimation()
        WebService.callApi(api: .logout, method: .post, param: [:], header: true) { status, msg, response in
            Proxy.shared.stopAnimation()
            if status == true {
                completion(true, "")
            } else {
                completion(false, msg)
            }
        }
    }
}
