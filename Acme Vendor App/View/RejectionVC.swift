//
//  RejectionVC.swift
//  Acme Vendor App
//
//  Created by acme on 11/06/24.
//

import UIKit
import IQKeyboardManagerSwift

class RejectionVC: UIViewController {
    //MARK: - @IBOutlets
    @IBOutlet weak var txtVwRemarks: IQTextView!
    //MARK: - Variables
    typealias remarks = (_ remarks: String) -> Void
    var remarksDelegate: remarks? = nil
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //MARK: - @IBActions
    @IBAction func actionCross(_ sender: Any) {
        dismiss(animated: true)
    }
    @IBAction func actionDone(_ sender: Any) {
        dismiss(animated: true) {
            guard let remarks = self.remarksDelegate else { return }
            remarks(self.txtVwRemarks.text)
        }
    }
}
