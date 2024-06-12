//
//  LoginVM.swift
//  Acme Vendor App
//
//  Created by acme on 04/06/24.
//

import UIKit

class LoginVM: NSObject {
    func loginApi(_ param:[String:AnyObject], _ completion: @escaping (Bool,String) -> Void) {
        Proxy.shared.loadAnimation()
        WebService.callApi(api: .login, method: .post, param: param, header: true) { status, msg, response in
            Proxy.shared.stopAnimation()
            if status == true {
                if let data = response as? [String:Any] {
                    completion(true, msg)
                }
            } else {
                completion(false, msg)
            }
        }
    }
}
