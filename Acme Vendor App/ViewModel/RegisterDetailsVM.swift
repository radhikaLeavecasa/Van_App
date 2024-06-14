//
//  RegisterDetailsVM.swift
//  Acme Vendor App
//
//  Created by acme on 14/06/24.
//

import UIKit

class RegisterDetailsVM: NSObject {
    func vanDriverHelperSupervisorPostApi(_ api: Api, param: [String:Any], imageParam: [String: UIImage], completion: @escaping(Bool, String) -> Void) {
        Proxy.shared.loadAnimation()
        WebService.uploadImageWithURL(api: api, dictImage: imageParam, parameter: param) { status, msg, response in
            Proxy.shared.stopAnimation()
            if status == true {
                if let data = response as? [String:Any] {
                    completion(true, msg)
                }
            }else{
                completion(false, msg)
            }
        }
    }
}
