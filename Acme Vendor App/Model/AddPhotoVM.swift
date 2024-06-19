//
//  AddPhotoVM.swift
//  Acme Vendor App
//
//  Created by acme on 18/06/24.
//

import UIKit

class AddPhotoVM: NSObject {
    func addPhotoDetailsApi(_ api: Api, param:[String:AnyObject], imageParam: [String:UIImage], _ completion: @escaping (Bool,String) -> Void) {
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
