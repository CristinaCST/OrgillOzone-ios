//
//  Constants.swift
//  WEATCB
//
//  Created by Kevin Baldha on 20/05/20.
//  Copyright © 2020 Eugeniuses. All rights reserved.
//

import Foundation
import UIKit

let ITUNES_URL = "http://itunes.apple.com/"

let APPDEL = UIApplication.shared.delegate as! AppDelegate
let DEFAULTS = UserDefaults.standard
let COMMON = CommonFunctions.sharedInstance




let DEVICE_TOKEN = "DEVICE_TOKEN"
let RECIVED_DATA_FROM_PUSH = "RECIVED_DATA_FROM_PUSH"
let DISPLAY_ACTIVITY_INDICATOR = "DISPLAY_ACTIVITY_INDICATOR"
let GUID = "GUID"


enum VersionError: Error {
    case invalidResponse, invalidBundleInfo
}
