//
//  HomeVM.swift
//  Acme Vendor App
//
//  Created by acme on 04/06/24.
//

import UIKit
import Alamofire
import ObjectMapper

class HomeVM: NSObject {
    var vanDetail: VanDetailModel?
    
    func getVanDetailsApi(_ vanNo: String, completion: @escaping(Bool, String) -> Void) {
        Proxy.shared.loadAnimation()
        WebService.callApi(api: .vanDetail(vanNo), method: .get, param: [:]) { status, msg, response in
            Proxy.shared.stopAnimation()
            if status == true {
                if let data = response as? [String:Any] {
                    if let data = data["data"] as? [String: Any] {
                        if let data = Mapper<VanDetailModel>().map(JSON: data) as VanDetailModel? {
                            self.vanDetail = data
                        }
                    }
                    completion(true, "")
                }
            } else {
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
