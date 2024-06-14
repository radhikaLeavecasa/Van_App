//
//  UIViewControllerExtension.swift
//  PropDub
//
//  Created by acme on 23/05/24.
//

import UIKit

extension UIViewController{
    func popView(){
        self.navigationController?.popViewController(animated: true)
    }
    func pushView(vc:UIViewController, title: String = "", animated: Bool = true){
        DispatchQueue.main.async {
            vc.title = title
            self.navigationController?.pushViewController(vc, animated: animated)
        }
    }
    func setView(vc: UIViewController, animation: Bool = true){
        DispatchQueue.main.async {
            self.navigationController?.setViewControllers([vc], animated: animation)
        }
    }
    func convertDateToString(_ date: Date, format : String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
    func convertDateWithDateFormater(_ formate:String,_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formate
        return dateFormatter.string(from: date)
    }
    func convertStringToDate(_ date: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
        return dateFormatter.date(from: date) ?? Date()
    }
}
