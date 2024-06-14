//
//  RegisterDetailsVC.swift
//  Acme Vand App
//
//  Created by acme on 13/06/24.
//

import UIKit

class RegisterDetailsVC: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate  {
    //MARK: - @IBOutlets
    @IBOutlet weak var vwStackSupervisor: UIStackView!
    @IBOutlet weak var vwStackHelper: UIStackView!
    @IBOutlet weak var vwStackDriver: UIStackView!
    @IBOutlet weak var vwStackVan: UIStackView!
    @IBOutlet weak var lblHeader: UILabel!
    
    //Van
    @IBOutlet weak var txtFldCommercialLincense: UITextField!
    @IBOutlet weak var txtFldUploadInsuranceCert: UITextField!
    @IBOutlet weak var txtFldPollutionNo: UITextField!
    @IBOutlet weak var txtFldVanRegisterationCert: UITextField!
    @IBOutlet weak var txtFldVanUniqueId: UITextField!
    @IBOutlet var btnVanUpload: [UIButton]!
    
    //Driver
    @IBOutlet weak var txtFldAadhaarFrontDriver: UITextField!
    @IBOutlet weak var txtFldDriverName: UITextField!
    @IBOutlet weak var txtFldDeriverPhone: UITextField!
    @IBOutlet weak var txtFldDriverProfilePhoto: UITextField!
    @IBOutlet weak var txtFldCommercialDrivingLicense: UITextField!
    @IBOutlet weak var txtfldUploadAdharbackDriver: UITextField!
    @IBOutlet var btnDriverUpload: [UIButton]!
    
    //Helper
    @IBOutlet weak var txtFldHelperName: UITextField!
    @IBOutlet weak var txtFldHelperPhone: UITextField!
    @IBOutlet weak var txtFldHelperProfile: UIView!
    @IBOutlet weak var txtFldAdharFront: UITextField!
    @IBOutlet weak var txtFldAdharBack: UITextField!
    @IBOutlet var btnHelperProfile: [UIButton]!
    
    //Supervisor
    @IBOutlet weak var txtFldSupervisorName: UITextField!
    @IBOutlet weak var txtFldSupervisorPhone: UITextField!
    @IBOutlet weak var txtFldSupervisorProfile: UITextField!
    @IBOutlet weak var txtFldSupervisorAdharFront: UITextField!
    @IBOutlet weak var txtFldSupervisorAdharBack: UITextField!
    @IBOutlet var btnUploadSupervProfile: [UIButton]!
    
    //MARK: - Variables
    var type = Int()
    var viewModel = RegisterDetailsVM()
    //Van
    var polluationImg: UIImage?
    var insuranceImg: UIImage?
    var commercialLicenseImg: UIImage?
    var registrationCertImg: UIImage?
    //Driver
    var driverProfilePhoto: UIImage?
    var commercialDrivingLicense: UIImage?
    var driverAadharFront: UIImage?
    var driverAadharBack: UIImage?
    //Helper
    var helperProfilePhoto: UIImage?
    var helperAadharFront: UIImage?
    var helperAadharBack: UIImage?
    //Supervisor
    var supervisorProfilePhoto: UIImage?
    var supervisorAadharFront: UIImage?
    var supervisorAadharBack: UIImage?
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        switch type {
        case 0:
            lblHeader.text = "Van Registration"
            vwStackVan.isHidden = false
            vwStackDriver.isHidden = true
            vwStackHelper.isHidden = true
            vwStackSupervisor.isHidden = true
        case 1:
            lblHeader.text = "Driver Registration"
            vwStackVan.isHidden = true
            vwStackDriver.isHidden = false
            vwStackHelper.isHidden = true
            vwStackSupervisor.isHidden = true
        case 2:
            lblHeader.text = "Helper Registration"
            vwStackVan.isHidden = true
            vwStackDriver.isHidden = true
            vwStackHelper.isHidden = false
            vwStackSupervisor.isHidden = true
        default:
            lblHeader.text = "Supervisor Registration"
            vwStackVan.isHidden = true
            vwStackDriver.isHidden = true
            vwStackHelper.isHidden = true
            vwStackSupervisor.isHidden = false
        }
    }
    //MARK: - @IBActions
    @IBAction func actionBack(_ sender: UIButton) {
        popView()
    }
    @IBAction func actionSave(_ sender: UIButton) {
        switch type {
        case 0:
            if isValidateVanDetails() {
                let param: [String:Any] = [WSRequestParams.WS_REQS_PARAM_REG_CERT : txtFldVanRegisterationCert.text!,
                                           WSRequestParams.WS_REQS_PARAM_POPULATION_CERT: txtFldPollutionNo.text!,
                                           WSRequestParams.WS_REQS_PARAM_INSURANCE_NO: txtFldUploadInsuranceCert.text!,
                                           WSRequestParams.WS_REQS_PARAM_VAN_NUM: txtFldVanUniqueId.text!,
                                           WSRequestParams.WS_REQS_PARAM_COMMERCIAL_LICENSE_NO : txtFldCommercialLincense.text!] as! [String:Any]
                
                let imgParam: [String: UIImage] = [WSRequestParams.WS_REQS_PARAM_POPULATION_IMG : polluationImg,
                                                   WSRequestParams.WS_REQS_PARAM_INSURANCE_IMG: insuranceImg,
                                                   WSRequestParams.WS_REQS_PARAM_COMMERCIAL_IMG: commercialLicenseImg,
                                                   WSRequestParams.WS_REQS_PARAM_REG_IMG: registrationCertImg] as! [String:UIImage]
                
                viewModel.vanDriverHelperSupervisorPostApi(.vanApi, param: param, imageParam: imgParam) { val, msg in
                    if val {
                        self.popView()
                        Proxy.shared.showSnackBar(message: "Van registrated successfully!")
                    } else {
                        if msg == CommonError.INTERNET {
                            Proxy.shared.showSnackBar(message: CommonMessage.NO_INTERNET_CONNECTION)
                        } else {
                            Proxy.shared.showSnackBar(message: msg)
                        }
                    }
                }
            }
        case 1:
            if isValidateDriverDetails() {
                let param: [String:Any] = [WSRequestParams.WS_REQS_PARAM_NAME : txtFldDriverName.text!,
                                           WSRequestParams.WS_REQS_PARAM_PHONE: txtFldDeriverPhone.text!] as! [String:Any]
                
                let imgParam: [String: UIImage] = [WSRequestParams.WS_REQS_PARAM_IMAGE : driverProfilePhoto,
                                                   WSRequestParams.WS_REQS_PARAM_DRIVER_LICENSE: commercialDrivingLicense,
                                                   WSRequestParams.WS_REQS_PARAM_AADHAAR: driverAadharFront,
                                                   WSRequestParams.WS_REQS_PARAM_AADHAAR_BACK: driverAadharBack] as! [String:UIImage]
                
                viewModel.vanDriverHelperSupervisorPostApi(.driverApi, param: param, imageParam: imgParam) { val, msg in
                    if val {
                        self.popView()
                        Proxy.shared.showSnackBar(message: "Driver registrated successfully!")
                    } else {
                        if msg == CommonError.INTERNET {
                            Proxy.shared.showSnackBar(message: CommonMessage.NO_INTERNET_CONNECTION)
                        } else {
                            Proxy.shared.showSnackBar(message: msg)
                        }
                    }
                }
            }
        case 2:
            if isValidateHelperDetails() {
                let param: [String:Any] = [WSRequestParams.WS_REQS_PARAM_NAME : txtFldHelperName.text!,
                                           WSRequestParams.WS_REQS_PARAM_PHONE: txtFldHelperPhone.text!] as! [String:Any]
                
                let imgParam: [String: UIImage] = [WSRequestParams.WS_REQS_PARAM_IMAGE : helperProfilePhoto,
                                                   WSRequestParams.WS_REQS_PARAM_AADHAAR: helperAadharFront,
                                                   WSRequestParams.WS_REQS_PARAM_AADHAAR_BACK: helperAadharBack] as! [String:UIImage]
                
                viewModel.vanDriverHelperSupervisorPostApi(.helperApi, param: param, imageParam: imgParam) { val, msg in
                    if val {
                        self.popView()
                        Proxy.shared.showSnackBar(message: "Helper registrated successfully!")
                    } else {
                        if msg == CommonError.INTERNET {
                            Proxy.shared.showSnackBar(message: CommonMessage.NO_INTERNET_CONNECTION)
                        } else {
                            Proxy.shared.showSnackBar(message: msg)
                        }
                    }
                }
            }
        default:
            if isValidateSupervisorDetails() {
                let param: [String:Any] = [WSRequestParams.WS_REQS_PARAM_NAME : txtFldSupervisorName.text!,
                                           WSRequestParams.WS_REQS_PARAM_PHONE: txtFldSupervisorPhone.text!] as! [String:Any]
                
                let imgParam: [String: UIImage] = [WSRequestParams.WS_REQS_PARAM_IMAGE : supervisorProfilePhoto,
                                                   WSRequestParams.WS_REQS_PARAM_AADHAAR: supervisorAadharFront,
                                                   WSRequestParams.WS_REQS_PARAM_AADHAAR_BACK: supervisorAadharBack] as! [String:UIImage]
                
                viewModel.vanDriverHelperSupervisorPostApi(.promotorApi, param: param, imageParam: imgParam) { val, msg in
                    if val {
                        self.popView()
                        Proxy.shared.showSnackBar(message: "Supervisor registrated successfully!")
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
    @IBAction func actionUploadVanPhotos(_ sender: UIButton) {
        ImagePickerManager().pickImage(self){ image in
            self.btnVanUpload[sender.tag].backgroundColor = .APP_BLUE_CLR
            self.btnVanUpload[sender.tag].setImage(UIImage(named: "ic_tick"), for: .normal)
            switch sender.tag {
            case 0:
                self.registrationCertImg = image
            case 1:
                self.polluationImg = image
            case 2:
                self.insuranceImg = image
            default:
                self.commercialLicenseImg = image
            }
        }
    }
    @IBAction func actionDriverPhotos(_ sender: UIButton) {
        ImagePickerManager().pickImage(self){ image in
            self.btnDriverUpload[sender.tag].backgroundColor = .APP_BLUE_CLR
            self.btnDriverUpload[sender.tag].setImage(UIImage(named: "ic_tick"), for: .normal)
            switch sender.tag {
            case 0:
                self.driverProfilePhoto = image
            case 1:
                self.commercialDrivingLicense = image
            case 2:
                self.driverAadharFront = image
            default:
                self.driverAadharBack = image
            }
        }
    }
    @IBAction func actionHelperProfile(_ sender: UIButton) {
        ImagePickerManager().pickImage(self){ image in
            self.btnHelperProfile[sender.tag].backgroundColor = .APP_BLUE_CLR
            self.btnHelperProfile[sender.tag].setImage(UIImage(named: "ic_tick"), for: .normal)
            switch sender.tag {
            case 0:
                self.helperProfilePhoto = image
            case 1:
                self.helperAadharFront = image
            default:
                self.helperAadharBack = image
            }
        }
    }
    @IBAction func actionSupervisorProfile(_ sender: UIButton) {
        ImagePickerManager().pickImage(self){ image in
            self.btnUploadSupervProfile[sender.tag].backgroundColor = .APP_BLUE_CLR
            self.btnUploadSupervProfile[sender.tag].setImage(UIImage(named: "ic_tick"), for: .normal)
            switch sender.tag {
            case 0:
                self.supervisorProfilePhoto = image
            case 1:
                self.supervisorAadharFront = image
            default:
                self.supervisorAadharBack = image
            }
        }
    }
    //MARK: - Custom methods
    func isValidateVanDetails() -> Bool {
        if txtFldVanUniqueId.text?.isEmptyCheck() == true {
            Proxy.shared.showSnackBar(message: CommonMessage.ENTER_UNIQUE_NUMBER)
            return false
        } else if txtFldVanRegisterationCert.text?.isEmptyCheck() == true {
            Proxy.shared.showSnackBar(message: CommonMessage.ENTER_REGISTRATION_NUMBER)
            return false
        } else if txtFldPollutionNo.text?.isEmptyCheck() == true {
            Proxy.shared.showSnackBar(message: CommonMessage.ENTER_POLLUTION_CERTIFICATE)
            return false
        } else if txtFldUploadInsuranceCert.text?.isEmptyCheck() == true {
            Proxy.shared.showSnackBar(message: CommonMessage.ENTER_INSURANCE_CERTIFICATE)
            return false
        } else if txtFldCommercialLincense.text?.isEmptyCheck() == true {
            Proxy.shared.showSnackBar(message: CommonMessage.ENTER_COMMERCIAL_LICENSE)
            return false
        } else if registrationCertImg == nil  {
            Proxy.shared.showSnackBar(message: CommonMessage.ENTER_REGISTRATION_IMG)
            return false
        } else if polluationImg == nil {
            Proxy.shared.showSnackBar(message: CommonMessage.ENTER_POLLUTION_IMG)
            return false
        } else if insuranceImg == nil {
            Proxy.shared.showSnackBar(message: CommonMessage.ENTER_INSURANCE_IMG)
            return false
        } else if commercialLicenseImg == nil {
            Proxy.shared.showSnackBar(message: CommonMessage.ENTER_COMMERCIAL_IMG)
            return false
        }
        return true
    }
    
    func isValidateDriverDetails() -> Bool {
        if txtFldDriverName.text?.isEmptyCheck() == true {
            Proxy.shared.showSnackBar(message: CommonMessage.ENTER_DRIVER_NAME)
            return false
        } else if txtFldDeriverPhone.text?.isEmptyCheck() == true {
            Proxy.shared.showSnackBar(message: CommonMessage.ENTER_DRIVER_NUMBER)
            return false
        } else if driverProfilePhoto == nil {
            Proxy.shared.showSnackBar(message: CommonMessage.ENTER_DRIVER_PHOTO)
            return false
        } else if commercialDrivingLicense == nil {
            Proxy.shared.showSnackBar(message: CommonMessage.ENTER_DRIVING_LICENSE)
            return false
        } else if driverAadharFront == nil {
            Proxy.shared.showSnackBar(message: CommonMessage.ENTER_AADHAR_FRONT)
            return false
        } else if driverAadharBack == nil  {
            Proxy.shared.showSnackBar(message: CommonMessage.ENTER_AADHAR_BACK)
            return false
        }
        return true
    }
    
    func isValidateHelperDetails() -> Bool {
        if txtFldHelperName.text?.isEmptyCheck() == true {
            Proxy.shared.showSnackBar(message: CommonMessage.ENTER_HELPER_NAME)
            return false
        } else if txtFldHelperPhone.text?.isEmptyCheck() == true {
            Proxy.shared.showSnackBar(message: CommonMessage.ENTER_HELPER_NUMBER)
            return false
        } else if helperProfilePhoto == nil {
            Proxy.shared.showSnackBar(message: CommonMessage.ENTER_HELPER_PHOTO)
            return false
        } else if helperAadharFront == nil {
            Proxy.shared.showSnackBar(message: CommonMessage.ENTER_AADHAR_FRONT)
            return false
        } else if helperAadharBack == nil  {
            Proxy.shared.showSnackBar(message: CommonMessage.ENTER_AADHAR_BACK)
            return false
        }
        return true
    }
    
    func isValidateSupervisorDetails() -> Bool {
        if txtFldSupervisorName.text?.isEmptyCheck() == true {
            Proxy.shared.showSnackBar(message: CommonMessage.ENTER_SUPERVISOR_NAME)
            return false
        } else if txtFldSupervisorPhone.text?.isEmptyCheck() == true {
            Proxy.shared.showSnackBar(message: CommonMessage.ENTER_SUPERVISOR_NUMBER)
            return false
        } else if supervisorProfilePhoto == nil {
            Proxy.shared.showSnackBar(message: CommonMessage.ENTER_SUPERVISOR_PHOTO)
            return false
        } else if supervisorAadharFront == nil {
            Proxy.shared.showSnackBar(message: CommonMessage.ENTER_AADHAR_FRONT)
            return false
        } else if supervisorAadharBack == nil  {
            Proxy.shared.showSnackBar(message: CommonMessage.ENTER_AADHAR_BACK)
            return false
        }
        return true
    }
}

extension RegisterDetailsVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtFldHelperPhone || textField == txtFldDeriverPhone || textField == txtFldSupervisorPhone {
            let newText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
            if newText.count > 15 {
                return false
            } else {
                return true
            }
        }
        return true
    }
}
