//
//  LoginModel.swift
//  Acme Vendor App
//
//  Created by acme on 07/06/24.
//

import UIKit
import ObjectMapper

struct ListingModel: Mappable {
    var id: Int?
    var project: String?
    var projectId: String?
    var state: String?
    var district: String?
    var city: String?
    var retailName: String?
    var latitude: String?
    var longitude: String?
    var length: String?
    var width: String?
    var date: String?
    var ownerName: String?
    var email: String?
    var mobile: String?
    var status: String?
    var createdBy: String?
    var approval: String?
    var location: String?
    var ownerSignature: String?
    var image: String?
    var image1: String?
    var image2: String?
    var image3: String?
    var image4: String?
    var remarks: String?
    var asmStatus: String?
    var asmApproverId: String?
    var clientStatus: String?
    var clientApprovalId: String?
    var mgmtStatus: String?
    var mgmtApprovalId: String?
    var shopOwnerStatus: String?
    var shopOwnerApprovalId: String?
    var area: String?
    var asmName: String?
    var asmMobile: String?
    var clientId: String?
    var ownerId: String?
    var retailerCode: String?
    var division: String?
    var createdAt: String?
    var updatedAt: String?
    
    init?(map: Map) {}

    mutating func mapping(map: Map) {
        id <- map["id"]
        project <- map["project"]
        projectId <- map["project_id"]
        state <- map["state"]
        district <- map["district"]
        city <- map["city"]
        retailName <- map["retail_name"]
        latitude <- map["lat"]
        longitude <- map["long"]
        length <- map["length"]
        width <- map["width"]
        date <- map["date"]
        ownerName <- map["owner_name"]
        email <- map["email"]
        mobile <- map["mobile"]
        status <- map["status"]
        createdBy <- map["created_by"]
        approval <- map["approval"]
        location <- map["location"]
        ownerSignature <- map["owner_signature"]
        image <- map["image"]
        image1 <- map["image1"]
        image2 <- map["image2"]
        image3 <- map["image3"]
        image4 <- map["image4"]
        remarks <- map["remarks"]
        asmStatus <- map["asm_status"]
        asmApproverId <- map["asm_approver_id"]
        clientStatus <- map["client_status"]
        clientApprovalId <- map["client_approval_id"]
        mgmtStatus <- map["mgmt_status"]
        mgmtApprovalId <- map["mgmt_approval_id"]
        shopOwnerStatus <- map["shop_owner_status"]
        shopOwnerApprovalId <- map["shop_owner_approval_id"]
        area <- map["area"]
        asmName <- map["asm_name"]
        asmMobile <- map["asm_mobile"]
        clientId <- map["client_id"]
        ownerId <- map["owner_id"]
        retailerCode <- map["retailer_code"]
        division <- map["division"]
        createdAt <- map["created_at"]
        updatedAt <- map["updated_at"]
    }
}
