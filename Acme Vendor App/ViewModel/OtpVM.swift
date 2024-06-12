//
//  OtpVM.swift
//  Acme Vendor App
//
//  Created by acme on 04/06/24.
//

import UIKit

class OtpVM: NSObject {
    
    func otpVerifyApi(_ param:[String:AnyObject], _ completion: @escaping (Bool,String) -> Void) {
        Proxy.shared.loadAnimation()
        WebService.callApi(api: .verifyOtp, method: .post, param: param, header: true) { status, msg, response in
            Proxy.shared.stopAnimation()
            if status == true {
                if let data = response as? [String:Any] {
                    let userData = data[CommonParam.DATA] as? [String:Any]
                    Cookies.userInfoSave(dict:userData)
                    GetData.share.saveUserToken(token: userData?[CommonParam.USER_TOKEN] as? String ?? "")
                    completion(true, "")
                }
            } else {
                completion(true, msg)
            }
        }
    }
}
