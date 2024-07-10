//
//  CommonFunctions.swift
//  WEATCB
//
//  Created by Kevin Baldha on 20/05/20.
//  Copyright © 2020 Eugeniuses. All rights reserved.
//

import Foundation
import WebKit

class CommonFunctions : NSObject {
    
    
    class var sharedInstance: CommonFunctions
    {
        struct Static
        {
            static let instance = CommonFunctions()
        }
        return Static.instance
    }
    
    var getGUID : String {
        get{
            return DEFAULTS.value(forKey: GUID) as! String
        }
        set(newValue){
            DEFAULTS.set(newValue, forKey: GUID)
        }
    }
    
    func getDeviceToken() -> String{
        var deviceToken = "Simulator"
        if let token = DEFAULTS.value(forKey: DEVICE_TOKEN){
            deviceToken = token as! String
        }
        return deviceToken
    }
    
    func getPushParameterString(_ action : String) -> String{
        
        let param = [
              "Action": action,
              "DeviceToken": getDeviceToken(),
              "Platform": "iOS",
        ]
        return String().convertDictToJASONString(dict: param as [String : AnyObject])
    }
    
    func getGuidFromCookie() {
        let dataStore = WKWebsiteDataStore.default()
        dataStore.httpCookieStore.getAllCookies({ (cookies) in
            for cookie in cookies {
                if cookie.name == "guid"{
                    self.getGUID = cookie.value
                }
            }
        })
    }
    
    func getAppDetails(completion: @escaping (String) -> Void) {
         _ = try? isUpdateAvailable { (update, error, result) in
            if let error = error {
                print(error)
            } else if let update = update {
                print(update)
            }
            
            var currentVersionReleaseDate = "2020-10-01T06:44:37Z"
            var currentVersion = "0.0"
            
            if let result = result {
                if let ReleaseDate = result["currentVersionReleaseDate"] as? String{
                    currentVersionReleaseDate = ReleaseDate
                }
                if let version = result["version"] as? String{
                    currentVersion = version
                }
            }
        
            let param = [
                "currentAppVersion": currentVersion,
                "releaseDate": currentVersionReleaseDate,
                "deviceToken": self.getDeviceToken(),
                "platform": "iOS",
            ]
            
            completion(String().convertDictToJASONString(dict: param as [String : AnyObject]))
        }
     
    }
    
    func isUpdateAvailable(completion: @escaping (Bool?, Error?, [String: Any]?) -> Void) throws -> URLSessionDataTask {
            guard let info = Bundle.main.infoDictionary,
                let currentVersion = info["CFBundleShortVersionString"] as? String,
                let identifier = info["CFBundleIdentifier"] as? String,
                let url = URL(string: "\(ITUNES_URL)lookup?bundleId=\(identifier)") else {
                    throw VersionError.invalidBundleInfo
            }
            print(currentVersion)
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                do {
                    if let error = error { throw error }
                    guard let data = data else { throw VersionError.invalidResponse }
                    let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? [String: Any]
                    guard let result = (json?["results"] as? [Any])?.first as? [String: Any], let version = result["version"] as? String else {
                        throw VersionError.invalidResponse
                    }
                    completion(version != currentVersion, nil, result)
                } catch {
                    completion(nil, error, nil)
                }
            }
            task.resume()
            return task
        }
    
}
