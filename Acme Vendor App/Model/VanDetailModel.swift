//
//  VanDetailModel.swift
//  Acme Vendor App
//
//  Created by acme on 14/06/24.
//

import UIKit
import ObjectMapper

struct VanDetailModel: Mappable {
    var id: Int?
    var regCertificateNo: String?
    var populationCertificateNo: String?
    var insuranceCertificateNo: String?
    var regCertificateImage: String?
    var populationCertificateImage: String?
    var insuranceCertificateImage: String?
    var vanNumber: String?
    var commercialLicenceNo: String?
    var commercialLicenceImage: String?
    var createdAt: String?
    var updatedAt: String?
    var activity: [Activity]?
    var driver: [DriverListing]?
    var helper: [DriverListing]?
    var promoter: [DriverListing]?

    init?(map: Map) {}

    mutating func mapping(map: Map) {
        id <- map["id"]
        regCertificateNo <- map["reg_certificate_no"]
        populationCertificateNo <- map["population_certificate_no"]
        insuranceCertificateNo <- map["insurance_certificate_no"]
        regCertificateImage <- map["reg_certificate_image"]
        populationCertificateImage <- map["population_certificate_image"]
        insuranceCertificateImage <- map["insurance_certificate_image"]
        vanNumber <- map["van_number"]
        commercialLicenceNo <- map["commercial_licence_no"]
        commercialLicenceImage <- map["commercial_licence_image"]
        createdAt <- map["created_at"]
        updatedAt <- map["updated_at"]
        activity <- map["activity"]
        driver <- map["driver"]
        helper <- map["helper"]
        promoter <- map["promoter"]
    }
}

struct Activity: Mappable {
    var id: Int?
    var vanId: String?
    var frontImage: String?
    var backImage: String?
    var leftImage: String?
    var rightImage: String?
    var meterImage: String?
    var meter: String?
    var totalMeter: String?
    var createdBy: String?
    var location: String?
    var lat: String?
    var long: String?
    var dayEndMeter: String?
    var dayEndMeterImage: String?
    var status: String?
    var dayEndLat: String?
    var dayEndLong: String?
    var createdAt: String?
    var updatedAt: String?

    init?(map: Map) {}

    mutating func mapping(map: Map) {
        id <- map["id"]
        vanId <- map["van_id"]
        frontImage <- map["front_image"]
        backImage <- map["back_image"]
        leftImage <- map["left_image"]
        rightImage <- map["right_image"]
        meterImage <- map["meter_image"]
        meter <- map["meter"]
        totalMeter <- map["total_meter"]
        createdBy <- map["created_by"]
        location <- map["location"]
        lat <- map["lat"]
        long <- map["long"]
        dayEndMeter <- map["day_end_meter"]
        dayEndMeterImage <- map["day_end_meter_image"]
        status <- map["status"]
        dayEndLat <- map["day_end_lat"]
        dayEndLong <- map["day_end_long"]
        createdAt <- map["created_at"]
        updatedAt <- map["updated_at"]
    }
}
