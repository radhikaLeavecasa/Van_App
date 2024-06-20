//
//  ViewController.swift
//  Acme Vendor App
//
//  Created by acme on 03/06/24.
//

import UIKit
import CoreLocation
import AdvancedPageControl
import SDWebImage

class HomeVC: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    //MARK: - @IBOutlets
    @IBOutlet weak var btnChangeRequest: UIButton!
    @IBOutlet weak var btnVwLocation: UIButton!
    @IBOutlet weak var vwStackSupervisor: UIStackView!
    @IBOutlet weak var vwStackHelper: UIStackView!
    @IBOutlet weak var vwStackDriver: UIStackView!
    @IBOutlet weak var vwStackVan: UIStackView!
    @IBOutlet var btnMeterVan: [UIButton]!
    @IBOutlet weak var collVwDetails: UICollectionView!
    @IBOutlet weak var vwPageControll: AdvancedPageControlView!
    @IBOutlet weak var vwHeader: UIView!
    @IBOutlet weak var vwStackHeight: NSLayoutConstraint!
    @IBOutlet weak var collVwImages: UICollectionView!
    
    // Van
    @IBOutlet weak var txtFldVanLicenseNo: UITextField!
    @IBOutlet weak var txtFldVanInsuranceCert: UITextField!
    @IBOutlet weak var txtFldPollutionCertNo: UITextField!
    @IBOutlet weak var txtFldVanRegistrationCert: UITextField!
    @IBOutlet weak var txtfldVanUniqueNo: UITextField!
    // Driver
    @IBOutlet weak var txtFldDriverName: UITextField!
    @IBOutlet weak var txtFldDriverPhone: UITextField!
    
    // Helper
    @IBOutlet weak var txtFldHelperName: UITextField!
    @IBOutlet weak var txtFldHelperPhone: UITextField!
    // Supervisor
    @IBOutlet weak var txtFldSupervisorPhone: UITextField!
    @IBOutlet weak var txtFldSupervisorName: UITextField!
    //MARK: - Variables
    var viewModel = HomeVM()
    var vanNo = String()
    var arrVanImages = [String]()
    var arrMeterImages = [String]()
    var type = Int()
    var arrHeader = ["Van Details", "Driver Details", "Helper Details", "Supervisor Details"]
    var selectedTab = 0
    var selectedIndex = 0
    var isStart = false
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collVwImages.registerNib(nibName: "SiteImagesXIB")
        
    }
    override func viewWillAppear(_ animated: Bool) {
        if Cookies.userInfo()?.type == 3 {
            btnChangeRequest.isHidden = false
            btnVwLocation.setTitle("Start Day", for: .normal)
            let vc = ViewControllerHelper.getViewController(ofType: .VehicleRegisPopUpVC, StoryboardName: .Main) as! VehicleRegisPopUpVC
            self.vwHeader.isHidden = true
            self.vwStackHeight.constant = 0
            if isStart {
                vc.modalPresentationStyle = .overFullScreen
                vc.modalTransitionStyle = .crossDissolve
                vc.remarksDelegate = {
                    val in
                    self.vanNo = val
                    self.handleApi(vanNo: val)
                }
                self.present(vc, animated: true)
            } else {
                self.handleApi(vanNo: vanNo)
                btnVwLocation.setTitle("Completed", for: .normal)
            }
        } else {
            btnChangeRequest.isHidden = true
            btnVwLocation.setTitle("View Loaction", for: .normal)
            handleApi(vanNo: vanNo)
        }
    }
    //MARK: - @IBActions
    @IBAction func actionBack(_ sender: Any) {
        popView()
    }
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
    @IBAction func actionViewLocation(_ sender: Any) {
        if Cookies.userInfo()?.type == 3 && btnVwLocation.currentTitle != "Completed" {
            let vc = ViewControllerHelper.getViewController(ofType: .AddPhotosVC, StoryboardName: .Main) as! AddPhotosVC
            vc.vanNumber = self.vanNo
            vc.vanId = self.viewModel.vanDetail?.id ?? 0
            vc.type = btnVwLocation.currentTitle ?? ""
            self.pushView(vc: vc)
        } else if Cookies.userInfo()?.type == 1 {
            let vc = ViewControllerHelper.getViewController(ofType: .MapVC, StoryboardName: .Main) as! MapVC
            vc.vanNo = vanNo
            self.pushView(vc: vc)
            
        }
    }
    
    @IBAction func actionChangeRequest(_ sender: Any) {
    }
    
    @IBAction func actionVanMeter(_ sender: UIButton) {
        selectedTab = sender.tag
        for btn in btnMeterVan {
            if sender.tag == btn.tag {
                btnMeterVan[btn.tag].setTitleColor(.white, for: .normal)
                btnMeterVan[btn.tag].backgroundColor = .APP_BLUE_CLR
            } else {
                btnMeterVan[btn.tag].setTitleColor(.black, for: .normal)
                btnMeterVan[btn.tag].backgroundColor = .APP_GRAY_CLR
            }
        }
        vwPageControll.isHidden = sender.tag == 1
        collVwImages.reloadData()
    }
    func handleApi(vanNo: String) {
        viewModel.getVanDetailsApi(vanNo) { val, msg in
            self.selectedVanTab()
            if self.viewModel.vanDetail?.activity?.count == 0 {
                self.vwHeader.isHidden = true
                self.vwStackHeight.constant = 0
            } else {
                if let activities = self.viewModel.vanDetail?.activity {
                    // Filter activities based on matching dates (ignoring time)
                    let filteredActivities = activities.filter { activity in
                        guard let createdAtString = activity.createdAt else { return false }
                        let activityDate = self.convertStringToDate(createdAtString)
                        
                        let calendar = Calendar.current
                        let currentDate = Date()
                        
                        let activityComponents = calendar.dateComponents([.year, .month, .day], from: activityDate)
                        let currentComponents = calendar.dateComponents([.year, .month, .day], from: currentDate)
                        
                        return activityComponents.year == currentComponents.year &&
                               activityComponents.month == currentComponents.month &&
                               activityComponents.day == currentComponents.day
                    }
                    
                    if filteredActivities.count > 0 {
                        // Append images from the first matching activity
                        if let firstActivity = filteredActivities.first {
                            self.arrVanImages.append("\(imageBaseUrl)\(firstActivity.frontImage ?? "")")
                            self.arrVanImages.append("\(imageBaseUrl)\(firstActivity.backImage ?? "")")
                            self.arrVanImages.append("\(imageBaseUrl)\(firstActivity.leftImage ?? "")")
                            self.arrVanImages.append("\(imageBaseUrl)\(firstActivity.rightImage ?? "")")
                            
                            self.arrMeterImages.append("\(imageBaseUrl)\(firstActivity.meterImage ?? "")")
                            self.vwHeader.isHidden = false
                            self.vwStackHeight.constant = 350
                            self.btnVwLocation.setTitle("End Day", for: .normal)
                        }
                    } else {
                        self.vwHeader.isHidden = true
                        self.vwStackHeight.constant = 0
                    }
                }
            }
            self.vwPageControll.drawer = ScaleDrawer(numberOfPages: self.arrVanImages.count, height: 10, width: 10, space: 10, raduis: 10, currentItem: 0, indicatorColor: .white, dotsColor: .clear, isBordered: true, borderColor: .white, borderWidth: 1.0, indicatorBorderColor: .white, indicatorBorderWidth: 1.0)
            self.vwPageControll.numberOfPages = self.arrVanImages.count
            DispatchQueue.main.async {
                self.collVwImages.reloadData()
            }
        }
    }
}

extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionView == collVwDetails ? arrHeader.count : selectedTab == 0 ? arrVanImages.count : arrMeterImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collVwDetails {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OptionsCVC", for: indexPath) as! OptionsCVC
            cell.lblTitle.text = arrHeader[indexPath.row]
            cell.vwTitle.backgroundColor = selectedIndex == indexPath.row ? UIColor(named: "APP_BLUE_CLR") : .APP_GRAY_CLR
            cell.lblTitle.textColor = selectedIndex == indexPath.row ? .white : .APP_BLUE_CLR
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SiteImagesXIB", for: indexPath) as! SiteImagesXIB
            cell.imgVwSite.sd_imageIndicator = SDWebImageActivityIndicator.gray
            cell.imgVwSite.sd_setImage(with: URL(string: selectedTab == 0 ? arrVanImages[indexPath.row] : arrMeterImages[indexPath.row]), placeholderImage: .placeholderImage())
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == collVwDetails {
            selectedIndex = indexPath.row
            switch indexPath.row {
            case 0:
                self.selectedVanTab()
            case 1:
                vwStackVan.isHidden = true
                vwStackDriver.isHidden = false
                vwStackHelper.isHidden = true
                vwStackSupervisor.isHidden = true
                if viewModel.vanDetail?.driver?.count ?? 0 > 0 {
                    txtFldDriverName.text = viewModel.vanDetail?.driver?[0].name ?? ""
                    txtFldDriverPhone.text = viewModel.vanDetail?.driver?[0].phone ?? ""
                }
            case 2:
                vwStackVan.isHidden = true
                vwStackDriver.isHidden = true
                vwStackHelper.isHidden = false
                vwStackSupervisor.isHidden = true
                if viewModel.vanDetail?.helper?.count ?? 0 > 0 {
                    txtFldHelperName.text = viewModel.vanDetail?.helper?[0].name ?? ""
                    txtFldHelperPhone.text = viewModel.vanDetail?.helper?[0].phone ?? ""
                }
            default:
                vwStackVan.isHidden = true
                vwStackDriver.isHidden = true
                vwStackHelper.isHidden = true
                vwStackSupervisor.isHidden = false
                if viewModel.vanDetail?.promoter?.count ?? 0 > 0 {
                    txtFldSupervisorName.text = viewModel.vanDetail?.promoter?[0].name ?? ""
                    txtFldSupervisorPhone.text = viewModel.vanDetail?.promoter?[0].phone ?? ""
                }
            }
            collVwDetails.reloadData()
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collVwDetails {
            let label = UILabel(frame: CGRect.zero)
            label.text = arrHeader[indexPath.item]
            label.sizeToFit()
            return CGSize(width: label.frame.width+15, height: self.collVwDetails.frame.size.height)
        } else {
            return CGSize(width: self.collVwImages.frame.size.width, height: self.collVwImages.frame.size.height)
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == collVwImages {
            let offSet = scrollView.contentOffset.x
            let width = scrollView.frame.width
            let index = Int(round(offSet/width))
            self.vwPageControll.setPage(index)
        }
    }
    func selectedVanTab(){
        vwStackVan.isHidden = false
        vwStackDriver.isHidden = true
        vwStackHelper.isHidden = true
        vwStackSupervisor.isHidden = true
        
        let dict = viewModel.vanDetail
        
        txtfldVanUniqueNo.text = dict?.vanNumber
        txtFldVanLicenseNo.text = dict?.commercialLicenceNo
        txtFldVanInsuranceCert.text = dict?.insuranceCertificateNo
        txtFldVanRegistrationCert.text = dict?.regCertificateNo
        txtFldPollutionCertNo.text = dict?.populationCertificateNo
    }
}

extension HomeVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
}
