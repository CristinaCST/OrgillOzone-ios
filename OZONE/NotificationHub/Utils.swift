//
//  Copyright © 2018 Microsoft All rights reserved.
//  Licensed under the Apache License (2.0).
//

import Foundation
import UIKit


struct Constants {
    static let NHUserDefaultTags = "notification_tags";
}

func getNotificationHub() -> SBNotificationHub {
    let NHubName = "WeatcbNotificationHub"
//    let NHubConnectionString = "Endpoint=sb://WeatcbNotificationHubNs.servicebus.windows.net/;SharedAccessKeyName=DefaultFullSharedAccessSignature;SharedAccessKey=7vcsZfz1YdqrJaK1PPF2vY3s65uN/+XaKVmRtaRQtOo="
    let NHubConnectionString = "Endpoint=sb://weatcbnotificationhubns.servicebus.windows.net/;SharedAccessKeyName=DefaultFullSharedAccessSignature;SharedAccessKey=7vcsZfz1YdqrJaK1PPF2vY3s65uN/+XaKVmRtaRQtOo="
    
    return SBNotificationHub.init(connectionString: NHubConnectionString, notificationHubPath: NHubName)
}

func showAlert(_ message: String, withTitle title: String = "Alert") {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
}
