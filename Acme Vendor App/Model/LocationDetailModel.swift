//
//  LocationDetailModel.swift
//  Acme Vendor App
//
//  Created by acme on 20/06/24.
//

import UIKit
import ObjectMapper

struct LocationDetailModel: Mappable {
    var id: String?
    var ignition: Bool?
    var vehicleNumber: String?
    var deviceNumber: String?
    var vendorCode: String?
    var vendorName: String?
    var latitude: Double?
    var longitude: Double?
    var latitudeStr: String?
    var longitudeStr: String?
    var speed: Double?
    var createdDate: String?
    var createdDateReadable: String?
    var location: String?
    var provider: String?
    var vehicleType: String?
    var chargeOn: String?
    var dttime: String?
    var dttimeInEpoch: Int?
    var angle: String?
    var accurate: String?
    var createdAt: String?
    var updatedAt: String?
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        ignition <- map["ignition"]
        vehicleNumber <- map["vehicleNumber"]
        deviceNumber <- map["deviceNumber"]
        vendorCode <- map["vendorCode"]
        vendorName <- map["venndorName"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        latitudeStr <- map["latitude"]
        longitudeStr <- map["longitude"]
        speed <- map["speed"]
        createdDate <- map["createdDate"]
        createdDateReadable <- map["createdDateReadable"]
        location <- map["location"]
        provider <- map["provider"]
        vehicleType <- map["vehicleType"]
        chargeOn <- map["chargeOn"]
        dttime <- map["dttime"]
        dttimeInEpoch <- map["dttimeInEpoch"]
        angle <- map["angle"]
        accurate <- map["accurate"]
        createdAt <- map["created_at"]
        updatedAt <- map["updated_at"]
    }
}
