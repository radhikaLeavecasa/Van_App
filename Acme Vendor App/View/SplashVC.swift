//
//  SplashVC.swift
//  Acme Vendor App
//
//  Created by acme on 04/06/24.
//

import UIKit

class SplashVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now()+2, execute: {
            let userToken = Cookies.getUserToken()
            if userToken != "" {
                if Cookies.userInfo()?.type == "1" { //Admin
                    let vc = ViewControllerHelper.getViewController(ofType: .ListingVC, StoryboardName: .Main) as! ListingVC
                    self.setView(vc: vc)
                } else if Cookies.userInfo()?.type == "2" { //Client
                    let vc = ViewControllerHelper.getViewController(ofType: .ListingVC, StoryboardName: .Main) as! ListingVC
                    self.setView(vc: vc)
                } else if Cookies.userInfo()?.type == "3" { //Supervisor
                    let vc = ViewControllerHelper.getViewController(ofType: .HomeVC, StoryboardName: .Main) as! HomeVC
                    self.setView(vc: vc)
                }
            } else{
                let vc = ViewControllerHelper.getViewController(ofType: .LoginVC, StoryboardName: .Main) as! LoginVC
                self.setView(vc: vc)
            }
        })
    }
}
