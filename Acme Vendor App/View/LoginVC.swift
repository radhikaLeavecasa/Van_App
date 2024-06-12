//
//  LoginVC.swift
//  Acme Vendor App
//
//  Created by acme on 04/06/24.
//

import UIKit

class LoginVC: UIViewController {
    //MARK: - @IBOutlets
    @IBOutlet weak var txtFldEmail: UITextField!
    //MARK: - Variables
    var viewModel = LoginVM()
    //MARK: - Lifecycle method
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    //MARK: - @IBActions
    @IBAction func actionNext(_ sender: Any) {
        if txtFldEmail.text?.isEmptyCheck() == true {
            Proxy.shared.showSnackBar(message: CommonMessage.ENTER_EMAIL)
        } else if txtFldEmail.text?.isValidEmail() == false {
            Proxy.shared.showSnackBar(message: CommonMessage.ENTER_VALID_EMAIL)
        } else {
            let param: [String:AnyObject] = [WSRequestParams.WS_REQS_PARAM_EMAIL: txtFldEmail.text!] as! [String:AnyObject]
            viewModel.loginApi(param) { val, msg in
                if val {
                    let vc = ViewControllerHelper.getViewController(ofType: .OtpVC, StoryboardName: .Main) as! OtpVC
                    vc.email = self.txtFldEmail.text!
                    self.pushView(vc: vc)
                    Proxy.shared.showSnackBar(message: msg)
                } else {
                    if msg == CommonError.INTERNET {
                        Proxy.shared.showSnackBar(message: CommonMessage.NO_INTERNET_CONNECTION)
                    } else {
                        Proxy.shared.showSnackBar(message: msg)
                    }
                }
            }
        }
    }
}
