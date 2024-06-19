//
//  AddPhotosVC.swift
//  Acme Vendor App
//
//  Created by acme on 12/06/24.
//

import UIKit
import CoreLocation

class AddPhotosVC: UIViewController {
    //MARK: - @IBOutlets
    @IBOutlet weak var lblStartEndKm: UILabel!
    @IBOutlet weak var vwVanPhotos: UIView!
    @IBOutlet weak var imgVwAddMeterPhotos: UIImageView!
    @IBOutlet weak var txtFldStartKm: UITextField!
    @IBOutlet weak var lblAddMeterImage: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblVanNumber: UILabel!
    @IBOutlet weak var collVwPhotos: UICollectionView!
    //MARK: - Variables
    var arrPhotos = ["Add Front Image", "Add Left Image", "Add Back Image", "Add Right Image"]
    var arrImages = [UIImage]()
    var vanNumber = String()
    var vanId = Int()
    var viewModel = AddPhotoVM()
    var currentLoc: CLLocation!
    var type = String()
    var locationManager = CLLocationManager()
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        vwVanPhotos.isHidden = type == "End Day"
        lblStartEndKm.text = "Enter \(type == "End Day" ? "End" : "Start") KM"
        lblDate.text = "Date: \(convertDateToString(Date(), format: "dd-MM-yyyy"))"
        lblVanNumber.text = "Van No.:- \(vanNumber)"
        self.locationManager.requestWhenInUseAuthorization()
        
        for _ in arrPhotos {
            self.arrImages.append(UIImage())
        }
    }
    
    @IBAction func actionSave(_ sender: Any) {
        if isValidateDriverDetails() {
            if(self.locationManager.authorizationStatus == .authorizedWhenInUse ||
               self.locationManager.authorizationStatus == .authorizedAlways) {
                self.currentLoc = self.locationManager.location
                
                let param: [String:AnyObject] = [WSRequestParams.WS_REQS_PARAM_VAN_ID: "\(vanId)",
                                                 WSRequestParams.WS_REQS_PARAM_CREATED_BY: "\(Cookies.userInfo()?.id ?? 0)",
                                                 WSRequestParams.WS_REQS_PARAM_METER: txtFldStartKm.text ?? "",
                                                 WSRequestParams.WS_REQS_PARAM_STATUS: "Start Day",
                                                 WSRequestParams.WS_REQS_PARAM_LAT: "\(self.currentLoc.coordinate.latitude)",
                                                 WSRequestParams.WS_REQS_PARAM_LONG: "\(self.currentLoc.coordinate.longitude)"] as! [String:AnyObject]
                
                let imgParam: [String: UIImage] = [WSRequestParams.WS_REQS_PARAM_FRONT_IMG : arrImages[0],
                                                   WSRequestParams.WS_REQS_PARAM_BACK_IMG: arrImages[2],
                                                   WSRequestParams.WS_REQS_PARAM_LEFT_IMG: arrImages[1],
                                                   WSRequestParams.WS_REQS_PARAM_RIGHT_IMG: arrImages[3],
                                                   WSRequestParams.WS_REQS_PARAM_METER_IMG: imgVwAddMeterPhotos.image] as! [String:UIImage]
                
                
                let param2: [String:AnyObject] = [WSRequestParams.WS_REQS_PARAM_VAN_ID: "\(vanId)",
                                                  WSRequestParams.WS_REQS_PARAM_DAY_END_METER: txtFldStartKm.text ?? "",
                                                  WSRequestParams.WS_REQS_PARAM_DAY_END_LAT: "\(self.currentLoc.coordinate.latitude)",
                                                  WSRequestParams.WS_REQS_PARAM_STATUS: "Completed",
                                                  WSRequestParams.WS_REQS_PARAM_DAY_END_LONG: "\(self.currentLoc.coordinate.longitude)"] as! [String:AnyObject]
                
                let imgParam2: [String: UIImage] = [WSRequestParams.WS_REQS_PARAM_DAY_END_IMG : imgVwAddMeterPhotos.image] as! [String:UIImage]
                
                viewModel.addPhotoDetailsApi(type == "End Day" ? .endDay : .saveVanDetails, param: type == "End Day" ? param2 : param, imageParam: type == "End Day" ? imgParam2 : imgParam) { val, msg in
                    self.popView()
                    Proxy.shared.showSnackBar(message: "Van data added successfully!")
                    
                }
            }
        }
    }
    
    @IBAction func actionAddMeterImage(_ sender: Any) {
        ImagePickerManager().pickImage(self){ image in
            self.imgVwAddMeterPhotos.image = image
            self.lblAddMeterImage.text = "Retake meter image"
        }
    }
    
    func isValidateDriverDetails() -> Bool {
        if type == "Start Day" {
            for image in arrImages {
                if image.size.width == 0 || image.size.height == 0 {
                    Proxy.shared.showSnackBar(message: CommonMessage.UPLOAD_VAN_PHOTO)
                    return false
                }
            }
        }
        if imgVwAddMeterPhotos.image == nil {
            Proxy.shared.showSnackBar(message: CommonMessage.UPLOAD_METER_PHOTO)
            return false
        } else if txtFldStartKm.text?.isEmptyCheck() == true {
            if type == "Start Day" {
                Proxy.shared.showSnackBar(message: CommonMessage.ENTER_START_KM)
            } else {
                Proxy.shared.showSnackBar(message: CommonMessage.ENTER_END_KM)
            }
            return false
        }
        return true
    }
}

extension AddPhotosVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        arrPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SiteCVC", for: indexPath) as! SiteCVC
        cell.lblShopName.text = arrPhotos[indexPath.row]
        cell.imgVwSite.image = arrImages[indexPath.row]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        ImagePickerManager().pickImage(self){ image in
            self.arrImages[indexPath.row] = image
            var updatedPhoto = self.arrPhotos[indexPath.row]
            updatedPhoto = self.arrPhotos[indexPath.row].replacingOccurrences(of: "Add", with: "Retake")
            self.arrPhotos[indexPath.row] = updatedPhoto
            self.collVwPhotos.reloadData()
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collVwPhotos.frame.size.width/2, height: collVwPhotos.frame.size.height/2)
    }
}
