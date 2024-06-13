//
//  ViewControllerHelper.swift
//  Josh
//
//  Created by Esfera-Macmini on 21/03/22.
//

import UIKit

enum StoryboardName : String{
    
    case Main
  
}

enum ViewControllerType : String {
    
    case WWCalendarTimeSelector
    case HomeVC
    case SplashVC
    case LoginVC
    case OtpVC
    case SignaturePopVC
    case SiteDetailVC
    case RejectionVC
    case ListingVC
    case AddDetailsVC
    case RegisterDetailsVC
}

class ViewControllerHelper: NSObject {
    class func getViewController(ofType viewControllerType: ViewControllerType, StoryboardName:StoryboardName) -> UIViewController {
        var viewController: UIViewController?
        let storyboard = UIStoryboard(name: StoryboardName.rawValue, bundle: nil)
        viewController = storyboard.instantiateViewController(withIdentifier: viewControllerType.rawValue)
        if let vc = viewController {
            return vc
        } else {
            return UIViewController()
        }
    }
}
