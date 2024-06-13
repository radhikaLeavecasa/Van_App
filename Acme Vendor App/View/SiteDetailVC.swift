//
//  SiteDetailVC.swift
//  Acme Vendor App
//
//  Created by acme on 07/06/24.
//

import UIKit
import AdvancedPageControl
import SDWebImage

class SiteDetailVC: UIViewController {
    //MARK: - @IBOutlets
    @IBOutlet weak var cnstHeightBottomStack: NSLayoutConstraint!
    @IBOutlet weak var vwStackView: UIStackView!
    @IBOutlet weak var imgVwSignature: UIImageView!
    @IBOutlet weak var txtFldlocation: UITextField!
    @IBOutlet weak var txtFldRemarks: UITextField!
    @IBOutlet weak var txtFldLongitude: UITextField!
    @IBOutlet weak var txtFldLatitude: UITextField!
    @IBOutlet weak var txtFldAsmNumber: UITextField!
    @IBOutlet weak var txtFldAsmName: UITextField!
    @IBOutlet weak var txtFldYourName: UITextField!
    @IBOutlet weak var txtFldMobile: UITextField!
    @IBOutlet weak var txtFldEmail: UITextField!
    @IBOutlet weak var txtFldOwnerName: UITextField!
    @IBOutlet weak var txtFldDate: UITextField!
    @IBOutlet weak var txtFldRetailName: UITextField!
    @IBOutlet weak var txtFldCity: UITextField!
    @IBOutlet weak var txtFldDistrict: UITextField!
    @IBOutlet weak var txtFldState: UITextField!
    @IBOutlet weak var txtFldProjectName: UITextField!
    @IBOutlet weak var txtFldSqFt: UITextField!
    @IBOutlet weak var txtFldHeight: UITextField!
    @IBOutlet weak var txtFldWidth: UITextField!
    @IBOutlet weak var btnApprove: UIButton!
    @IBOutlet weak var pgControl: AdvancedPageControlView!
    @IBOutlet weak var collVwImages: UICollectionView!
    @IBOutlet weak var btnReject: UIButton!
    //MARK: - Variables
    var viewModel = SiteDetailVM()
    var arrImages = [String]()
    var siteDetail: ListingModel?
    //MARK: - Lifecycle method
    override func viewDidLoad() {
        super.viewDidLoad()
        setData()
//        cnstHeightBottomStack.constant = Cookies.userInfo()?.type == "asm" ? 50 : 0
//        vwStackView.isHidden = Cookies.userInfo()?.type != "asm"
    }
    //MARK: - Custom method
    func setData(){
        txtFldlocation.text = siteDetail?.location
        txtFldProjectName.text = siteDetail?.project
        txtFldState.text = siteDetail?.state
        txtFldDistrict.text = siteDetail?.district
        txtFldCity.text = siteDetail?.city
        txtFldRetailName.text = siteDetail?.retailName
        txtFldLatitude.text = siteDetail?.latitude
        txtFldLongitude.text = siteDetail?.longitude
        txtFldHeight.text = siteDetail?.length
        txtFldWidth.text = siteDetail?.width
        txtFldDate.text = siteDetail?.date
        txtFldOwnerName.text = siteDetail?.ownerName
        txtFldEmail.text = siteDetail?.email
        txtFldMobile.text = siteDetail?.mobile
        txtFldRemarks.text = siteDetail?.remarks == nil ? "No Remarks" : siteDetail?.remarks
        txtFldYourName.text = siteDetail?.retailerCode
        txtFldSqFt.text = siteDetail?.area
        txtFldAsmName.text = siteDetail?.asmName
        txtFldAsmNumber.text = siteDetail?.asmMobile
        imgVwSignature.sd_setImage(with: URL(string: "\(imageBaseUrl)\(siteDetail?.ownerSignature ?? "")"), placeholderImage: .placeholderImage())
        
        arrImages.append("\(imageBaseUrl)\(siteDetail?.image ?? "")")
        arrImages.append("\(imageBaseUrl)\(siteDetail?.image1 ?? "")")
        arrImages.append("\(imageBaseUrl)\(siteDetail?.image2 ?? "")")
        arrImages.append("\(imageBaseUrl)\(siteDetail?.image3 ?? "")")
        arrImages.append("\(imageBaseUrl)\(siteDetail?.image4 ?? "")")
        
        btnReject.isHidden = ((siteDetail?.asmStatus?.range(of: "approved", options: .caseInsensitive)) != nil)
        btnApprove.setTitle(((siteDetail?.asmStatus?.range(of: "approved", options: .caseInsensitive)) != nil) ? "Approved" : "Approve", for: .normal)
        btnApprove.isUserInteractionEnabled = ((siteDetail?.asmStatus?.range(of: "approved", options: .caseInsensitive)) != nil) ? false : true
        btnApprove.isHidden = ((siteDetail?.asmStatus?.range(of: "rejected", options: .caseInsensitive)) != nil)
        btnReject.setTitle(((siteDetail?.asmStatus?.range(of: "rejected", options: .caseInsensitive)) != nil) ? "Rejected" : "Reject", for: .normal)
        btnReject.isUserInteractionEnabled = ((siteDetail?.asmStatus?.range(of: "rejected", options: .caseInsensitive)) != nil) ? false : true


        
        DispatchQueue.main.async {
            self.pgControl.drawer = ScaleDrawer(numberOfPages: self.arrImages.count, height: 10, width: 10, space: 6, raduis: 10, currentItem: 0, indicatorColor: .white, dotsColor: .clear, isBordered: true, borderColor: .white, borderWidth: 1.0, indicatorBorderColor: .white, indicatorBorderWidth: 1.0)
            self.pgControl.numberOfPages = self.arrImages.count
        }
        collVwImages.registerNib(nibName: "SiteImagesXIB")
        collVwImages.reloadData()
    }
    //MARK: - @IBActions
    @IBAction func actionBack(_ sender: Any) {
        popView()
    }
    @IBAction func actionAcceptReject(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            let alert = UIAlertController(title: CommonMessage.ACME_VENDOR, message: CommonMessage.APPROVE_DETAILS, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: CommonMessage.CANCEL, style: UIAlertAction.Style.default, handler: { _ in
            }))
            alert.addAction(UIAlertAction(title: CommonMessage.APPROVE,
                                          style: UIAlertAction.Style.default,
                                          handler: {(_: UIAlertAction!) in
                let param = [WSRequestParams.WS_REQS_PARAM_ASM_STATUS: "approved",
                             WSRequestParams.WS_REQS_PARAM_ASM_APPROVE_ID: Cookies.userInfo()?.id ?? 0,
                             WSRequestParams.WS_REQS_PARAM_PROJECT_ID: self.siteDetail?.id ?? 0] as! [String:AnyObject]
                self.viewModel.acceptRejectApi(param) { val, msg in
                    if val {
                        Proxy.shared.showSnackBar(message: CommonMessage.APPROVED_SUCCESSFULLY)
                        self.popView()
                    } else {
                        if msg == CommonError.INTERNET {
                            Proxy.shared.showSnackBar(message: CommonMessage.NO_INTERNET_CONNECTION)
                        } else {
                            Proxy.shared.showSnackBar(message: msg)
                        }
                    }
                }
            }))
            self.present(alert, animated: false, completion: nil)
        default:
            let alert = UIAlertController(title: CommonMessage.ACME_VENDOR, message: CommonMessage.REJECT_DETAILS, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: CommonMessage.CANCEL, style: UIAlertAction.Style.default, handler: { _ in
            }))
            alert.addAction(UIAlertAction(title: CommonMessage.REJECT,
                                          style: UIAlertAction.Style.default,
                                          handler: {(_: UIAlertAction!) in
                
                let vc = ViewControllerHelper.getViewController(ofType: .RejectionVC, StoryboardName: .Main) as! RejectionVC
                vc.modalPresentationStyle = .overFullScreen
                vc.modalTransitionStyle = .crossDissolve
                
                vc.remarksDelegate = { remarks in
                    let param = [WSRequestParams.WS_REQS_PARAM_ASM_STATUS: "rejected",
                                 WSRequestParams.WS_REQS_PARAM_ASM_APPROVE_ID: Cookies.userInfo()?.id ?? 0,
                                 WSRequestParams.WS_REQS_PARAM_PROJECT_ID: self.siteDetail?.id ?? 0,
                                 WSRequestParams.WS_REQS_PARAM_ASM_REMARKS:remarks] as! [String:AnyObject]
                    self.viewModel.acceptRejectApi(param) { val, msg in
                        if val {
                            self.popView()
                            Proxy.shared.showSnackBar(message: CommonMessage.REJECTED_SUCCESS)
                        } else {
                            if msg == CommonError.INTERNET {
                                Proxy.shared.showSnackBar(message: CommonMessage.NO_INTERNET_CONNECTION)
                            } else {
                                Proxy.shared.showSnackBar(message: msg)
                            }
                        }
                    }
                }
                self.present(vc, animated: true)
            }))
            self.present(alert, animated: false, completion: nil)
        }
    }
}

extension SiteDetailVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        arrImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collVwImages.dequeueReusableCell(withReuseIdentifier: "SiteImagesXIB", for: indexPath) as! SiteImagesXIB
        cell.imgVwSite.sd_imageIndicator = SDWebImageActivityIndicator.gray
        cell.imgVwSite.sd_setImage(with: URL(string: "\(arrImages[indexPath.row])"), placeholderImage: .placeholderImage())
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: self.collVwImages.frame.size.width, height: (self.collVwImages.frame.size.height))
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == collVwImages {
            let offSet = scrollView.contentOffset.x
            let width = scrollView.frame.width
            let index = Int(round(offSet/width))
            self.pgControl.setPage(index)
        }
    }
}
