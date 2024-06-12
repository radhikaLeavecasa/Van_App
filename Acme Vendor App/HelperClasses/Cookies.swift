//
//  Cookes.swift
//  Josh
//
//  Created by Esfera-Macmini on 28/04/22.
//

import Foundation

extension NSDictionary {
    
    var type:String{
        let type = self["type"] as? String ?? ""
        return type
    }
    
    var name:String{
        let fullName = self["name"] as? String ?? ""
        return fullName
    }
    
    var notification_setting: Int{
        let notification_setting = self["notification_setting"] as? Int ?? 0
        return notification_setting
    }
    
    var id:Int{
        let title = self["id"] as? Int ?? 0
        return title
    }
    
}

class Cookies {
    
    class func userInfoSave(dict : [String : Any]? = nil){
        let keyData = NSKeyedArchiver.archivedData(withRootObject: dict as Any)
        UserDefaults.standard.set(keyData, forKey: "userInfoSave")
        UserDefaults.standard.synchronize()
    }
    
    class func userInfo() -> NSDictionary? {
        if let some =  UserDefaults.standard.object(forKey: "userInfoSave") as? NSData {
            if let dict = NSKeyedUnarchiver.unarchiveObject(with: some as Data) as? NSDictionary {
                return dict
            }
        }
        return nil
    }
    
//    class func saveUserToken(token: String) {
//        UserDefaults.standard.set(token, forKey: CommonParam.DEVICE_TOKEN)
//    }
//    
//    class func saveUserCredit(token: String) {
//        UserDefaults.standard.set(token, forKey: "Passes")
//    }
    
//    class func saveIntro(bool: Bool) {
//        UserDefaults.standard.set(bool, forKey: CommonParam.INTRO_DONE)
//    }
    
//    class func saveDeviceToken(token: String) {
//        UserDefaults.standard.set(token, forKey: "deviceToken")
//    }
//    
//    class func saveUserTokenId(tokenId: Int) {
//        UserDefaults.standard.set(tokenId, forKey: "UserTokenId")
//    }
//    
//    class func getUserTokenId() -> Int {
//        if let token = UserDefaults.standard.value(forKey: "UserTokenId") as? Int {
//            return token
//        }
//        return 0
//    }
    
//    class func getInto() -> Bool {
//        if let intro = UserDefaults.standard.value(forKey: CommonParam.INTRO_DONE) as? Bool {
//            return intro
//        }
//        return false
//    }
    
//    class func getDeviceToken() -> String {
//        if let token = UserDefaults.standard.value(forKey: "deviceToken") as? String {
//            return token
//        }
//        return "123"
//    }
    
    class func getUserToken() -> String {
        if let token = UserDefaults.standard.value(forKey: WSResponseParams.WS_RESP_PARAM_ACCESS_TOKEN) as? String {
            return token
        }
        return ""
    }
    
//    class func getUserCredit() -> String {
//        if let token = UserDefaults.standard.value(forKey: "Passes") as? String {
//            return token
//        }
//        return ""
//    }
    
    class func deleteUserInfo() {
        UserDefaults.standard.removeObject(forKey: "userInfoSave")
    }
    
    class func deleteUserToken() {
        UserDefaults.standard.removeObject(forKey: WSResponseParams.WS_RESP_PARAM_ACCESS_TOKEN)
    }
}

//var currentAccessToken :String? {
//    get {
//        return UserDefaults.standard.currentAccessToken()
//    }
//    set {
//        UserDefaults.standard.currentAccessToken(newValue)
//    }
//}

//extension UserDefaults {
//    
//    /// Private key for persisting the active Theme in UserDefaults
//    private static let currentAccessTokenKey = "AuthToken"
//    
//    /// Retreive theme identifer from UserDefaults
//    public func currentAccessToken() -> String? {
//        return self.string(forKey: UserDefaults.currentAccessTokenKey)
//    }
//    
//    /// Save theme identifer to UserDefaults
//    public func currentAccessToken(_ identifier: String?) {
//        self.set(identifier, forKey: UserDefaults.currentAccessTokenKey)
//    }
//}
