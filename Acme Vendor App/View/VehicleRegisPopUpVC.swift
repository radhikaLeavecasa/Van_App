//
//  VehicleRegisPopUpVC.swift
//  Acme Vendor App
//
//  Created by acme on 12/06/24.
//

import UIKit

class VehicleRegisPopUpVC: UIViewController {
    //MARK: - @IBOutlets
    @IBOutlet weak var txtFldVehicleNo: UITextField!
    //MARK: - Variables
    typealias remarks = (_ vanNo: String) -> Void
    var remarksDelegate: remarks? = nil
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    //MARK: - @IBActions
    @IBAction func actionFetch(_ sender: Any) {
        if txtFldVehicleNo.text == "" {
            Proxy.shared.showSnackBar(message: "Please enter van number first")
        } else {
            dismiss(animated: true) {
                guard let remarks = self.remarksDelegate else { return }
                remarks(self.txtFldVehicleNo.text!)
            }
        }
    }
}
