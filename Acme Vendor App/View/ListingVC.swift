//
//  ListingVC.swift
//  Acme Vendor App
//
//  Created by acme on 07/06/24.
//

import UIKit
import SDWebImage

class ListingVC: UIViewController {
    //MARK: - @IBOutlets
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var lblNoDataFound: UILabel!
    @IBOutlet weak var collVwSites: UICollectionView!
    @IBOutlet weak var collVwOptions: UICollectionView!
    //MARK: - Variable
    var arrHeader = ["Vans","Drivers","Helpers","Supervisors"]
    var viewModel = ListingVM()
    var selectedIndex = Int()
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        
    }
    override func viewWillAppear(_ animated: Bool) {
        if Cookies.userInfo()?.type == 1 {
            btnAdd.isHidden = true
            viewModel.getPostVanApi(.get, completion: { val, msg in
                if val {
//                    if self.viewModel.arrListing?.count == 0 {
//                        self.lblNoDataFound.isHidden = false
//                        self.collVwSites.isHidden = true
//                    } else {
//                        self.lblNoDataFound.isHidden = true
//                        self.collVwSites.isHidden = false
//                    }
                    self.collVwSites.reloadData()
                } else {
                    if msg == CommonError.INTERNET {
                        Proxy.shared.showSnackBar(message: CommonMessage.NO_INTERNET_CONNECTION)
                    } else {
                        Proxy.shared.showSnackBar(message: msg)
                    }
                }
            })
        } else if Cookies.userInfo()?.type == 2 {
            btnAdd.isHidden = false
            
        }
    }
    @IBAction func actionAdd(_ sender: Any) {
        let vc = ViewControllerHelper.getViewController(ofType: .AddDetailsVC, StoryboardName: .Main) as! AddDetailsVC
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        vc.tagDelegate = { tag in
            let vc = ViewControllerHelper.getViewController(ofType: .RegisterDetailsVC, StoryboardName: .Main) as! RegisterDetailsVC
            vc.type = tag
            self.pushView(vc: vc)
        }
        self.present(vc, animated: true)
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
}

extension ListingVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionView == collVwOptions ? arrHeader.count : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collVwOptions {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OptionsCVC", for: indexPath) as! OptionsCVC
            cell.vwTitle.backgroundColor = indexPath.row == selectedIndex ? .APP_BLUE_CLR : .APP_GRAY_CLR
            cell.lblTitle.text = arrHeader[indexPath.row]
            cell.lblTitle.textColor = indexPath.row == selectedIndex ? .APP_GRAY_CLR : .APP_BLUE_CLR
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SiteCVC", for: indexPath) as! SiteCVC
//            cell.lblShopName.text = viewModel.arrListing?[indexPath.row].retailName
//            cell.imgVwSite.sd_setImage(with: URL(string: "\(imageBaseUrl)\(viewModel.arrListing?[indexPath.row].image1 ?? "")"), placeholderImage: .placeholderImage())
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collVwOptions {
            let label = UILabel(frame: CGRect.zero)
            label.text = arrHeader[indexPath.item]
            label.sizeToFit()
            return CGSize(width: label.frame.width+15, height: self.collVwOptions.frame.size.height)
        } else {
            if indexPath.row == 0 {
                return CGSize(width: self.collVwSites.frame.size.width/2, height: self.collVwSites.frame.size.width/2)
            } else {
                return CGSize(width: self.collVwSites.frame.size.width, height: self.collVwSites.frame.size.width/2)
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == collVwOptions {
            selectedIndex = indexPath.row
            
            switch indexPath.row {
            case 0:
                viewModel.getPostVanApi(.get, completion: { val, msg in
                    if val {
    //                    if self.viewModel.arrListing?.count == 0 {
    //                        self.lblNoDataFound.isHidden = false
    //                        self.collVwSites.isHidden = true
    //                    } else {
    //                        self.lblNoDataFound.isHidden = true
    //                        self.collVwSites.isHidden = false
    //                    }
                        self.collVwSites.reloadData()
                    } else {
                        if msg == CommonError.INTERNET {
                            Proxy.shared.showSnackBar(message: CommonMessage.NO_INTERNET_CONNECTION)
                        } else {
                            Proxy.shared.showSnackBar(message: msg)
                        }
                    }
                })
            case 1:
                viewModel.getPostDriverApi(.get, completion: { val, msg in
                    if val {
    //                    if self.viewModel.arrListing?.count == 0 {
    //                        self.lblNoDataFound.isHidden = false
    //                        self.collVwSites.isHidden = true
    //                    } else {
    //                        self.lblNoDataFound.isHidden = true
    //                        self.collVwSites.isHidden = false
    //                    }
                        self.collVwSites.reloadData()
                    } else {
                        if msg == CommonError.INTERNET {
                            Proxy.shared.showSnackBar(message: CommonMessage.NO_INTERNET_CONNECTION)
                        } else {
                            Proxy.shared.showSnackBar(message: msg)
                        }
                    }
                })
            case 2:
                viewModel.getPostHelperApi(.get, completion: { val, msg in
                    if val {
    //                    if self.viewModel.arrListing?.count == 0 {
    //                        self.lblNoDataFound.isHidden = false
    //                        self.collVwSites.isHidden = true
    //                    } else {
    //                        self.lblNoDataFound.isHidden = true
    //                        self.collVwSites.isHidden = false
    //                    }
                        self.collVwSites.reloadData()
                    } else {
                        if msg == CommonError.INTERNET {
                            Proxy.shared.showSnackBar(message: CommonMessage.NO_INTERNET_CONNECTION)
                        } else {
                            Proxy.shared.showSnackBar(message: msg)
                        }
                    }
                })
            default:
                viewModel.getPostSupervisorApi(.get, completion: { val, msg in
                    if val {
    //                    if self.viewModel.arrListing?.count == 0 {
    //                        self.lblNoDataFound.isHidden = false
    //                        self.collVwSites.isHidden = true
    //                    } else {
    //                        self.lblNoDataFound.isHidden = true
    //                        self.collVwSites.isHidden = false
    //                    }
                        self.collVwSites.reloadData()
                    } else {
                        if msg == CommonError.INTERNET {
                            Proxy.shared.showSnackBar(message: CommonMessage.NO_INTERNET_CONNECTION)
                        } else {
                            Proxy.shared.showSnackBar(message: msg)
                        }
                    }
                })
            }
            collVwOptions.reloadData()

        } else {
//            let vc = ViewControllerHelper.getViewController(ofType: .SiteDetailVC, StoryboardName: .Main) as! SiteDetailVC
//            vc.siteDetail = viewModel.arrListing?[indexPath.row]
//            self.pushView(vc: vc)
        }
    }
}
