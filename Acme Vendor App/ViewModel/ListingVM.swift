//
//  ListingVM.swift
//  Acme Vendor App
//
//  Created by acme on 07/06/24.
//

import UIKit
import ObjectMapper
import Alamofire

class ListingVM: NSObject {
    //MARK: - Variables
    
    
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
    
    func getPostVanApi(_ method: HTTPMethod, completion: @escaping(Bool, String) -> Void) {
        Proxy.shared.loadAnimation()
        WebService.callApi(api: .vanApi, method: method, param: [:], header: true) { status, msg, response in
            Proxy.shared.stopAnimation()
            if status == true {
                if let data = response as? [String:Any] {
//                    if let arrListing = data["data"] as? [[String: Any]] , let data2 = Mapper<ListingModel>().mapArray(JSONArray: arrListing) as [ListingModel]? {
//                        self.arrListing?.append(contentsOf: data2)
//                    }
                    completion(true, "")
                }
            } else {
                completion(true, msg)
            }
        }
    }
    func getPostDriverApi(_ method: HTTPMethod, completion: @escaping(Bool, String) -> Void) {
        Proxy.shared.loadAnimation()
        WebService.callApi(api: .driverApi, method: method, param: [:], header: true) { status, msg, response in
            Proxy.shared.stopAnimation()
            if status == true {
                if let data = response as? [String:Any] {
//                    if let arrListing = data["data"] as? [[String: Any]] , let data2 = Mapper<ListingModel>().mapArray(JSONArray: arrListing) as [ListingModel]? {
//                        self.arrListing?.append(contentsOf: data2)
//                    }
                    completion(true, "")
                }
            } else {
                completion(true, msg)
            }
        }
    }
    func getPostSupervisorApi(_ method: HTTPMethod, completion: @escaping(Bool, String) -> Void) {
        Proxy.shared.loadAnimation()
        WebService.callApi(api: .promotorApi, method: method, param: [:], header: true) { status, msg, response in
            Proxy.shared.stopAnimation()
            if status == true {
                if let data = response as? [String:Any] {
//                    if let arrListing = data["data"] as? [[String: Any]] , let data2 = Mapper<ListingModel>().mapArray(JSONArray: arrListing) as [ListingModel]? {
//                        self.arrListing?.append(contentsOf: data2)
//                    }
                    completion(true, "")
                }
            } else {
                completion(true, msg)
            }
        }
    }
    func getPostHelperApi(_ method: HTTPMethod, completion: @escaping(Bool, String) -> Void) {
        Proxy.shared.loadAnimation()
        WebService.callApi(api: .helperApi, method: method, param: [:], header: true) { status, msg, response in
            Proxy.shared.stopAnimation()
            if status == true {
                if let data = response as? [String:Any] {
//                    if let arrListing = data["data"] as? [[String: Any]] , let data2 = Mapper<ListingModel>().mapArray(JSONArray: arrListing) as [ListingModel]? {
//                        self.arrListing?.append(contentsOf: data2)
//                    }
                    completion(true, "")
                }
            } else {
                completion(true, msg)
            }
        }
    }
}
