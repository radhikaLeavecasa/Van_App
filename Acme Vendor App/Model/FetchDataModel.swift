//
//  FetchDataModel.swift
//  Acme Vendor App
//
//  Created by acme on 04/06/24.
//

import UIKit
import ObjectMapper

struct FetchDataModel: Mappable {
    var address: String?
    var asmContact: String?
    var asmName: String?
    var city: String?
    var code: Int?
    var contact: String?
    var district: String?
    var division: String?
    var retailerCode: String?
    var retailerName: String?
    var state: String?

    init?(map: Map) {}

    mutating func mapping(map: Map) {
        address <- map["address"]
        asmContact <- map["asm_contact"]
        asmName <- map["asm_name"]
        city <- map["city"]
        code <- map["code"]
        contact <- map["contact"]
        district <- map["district"]
        division <- map["division"]
        retailerCode <- map["retailer_code"]
        retailerName <- map["retailer_name"]
        state <- map["state"]
    }
}
