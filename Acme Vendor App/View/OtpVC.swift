//
//  OtpVC.swift
//  Acme Vendor App
//
//  Created by acme on 04/06/24.
//

import UIKit
import OTPFieldView

class OtpVC: UIViewController {
    //MARK: - @IBOutlet
    @IBOutlet weak var otpVw: OTPFieldView!
    //MARK: - Variables
    var otp = String()
    var isOtpComplete = false
    var viewModel = OtpVM()
    var email = String()
    //MARK: - Lifecycle method
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        setupOtpView()
    }
    func setupOtpView(){
        self.otpVw.fieldsCount = 4
        self.otpVw.fieldBorderWidth = 2
        self.otpVw.filledBackgroundColor = .white
        self.otpVw.defaultBackgroundColor = .white
        self.otpVw.defaultBorderColor = .APP_BLUE_CLR
        self.otpVw.filledBorderColor = .APP_BLUE_CLR
        self.otpVw.cursorColor = .APP_BLUE_CLR
        self.otpVw.displayType = .square
        self.otpVw.fieldSize = 64
        self.otpVw.separatorSpace = 10
        self.otpVw.shouldAllowIntermediateEditing = true
        self.otpVw.delegate = self
        self.otpVw.initializeUI()
    }
    @IBAction func actionNext(_ sender: Any) {
        if self.isOtpComplete == true {
            let param = [WSRequestParams.WS_REQS_PARAM_EMAIL: self.email,
                         WSRequestParams.WS_REQS_PARAM_PASSWORD: self.otp] as! [String:AnyObject]
            viewModel.otpVerifyApi(param) { val, msg in
                if val {
                    if Cookies.userInfo()?.type == 1 { //Admin
                        let vc = ViewControllerHelper.getViewController(ofType: .ListingVC, StoryboardName: .Main) as! ListingVC
                        self.setView(vc: vc)
                    } else if Cookies.userInfo()?.type == 2 { //Client
                        let vc = ViewControllerHelper.getViewController(ofType: .ListingVC, StoryboardName: .Main) as! ListingVC
                        self.setView(vc: vc)
                    } else if Cookies.userInfo()?.type == 3 { //Supervisor
                        let vc = ViewControllerHelper.getViewController(ofType: .HomeVC, StoryboardName: .Main) as! HomeVC
                        vc.isStart = true
                        self.setView(vc: vc)
                    }
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
    @IBAction func actionBack(_ sender: Any) {
        popView()
    }
}

extension OtpVC: OTPFieldViewDelegate {
    
    func hasEnteredAllOTP(hasEnteredAll hasEntered: Bool) -> Bool {
        //print("Has entered all OTP? \(hasEntered)")
        self.isOtpComplete = hasEntered

        return false
    }
    
    func shouldBecomeFirstResponderForOTP(otpTextFieldIndex index: Int) -> Bool {
        return true
    }
    
    func enteredOTP(otp otpString: String) {
        // print("OTPString: \(otpString)")
        self.otp = otpString
    }
}
