//
//  LoginModel.swift
//  Acme Vendor App
//
//  Created by acme on 07/06/24.
//

import UIKit
import ObjectMapper

struct ListingModel: Mappable {
    var commercialLicenceImage: String?
    var commercialLicenceNo: String?
    var createdAt: String?
    var id: Int?
    var insuranceCertificateImage: String?
    var insuranceCertificateNo: String?
    var populationCertificateImage: String?
    var populationCertificateNo: String?
    var regCertificateImage: String?
    var regCertificateNo: String?
    var updatedAt: String?
    var vanNumber: String?
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        commercialLicenceImage <- map["commercial_licence_image"]
        commercialLicenceNo <- map["commercial_licence_no"]
        createdAt <- map["created_at"]
        id <- map["id"]
        insuranceCertificateImage <- map["insurance_certificate_image"]
        insuranceCertificateNo <- map["insurance_certificate_no"]
        populationCertificateImage <- map["population_certificate_image"]
        populationCertificateNo <- map["population_certificate_no"]
        regCertificateImage <- map["reg_certificate_image"]
        regCertificateNo <- map["reg_certificate_no"]
        updatedAt <- map["updated_at"]
        vanNumber <- map["van_number"]
    }
}

struct DriverListing: Mappable {
    var aadhar: String?
    var aadharb: String?
    var createdAt: String?
    var drivingLicence: String?
    var email: String?
    var id: Int?
    var image: String?
    var name: String?
    var phone: String?
    var updatedAt: String?
    var vanId: String?

    init?(map: Map) {}

    mutating func mapping(map: Map) {
        aadhar <- map["aadhar"]
        aadharb <- map["aadharb"]
        createdAt <- map["created_at"]
        drivingLicence <- map["driving_licence"]
        email <- map["email"]
        id <- map["id"]
        image <- map["image"]
        name <- map["name"]
        phone <- map["phone"]
        updatedAt <- map["updated_at"]
        vanId <- map["van_id"]
    }
}
