//
//  Api.swift
//  Josh
//
//  Created by Esfera-Macmini on 12/04/22.
//

import Foundation

let baseUrl = "https://van.acmemedia.in/api/"
let imageBaseUrl = "https://van.acmemedia.in/"

extension Api {
    func baseURl() -> String {
        return (baseUrl + self.rawValued()).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    }
}

enum Api: Equatable {
    
    case fetchApi(_ code: String)
    case uploadSiteDetails
    case asmSiteListing(_ name: String)
    case asmSiteApproved(_ name: String)
    case asmSiteRejected(_ name: String)
    case asmSitePending(_ name: String)
    case supervisorListing(_ code: Int)
    case supervisorApproved(_ code: Int)
    case supervisorRejected(_ code: Int)
    case supervisorPending(_ code: Int)
    case acceptReject
    
    //Van App
    case logout
    case login
    case verifyOtp
    case vanApi
    case promotorApi
    case driverApi
    case helperApi
   
    func rawValued() -> String {
        switch self {
        //Van App
        case .logout:
            return "logout"
        case .login:
            return "login"
        case .verifyOtp:
            return "verifyLogin"
        case .vanApi:
            return "van"
        case .promotorApi:
            return "promotor"
        case .driverApi:
            return "driver"
        case .helperApi:
            return "helper"
            
        case let .fetchApi(code):
            return "rcode/\(code)"
        case .uploadSiteDetails:
            return "project"
        case let .asmSiteListing(name):
            return "asm-project/\(name)"
        case let .asmSiteApproved(name):
            return "asm-approved-project/\(name)"
        case let .asmSiteRejected(name):
            return "asm-rejected-project/\(name)"
        case let .asmSitePending(name):
            return "asm-pending-project/\(name)"
            
        case let .supervisorListing(code):
            return "supervisor-project/\(code)"
        case let .supervisorApproved(code):
            return "supervisor-approved-project/\(code)"
        case let .supervisorRejected(code):
            return "supervisor-rejected-project/\(code)"
        case let .supervisorPending(code):
            return "supervisor-pending-project/\(code)"
            
        case .acceptReject:
            return "asm-approval"
        }
    }
}

func isSuccess(json : [String : Any]) -> Bool{
    if let isSucess = json["status"] as? Int {
        if isSucess == 200 {
            return true
        }
    }
    if let isSucess = json["status"] as? String {
        if isSucess == "200" {
            return true
        }
    }
    if let isSucess = json["success"] as? String {
        if isSucess == "200" {
            return true
        }
    }
    if let isSucess = json["status"] as? String {
        if isSucess == "success" {
            return true
        }
    }
    if let isSucess = json["success"] as? Int {
        if isSucess == 200 {
            return true
        }
    }
    
    if let isSucess = json["Status Code"] as? Int {
        if isSucess == 200 {
            return true
        }
    }
    if let isSucess = json["code"] as? Int {
        if isSucess == 200 {
            return true
        }
    }
    if let isSucess = json["success"] as? Bool {
        if isSucess == true {
            return true
        }
    }
    
    if let isSucess = json["status"] as? Bool {
        if isSucess == true {
            return true
        }
    }
    return false
}

func isInActivate(json : [String : Any]) -> Bool{
    if let isSucess = json["code"] as? Int {
        if isSucess == 401 {
            return true
        }
    }
    return false
}

func isAlreadyLogin(json : [String : Any]) -> Bool{
    if let isSucess = json["code"] as? Int {
        if isSucess == 403 {
            return true
        }
    }
    return false
}

func isAlreadyAdded(json : [String : Any]) -> Bool{
    if let isSucess = json["status"] as? Int {
        if isSucess == 405 {
            return true
        }
    }
    return false
}

func isDocumentVerificationFalse(json : [String : Any]) -> Bool{
    if let isSucess = json["status"] as? Int {
        if isSucess == 402 {
            return true
        }
    }
    return false
}

func isMobileVarifiedFalse(json : [String : Any]) -> Bool{
    if let isSucess = json["status"] as? Int {
        if isSucess == 402 {
            return true
        }
    }
    return false
}

func message(json : [String : Any]) -> String{
    if let message = json["message"] as? String {
        return message
    }
    if let message = json["message"] as? [String:Any] {
        if let msg = message.values.first as? [String] {
            return msg[0]
        }
    }
    if let error = json["error"] as? String {
        return error
    }
    
    return " "
}

func isBodyCount(json : [[String : Any]]) -> Int{
    return json.count
}
