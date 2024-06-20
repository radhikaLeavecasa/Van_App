//
//  MapVM.swift
//  Acme Vendor App
//
//  Created by acme on 20/06/24.
//

import UIKit
import ObjectMapper

class MapVM: NSObject {
    
    var vanDetail: [LocationDetailModel] = []
    var vanLocation: [LocationDetailModel] = []
    
    func getLocationDetailsApi(_ vanNo: String, completion: @escaping(Bool, String) -> Void) {
        Proxy.shared.loadAnimation()
        vanDetail = []
        WebService.callApi(api: .mapLocations(vanNo), method: .get, param: [:]) { status, msg, response in
            Proxy.shared.stopAnimation()
            if status == true {
                if let data = response as? [String:Any],
                   let arrListing = data["data"] as? [[String: Any]] {
                    // Use ObjectMapper to map the array directly
                    self.vanDetail = Mapper<LocationDetailModel>().mapArray(JSONArray: arrListing)
                    completion(true, "")
                }
            } else {
                completion(false, msg)
            }
        }
    }
    
    func getCurrentTrackApi(completion: @escaping (Bool, String) -> Void) {
        WebService.callApi(api: .mapApi, method: .get, param: [:]) { status, msg, response in
            if status {
                if let data = response as? [String: Any],
                   let arrListing = data["data"] as? [String: Any],
                   let data2 = arrListing["list"] as? [[String: Any]] {
                    
                    // Use ObjectMapper to map the array directly
                    self.vanLocation = Mapper<LocationDetailModel>().mapArray(JSONArray: data2)
                    
                    if self.vanLocation.isEmpty {
                        completion(false, "Failed to map location data")
                    } else {
                        completion(true, "")
                    }
                    
                } else {
                    completion(false, "Invalid data format")
                }
            } else {
                completion(false, msg)
            }
        }
    }
}
