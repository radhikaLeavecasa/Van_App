//
//  RegisterDetailsVC.swift
//  Acme Vendor App
//
//  Created by acme on 13/06/24.
//

import UIKit

class RegisterDetailsVC: UIViewController {
    //MARK: - @IBOutlets
    @IBOutlet weak var vwStackSupervisor: UIStackView!
    @IBOutlet weak var vwStackHelper: UIStackView!
    @IBOutlet weak var vwStackDriver: UIStackView!
    @IBOutlet weak var vwStackVan: UIStackView!
    @IBOutlet weak var lblHeader: UILabel!
    //MARK: - Variables
    var type = Int()
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        switch type {
        case 0:
            vwStackVan.isHidden = false
            vwStackDriver.isHidden = true
            vwStackHelper.isHidden = true
            vwStackSupervisor.isHidden = true
        case 1:
            vwStackVan.isHidden = true
            vwStackDriver.isHidden = false
            vwStackHelper.isHidden = true
            vwStackSupervisor.isHidden = true
        case 2:
            vwStackVan.isHidden = true
            vwStackDriver.isHidden = true
            vwStackHelper.isHidden = false
            vwStackSupervisor.isHidden = true
        default:
            vwStackVan.isHidden = true
            vwStackDriver.isHidden = true
            vwStackHelper.isHidden = true
            vwStackSupervisor.isHidden = false
        }
    }
    //MARK: - @IBActions
    @IBAction func actionLogout(_ sender: Any) {
    }
}
