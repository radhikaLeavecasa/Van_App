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
        if Cookies.userInfo()?.type == "asm" {
            btnAdd.isHidden = true
            viewModel.asmSiteListingApi(.asmSiteListing(Cookies.userInfo()?.name ?? "")) { val, msg in
                if val {
                    if self.viewModel.arrListing?.count == 0 {
                        self.lblNoDataFound.isHidden = false
                        self.collVwSites.isHidden = true
                    } else {
                        self.lblNoDataFound.isHidden = true
                        self.collVwSites.isHidden = false
                    }
                    self.collVwSites.reloadData()
                } else {
                    if msg == CommonError.INTERNET {
                        Proxy.shared.showSnackBar(message: CommonMessage.NO_INTERNET_CONNECTION)
                    } else {
                        Proxy.shared.showSnackBar(message: msg)
                    }
                }
            }
        } else if Cookies.userInfo()?.type == "supervisor" {
            btnAdd.isHidden = false
            viewModel.supervisorListingApi(.supervisorListing(Cookies.userInfo()?.id ?? 0)) { val, msg in
                if val {
                    if self.viewModel.arrListing?.count == 0 {
                        self.lblNoDataFound.isHidden = false
                        self.collVwSites.isHidden = true
                    } else {
                        self.lblNoDataFound.isHidden = true
                        self.collVwSites.isHidden = false
                    }
                    self.collVwSites.reloadData()
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
    @IBAction func actionAdd(_ sender: Any) {
        let vc = ViewControllerHelper.getViewController(ofType: .HomeVC, StoryboardName: .Main) as! HomeVC
        self.pushView(vc: vc)
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
        collectionView == collVwOptions ? arrHeader.count : viewModel.arrListing?.count ?? 0
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
            cell.lblShopName.text = viewModel.arrListing?[indexPath.row].retailName
            cell.imgVwSite.sd_setImage(with: URL(string: "\(imageBaseUrl)\(viewModel.arrListing?[indexPath.row].image1 ?? "")"), placeholderImage: .placeholderImage())
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collVwOptions {
            return CGSize(width: self.collVwOptions.frame.size.width/4, height: self.collVwOptions.frame.size.height)
        } else {
            return CGSize(width: self.collVwSites.frame.size.width/2, height: self.collVwSites.frame.size.width/2)
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == collVwOptions {
            selectedIndex = indexPath.row
            
            switch Cookies.userInfo()?.type {
            case "asm": //(Cookies.userInfo()?.name ?? "") //Bipul Dubey //Rahul Dixit //VACANT ASM HP
                viewModel.asmSiteListingApi(indexPath.row == 0 ? .asmSiteListing(Cookies.userInfo()?.name ?? "") : indexPath.row == 1 ? .asmSitePending(Cookies.userInfo()?.name ?? "") : indexPath.row == 2 ? .asmSiteApproved(Cookies.userInfo()?.name ?? "") : .asmSiteRejected(Cookies.userInfo()?.name ?? "")) { val, msg in
                    if val {
                        if self.viewModel.arrListing?.count == 0 {
                            self.lblNoDataFound.isHidden = false
                            self.collVwSites.isHidden = true
                        } else {
                            self.lblNoDataFound.isHidden = true
                            self.collVwSites.isHidden = false
                        }
                        self.collVwSites.reloadData()
                    } else {
                        if msg == CommonError.INTERNET {
                            Proxy.shared.showSnackBar(message: CommonMessage.NO_INTERNET_CONNECTION)
                        } else {
                            Proxy.shared.showSnackBar(message: msg)
                        }
                    }
                }
            case "supervisor":
                viewModel.asmSiteListingApi(indexPath.row == 0 ? .supervisorListing(Cookies.userInfo()?.id ?? 0) : indexPath.row == 1 ? .supervisorPending(Cookies.userInfo()?.id ?? 0) : indexPath.row == 2 ? .supervisorApproved(Cookies.userInfo()?.id ?? 0) : .supervisorRejected(Cookies.userInfo()?.id ?? 0)) { val, msg in
                    if val {
                        if self.viewModel.arrListing?.count == 0 {
                            self.lblNoDataFound.isHidden = false
                            self.collVwSites.isHidden = true
                        } else {
                            self.lblNoDataFound.isHidden = true
                            self.collVwSites.isHidden = false
                        }
                        self.collVwSites.reloadData()
                    } else {
                        if msg == CommonError.INTERNET {
                            Proxy.shared.showSnackBar(message: CommonMessage.NO_INTERNET_CONNECTION)
                        } else {
                            Proxy.shared.showSnackBar(message: msg)
                        }
                    }
                }
            default:
                break
            }
            collVwOptions.reloadData()

        } else {
            let vc = ViewControllerHelper.getViewController(ofType: .SiteDetailVC, StoryboardName: .Main) as! SiteDetailVC
            vc.siteDetail = viewModel.arrListing?[indexPath.row]
            self.pushView(vc: vc)
        }
    }
}
