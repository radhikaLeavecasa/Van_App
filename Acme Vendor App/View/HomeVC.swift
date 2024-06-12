//
//  ViewController.swift
//  Acme Vendor App
//
//  Created by acme on 03/06/24.
//

import UIKit
import CoreLocation
import AdvancedPageControl

class HomeVC: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    //MARK: - @IBOutlets
    @IBOutlet weak var collVwDetails: UICollectionView!
    @IBOutlet weak var vwPageControll: AdvancedPageControlView!
    @IBOutlet weak var collVwImages: UICollectionView!
    //MARK: - Variables
    var viewModel = HomeVM()
    var locationManager = CLLocationManager()
    var selectedDate = Date()
    var currentLoc: CLLocation!
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager.requestWhenInUseAuthorization()
    }
    //MARK: - @IBActions
    @IBAction func actionLogout(_ sender: Any) {
        
        let alert = UIAlertController(title: "Logout?", message: "Are you sure you want to logout?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { _ in
        }))
        alert.addAction(UIAlertAction(title: "Logout",
                                      style: UIAlertAction.Style.default,
                                      handler: {(_: UIAlertAction!) in
            self.viewModel.logoutApi { val, msg in
                if val {
                    Proxy.shared.showSnackBar(message: CommonMessage.LOGGED_OUT)
                    let vc = ViewControllerHelper.getViewController(ofType: .LoginVC, StoryboardName: .Main) as! LoginVC
                    self.setView(vc: vc)
                    Cookies.deleteUserToken()
                } else {
                    if msg == CommonError.INTERNET {
                        Proxy.shared.showSnackBar(message: CommonMessage.NO_INTERNET_CONNECTION)
                    } else {
                        Proxy.shared.showSnackBar(message: msg)
                    }
                }
            }
        }))
        
        DispatchQueue.main.async {
            self.present(alert, animated: false, completion: nil)
        }
    }
//    @IBAction func actionAddPhotograph(_ sender: UIButton) {
//        
//        ImagePickerManager().openCamera(self) { image in
//            self.imgVwSitePhoto.image = image
//            self.lblRetakeSitePhoto.text = "Retake Site Photograph"
//            self.lblRetakeSitePhoto.font = UIFont(name: "DMSans18pt-Black", size: 14)
//            if(self.locationManager.authorizationStatus == .authorizedWhenInUse ||
//               self.locationManager.authorizationStatus == .authorizedAlways) {
//                self.currentLoc = self.locationManager.location
//                self.txtFldLatitude.text = "\(self.currentLoc.coordinate.latitude)"
//                self.txtFldLongitude.text = "\(self.currentLoc.coordinate.longitude)"
//            }
//        }
//    }
   
//    @IBAction func actionFetch(_ sender: Any) {
//        if txtFldRetailerCode.text == "" {
//            Proxy.shared.showSnackBar(message: "Please enter retailer code")
//        } else {
//            viewModel.fetchApi(txtFldRetailerCode.text ?? "") {val,msg in
//                if val {
//                    let dict = self.viewModel.homeModel
//                    self.txtFldLocation.text = dict?.address
//                    self.txtFldAsmNumber.text = dict?.asmContact
//                    self.txtFldAsmName.text = dict?.asmName
//                    self.txtFldCity.text = dict?.city
//                    self.txtFldOwnerMobile.text = dict?.contact
//                    self.txtFldDistrict.text = dict?.district
//                    self.txtFldShopName.text = dict?.retailerName
//                    self.txtFldState.text = dict?.state
//                    
//                    self.txtFldLocation.isUserInteractionEnabled = self.txtFldLocation.text == ""
//                    self.txtFldAsmNumber.isUserInteractionEnabled = self.txtFldAsmNumber.text == ""
//                    self.txtFldAsmName.isUserInteractionEnabled = self.txtFldAsmName.text == ""
//                    self.txtFldCity.isUserInteractionEnabled = self.txtFldCity.text == ""
//                    self.txtFldOwnerMobile.isUserInteractionEnabled = self.txtFldOwnerMobile.text == ""
//                    self.txtFldDistrict.isUserInteractionEnabled = self.txtFldDistrict.text == ""
//                    self.txtFldShopName.isUserInteractionEnabled = self.txtFldShopName.text == ""
//                    self.txtFldState.isUserInteractionEnabled = self.txtFldState.text == ""
//                    self.txtFldDate.text = "\(self.convertDateToString(Date(), format: "yyyy-MM-dd")), \(self.convertDateToString(Date(), format: "HH:mm"))"
//
//                    self.txtFldRetailerCode.resignFirstResponder()
//                } else {
//                    if msg == CommonError.INTERNET {
//                        Proxy.shared.showSnackBar(message: CommonMessage.NO_INTERNET_CONNECTION)
//                    } else {
//                        Proxy.shared.showSnackBar(message: msg)
//                    }
//                }
//            }
//        }
//    }
    
//    @IBAction func actionStorePhoto1(_ sender: UIButton) {
//        if sender.tag != 4 {
//            ImagePickerManager().openCamera(self) { image in
//                self.imgVwStorePhotos[sender.tag].image = image
//                self.btnStorePhoto[sender.tag].setTitle("Retake Store Photo \(sender.tag+1)", for: .normal)
//                self.btnStorePhoto[sender.tag].titleLabel?.font = UIFont(name: "DMSans18pt-Black", size: 14)
//                switch sender.tag {
//                case 0:
//                    self.cnstHeightStorePhoto1.constant = 80
//                case 1:
//                    self.cnstHeightStorePhoto2.constant = 80
//                case 2:
//                    self.cnstHeightStorePhoto3.constant = 80
//                case 3:
//                    self.cnstHeightStorePhoto4.constant = 80
//                default:
//                    break
//                }
//            }
//        } else {
//            if let vc = ViewControllerHelper.getViewController(ofType: .SignaturePopVC, StoryboardName: .Main) as? SignaturePopVC {
//                vc.modalPresentationStyle = .overFullScreen
//                vc.modalTransitionStyle = .crossDissolve
//                
//                vc.eSignDelegate = { signImg in
//                    self.cnstHeightSignatureOfOwner.constant = 80
//                    self.imgVwOwnerSignature.image = signImg
//                    self.btnOwnerSignature.titleLabel?.font = UIFont(name: "DMSans18pt-Black", size: 14)
//                    self.btnOwnerSignature.setTitle("Retake Signature of owner", for: .normal)
//                }
//                self.present(vc, animated: true)
//            }
//        }
//    }
//    @IBAction func actionUploadSiteDetails(_ sender: UIButton) {
//        if isValidateDetails() {
//            let area = Double((Double(txtFldHeight.text!) ?? 0.0)*(Double(txtFldWidth.text!) ?? 0.0))
//            let param: [String:AnyObject] = [WSRequestParams.WS_REQS_PARAM_DISTRICT : txtFldDistrict.text!,
//                                             WSRequestParams.WS_REQS_PARAM_STATE: txtFldState.text!,
//                                             WSRequestParams.WS_REQS_PARAM_CITY: txtFldCity.text!,
//                                             WSRequestParams.WS_REQS_PARAM_RETAIL_NAME: txtFldShopName.text!,
//                                             WSRequestParams.WS_REQS_PARAM_LAT : txtFldLatitude.text!,
//                                             WSRequestParams.WS_REQS_PARAM_LONG: txtFldLongitude.text!,
//                                             WSRequestParams.WS_REQS_PARAM_LENGTH: txtFldHeight.text!,
//                                             WSRequestParams.WS_REQS_PARAM_WIDTH: txtFldWidth.text!,
//                                             WSRequestParams.WS_REQS_PARAM_DATE: txtFldDate.text!,
//                                             WSRequestParams.WS_REQS_PARAM_OWNER_NAME: txtFldOwnerName.text!,
//                                             WSRequestParams.WS_REQS_PARAM_EMAIL: txtFldOwnerEmail.text!,
//                                             WSRequestParams.WS_REQS_PARAM_MOBILE: txtFldOwnerMobile.text!,
//                                             WSRequestParams.WS_REQS_PARAM_REMARKS: txtFldRemarks.text ?? "",
//                                             WSRequestParams.WS_REQS_PARAM_CREATED_BY: "\(Cookies.getUserToken())",
//                                             WSRequestParams.WS_REQS_PARAM_LOCATION: txtFldLocation.text!,
//                                             WSRequestParams.WS_REQS_PARAM_AREA: "\(area)",
//                                             WSRequestParams.WS_REQS_PARAM_ASM_NAME: txtFldAsmName.text!,
//                                             WSRequestParams.WS_REQS_PARAM_DIVISION: viewModel.homeModel?.division ?? "",
//                                             WSRequestParams.WS_REQS_PARAM_RETAILER_CODE: viewModel.homeModel?.retailerCode ?? "",
//                                             WSRequestParams.WS_REQS_PARAM_ASM_MOBILE:txtFldAsmNumber.text!,
//                                             WSRequestParams.WS_REQS_PARAM_CODE:viewModel.homeModel?.code ?? ""] as! [String:AnyObject]
//            
//            let imgParam: [String: UIImage] = [WSRequestParams.WS_REQS_PARAM_IMAGE: imgVwSitePhoto.image,
//                                               WSRequestParams.WS_REQS_PARAM_IMAGE1: imgVwStorePhotos[0].image,
//                                               WSRequestParams.WS_REQS_PARAM_IMAGE2: imgVwStorePhotos[1].image,
//                                               WSRequestParams.WS_REQS_PARAM_IMAGE3: imgVwStorePhotos[2].image,
//                                               WSRequestParams.WS_REQS_PARAM_IMAGE4: imgVwStorePhotos[3].image,
//                                               WSRequestParams.WS_REQS_PARAM_OWNER_SIGN: imgVwOwnerSignature.image] as! [String: UIImage]
//            
//            viewModel.uploadSiteDetails(param: param, dictImage: imgParam) { val, msg in
//                if val {
//                    Proxy.shared.showSnackBar(message: msg)
//                    self.resetData()
//                } else {
//                    if msg == CommonError.INTERNET {
//                        Proxy.shared.showSnackBar(message: CommonMessage.NO_INTERNET_CONNECTION)
//                    } else {
//                        Proxy.shared.showSnackBar(message: msg)
//                    }
//                }
//            }
//        }
//    }
    
//    @IBAction func actionResetAllFields(_ sender: Any) {
//        resetData()
//    }
    @IBAction func actionVanMeter(_ sender: UIButton) {
    }
    //MARK: - Custom method
//    func resetData(){
//        self.txtFldSq.text = ""
//        self.txtFldLocation.text = ""
//        self.txtFldAsmNumber.text = ""
//        self.txtFldAsmName.text = ""
//        self.txtFldCity.text = ""
//        self.txtFldOwnerMobile.text = ""
//        self.txtFldDistrict.text = ""
//        self.txtFldShopName.text = ""
//        self.txtFldState.text = ""
//        self.txtFldDate.text = ""
//        self.txtFldRetailerCode.text = ""
//        self.txtFldHeight.text = ""
//        self.txtFldWidth.text = ""
//        self.txtFldOwnerName.text = ""
//        self.txtFldOwnerEmail.text = ""
//        self.txtFldYourName.text = ""
//        self.txtFldLatitude.text = ""
//        self.txtFldLongitude.text = ""
//        self.txtFldRemarks.text = ""
//        self.imgVwSitePhoto.image = nil
//        self.imgVwStorePhotos[0].image = nil
//        self.imgVwStorePhotos[1].image = nil
//        self.imgVwStorePhotos[2].image = nil
//        self.imgVwStorePhotos[3].image = nil
//        self.imgVwOwnerSignature.image = nil
//        
//        self.cnstHeightStorePhoto1.constant = 40
//        self.cnstHeightStorePhoto2.constant = 40
//        self.cnstHeightStorePhoto3.constant = 40
//        self.cnstHeightStorePhoto4.constant = 40
//        self.cnstHeightSignatureOfOwner.constant = 40
//        
//        self.btnStorePhoto[0].setTitle("Store Photo 1", for: .normal)
//        self.btnStorePhoto[1].setTitle("Store Photo 2", for: .normal)
//        self.btnStorePhoto[2].setTitle("Store Photo 3", for: .normal)
//        self.btnStorePhoto[3].setTitle("Store Photo 4", for: .normal)
//        self.btnOwnerSignature.setTitle("Signature of Owner", for: .normal)
//        self.lblRetakeSitePhoto.text = "Add Site Photograph"
//        
//        self.btnOwnerSignature.titleLabel?.font = UIFont(name: "DMSans24pt-Regular", size: 14)
//        self.btnStorePhoto[0].titleLabel?.font = UIFont(name: "DMSans24pt-Regular", size: 14)
//        self.btnStorePhoto[1].titleLabel?.font = UIFont(name: "DMSans24pt-Regular", size: 14)
//        self.btnStorePhoto[2].titleLabel?.font = UIFont(name: "DMSans24pt-Regular", size: 14)
//        self.btnStorePhoto[3].titleLabel?.font = UIFont(name: "DMSans24pt-Regular", size: 14)
//        self.lblRetakeSitePhoto.font = UIFont(name: "DMSans24pt-Regular", size: 14)
//        
//    }
    
//    func isValidateDetails() -> Bool {
//        if txtFldHeight.text?.isEmptyCheck() == true {
//            Proxy.shared.showSnackBar(message: CommonMessage.ENTER_HEIGHT)
//            return false
//        } else if txtFldWidth.text?.isEmptyCheck() == true {
//            Proxy.shared.showSnackBar(message: CommonMessage.ENTER_WIDTH)
//            return false
//        } else if txtFldState.text?.isEmptyCheck() == true {
//            Proxy.shared.showSnackBar(message: CommonMessage.ENTER_STATE)
//            return false
//        } else if txtFldDistrict.text?.isEmptyCheck() == true {
//            Proxy.shared.showSnackBar(message: CommonMessage.ENTER_DISTRICT)
//            return false
//        } else if txtFldCity.text?.isEmptyCheck() == true {
//            Proxy.shared.showSnackBar(message: CommonMessage.ENTER_CITY)
//            return false
//        } else if txtFldShopName.text?.isEmptyCheck() == true {
//            Proxy.shared.showSnackBar(message: CommonMessage.ENTER_SHOP_NAME)
//            return false
//        } else if txtFldDate.text?.isEmptyCheck() == true {
//            Proxy.shared.showSnackBar(message: CommonMessage.ENTER_DATE)
//            return false
//        } else if txtFldOwnerName.text?.isEmptyCheck() == true {
//            Proxy.shared.showSnackBar(message: CommonMessage.ENTER_OWNER_NAME)
//            return false
//        } else if txtFldOwnerEmail.text?.isEmptyCheck() == true {
//            Proxy.shared.showSnackBar(message: CommonMessage.ENTER_OWNER_EMAIL)
//            return false
//        } else if txtFldOwnerEmail.text?.isValidEmail() == false {
//            Proxy.shared.showSnackBar(message: CommonMessage.ENTER_VALID_OWNER_EMAIL)
//            return false
//        } else if txtFldOwnerMobile.text?.isEmptyCheck() == true {
//            Proxy.shared.showSnackBar(message: CommonMessage.ENTER_OWNER_MOBILE)
//            return false
//        } else if txtFldYourName.text?.isEmptyCheck() == true {
//            Proxy.shared.showSnackBar(message: CommonMessage.ENTER_YOUR_NAME)
//            return false
//        } else if txtFldAsmName.text?.isEmptyCheck() == true {
//            Proxy.shared.showSnackBar(message: CommonMessage.ENTER_ASM_NAME)
//            return false
//        } else if txtFldAsmNumber.text?.isEmptyCheck() == true {
//            Proxy.shared.showSnackBar(message: CommonMessage.ENTER_ASM_NUMBER)
//            return false
//        } else if txtFldLocation.text?.isEmptyCheck() == true {
//            Proxy.shared.showSnackBar(message: CommonMessage.ENTER_LOCATION)
//            return false
//        } else if imgVwSitePhoto.image == nil {
//            Proxy.shared.showSnackBar(message: CommonMessage.ADD_SITE_PHOTO)
//            return false
//        } else if imgVwStorePhotos[0].image == nil {
//            Proxy.shared.showSnackBar(message: CommonMessage.ADD_STORE_PHOTO1)
//            return false
//        } else if imgVwStorePhotos[1].image == nil {
//            Proxy.shared.showSnackBar(message: CommonMessage.ADD_STORE_PHOTO2)
//            return false
//        } else if imgVwStorePhotos[2].image == nil {
//            Proxy.shared.showSnackBar(message: CommonMessage.ADD_STORE_PHOTO3)
//            return false
//        } else if imgVwStorePhotos[3].image == nil {
//            Proxy.shared.showSnackBar(message: CommonMessage.ADD_STORE_PHOTO4)
//            return false
//        } else if imgVwOwnerSignature.image == nil {
//            Proxy.shared.showSnackBar(message: CommonMessage.ADD_SIGNATURE_OF_OWNER)
//            return false
//        } else if txtFldLatitude.text?.isEmptyCheck() == true && txtFldLongitude.text?.isEmptyCheck() == true {
//            Proxy.shared.showSnackBar(message: CommonMessage.LAT_LONG_FETCH)
//            return false
//        }
//        return true
//    }
}

//extension HomeVC: UITextFieldDelegate{
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        
//        if textField == txtFldOwnerMobile || textField == txtFldAsmNumber {
//            let newText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
//            if newText.count > 10 {
//                return false
//            }
//        }
//        return true
//    }
//    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
//        if textField == txtFldWidth || textField == txtFldHeight {
//            if txtFldHeight.text != "" && txtFldWidth.text != "" {
//                txtFldSq.text = "\(Double((Double(txtFldHeight.text!) ?? 0.0)*(Double(txtFldWidth.text!) ?? 0.0)))"
//            }
//        }
//    }
//}
