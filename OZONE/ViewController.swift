//
//  ViewController.swift
//  WEATCB
//
//  Created by Diego Cando on 3/11/20.
//  Copyright © 2020 Eugeniuses. All rights reserved.
//

import UIKit
import WebKit
import AVFoundation

class ViewController: UIViewController,  ScannerReturnProtocol{
    
    @IBOutlet weak var webViewHolder: UIView!
    var splace : UIView?
    var webView:WKWebView!
    var activityView = UIActivityIndicatorView(style: .large)
    
    var timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true, block: { timer in
        
        if !isServerRunning()
        {
            DispatchQueue.global(qos: .background).async{
                startWeb()
            }
        }
    })
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.willResignActiveNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(appMovedToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(recievedDataFromPushNotification(_ :)), name: NSNotification.Name(rawValue: RECIVED_DATA_FROM_PUSH), object: nil)
        notificationCenter.addObserver(self, selector: #selector(displayActivityIndicator(_ :)), name: NSNotification.Name(rawValue: DISPLAY_ACTIVITY_INDICATOR), object: nil)
        
        showSpalceView()
        
        //add activity indicator
        activityView.center = self.view.center
        self.view.addSubview(activityView)
        
        viewdidappear()
    }
    
    @objc func appMovedToBackground() {
        //        stopServer()
        //        timer.invalidate()
    }
    
    @objc func displayActivityIndicator(_ notification : NSNotification) {
        if let status : Bool = notification.userInfo?["isDisplayIndicator"] as? Bool{
            if status == true {
                activityView.startAnimating()
            }
            if status == false {
                activityView.stopAnimating()
            }
        }
    }
    
    @objc func recievedDataFromPushNotification(_ notification : NSNotification) {
        if let jsonStr = notification.userInfo?["pushDataStr"] {
            
            evaluateWithJavaScriptExpression(jsExpression: "this.window.ozone.openNotification(JSON.stringify(\(jsonStr)));")
        }
    }
    
    @objc func appMovedToForeground() {
        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true, block: { timer in
            
            if !isServerRunning()
            {
                DispatchQueue.global(qos: .background).async{
                    startWeb()
                }
            }
        })
    }
    
    func viewdidappear(){
        
        startWebServer()
        do {
            sleep(2)
        }
        initializeWebView()
        
        self.loadPage()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //        startWebServer()
        //        do {
        //            sleep(2)
        //        }
        //        initializeWebView()
        //
        //        self.loadPage()
    }
    
    func startWebServer(){
        if !isServerRunning()
        {
            DispatchQueue.global(qos: .utility).async{
                startWeb()
            }
        }
    }
    
    private func initializeWebView(){
        
        let configuration = WKWebViewConfiguration()
        let contentController = WKUserContentController()
        
        contentController.add(self, name: "native")
        
        configuration.userContentController = contentController
        configuration.setValue(true, forKey: "allowUniversalAccessFromFileURLs")
        
        injectScript(contentController, configuration)
        
        webView = WKWebView(frame: .zero, configuration: configuration)
        webView.isOpaque = false
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.sizeToFit()
        webViewHolder.addSubview(webView)
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: webViewHolder.topAnchor),
            webView.bottomAnchor.constraint(equalTo: webViewHolder.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: webViewHolder.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: webViewHolder.trailingAnchor)
        ])
    }
    
    private func loadPage(){
        if let url = URL(string: "http://[::1]:8080/") {
            let myRequest = URLRequest(url: url)
            webView.load(myRequest)
        }
    }
    
    private func injectScript(_ contentController : WKUserContentController, _ configuration : WKWebViewConfiguration){
        
        //Script For Scanner
        configuration.userContentController.add(self, name: "callScanner")
        let scriptScanner = "javascript:window.ozone.openScanner = function() { window.webkit.messageHandlers.callScanner.postMessage('invoke')}"
        let scannerScript = WKUserScript(source: scriptScanner, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        contentController.addUserScript(scannerScript)
        
        //Script For Push Notification On
        configuration.userContentController.add(self, name: "pushNotificationOn")
        let scriptPushOn = "javascript:window.ozone.pushNotificationOn = function() { window.webkit.messageHandlers.pushNotificationOn.postMessage('invoke')}"
        let pushOnScript = WKUserScript(source: scriptPushOn, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        contentController.addUserScript(pushOnScript)
        
        //Script For Push Notification Off
        configuration.userContentController.add(self, name: "pushNotificationOff")
        let scriptPushOff = "javascript:window.ozone.pushNotificationOff = function() { window.webkit.messageHandlers.pushNotificationOff.postMessage('invoke')}"
        let pushOffScript = WKUserScript(source: scriptPushOff, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        contentController.addUserScript(pushOffScript)
        
        //Script For Kill application
        configuration.userContentController.add(self, name: "closeApp")
        let scriptKillApp = "javascript:window.ozone.closeApp = function() { window.webkit.messageHandlers.closeApp.postMessage('invoke')}"
        let killAppScript = WKUserScript(source: scriptKillApp, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        contentController.addUserScript(killAppScript)
        
        configuration.userContentController.add(self, name: "getAppDetails")
        let scriptGetAppDetail = "javascript:window.ozone.getAppDetails = function() { window.webkit.messageHandlers.getAppDetails.postMessage('invoke')}"
        let getAppDetailScript = WKUserScript(source: scriptGetAppDetail, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        contentController.addUserScript(getAppDetailScript)
        
        //Script For onCameraPermissionAllow
        configuration.userContentController.add(self, name: "callOnCameraPermissionAllow")
        let scriptOnCameraPermissionAllow = "javascript:window.ozone.onCameraPermissionAllow = function() { window.webkit.messageHandlers.callOnCameraPermissionAllow.postMessage('invoke')}"
        let onCameraPermissionAllowScript = WKUserScript(source: scriptOnCameraPermissionAllow, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        contentController.addUserScript(onCameraPermissionAllowScript)
        
        //        configuration.userContentController.add(self, name: "openCamera")
        //        let scriptOpenCamera = "javascript:window.ozone.openCamera = function() { window.webkit.messageHandlers.openCamera.postMessage('invoke')}"
        //        let openCameraScript = WKUserScript(source: scriptOpenCamera, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        //        contentController.addUserScript(openCameraScript)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func ReturnValue(value: String) {
        //Receive the value from scanner then pass it to wkwebview
        evaluateWithJavaScriptExpression(jsExpression: "this.window.ozone.fetchProductInfo('\(value)');")
    }
    func ShowCameraPermissionPopUp(){
        evaluateWithJavaScriptExpression(jsExpression: "this.window.ozone.showRequestCameraPermissionPopUp();")
    }
    
    func onCameraPermissionAllow(){
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                   return
               }

               if UIApplication.shared.canOpenURL(settingsUrl) {
                   UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                       print("Settings opened: \(success)") // Prints true
                   })
               }
    }
    
    func CallScannerVC(){
        print("HEYEYEYEY")
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            openScanner()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    self.openScanner()
                } else {
                    DispatchQueue.main.async {
                        self.ShowCameraPermissionPopUp()
                    }
                }
            }
        case .denied, .restricted:
            self.ShowCameraPermissionPopUp()
        @unknown default:
            fatalError("Unknown camera authorization status.")
        }
       
    }
    
    func openScanner(){
        DispatchQueue.main.async {
            let destVC = ScannerViewController()
            destVC.scannerReturns = self
            let navController = UINavigationController(rootViewController: destVC)
            self.present(navController, animated: true)
        }
    }
    func pushNotificationOn(){
         
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                if (settings.authorizationStatus != .denied){
                    self.evaluateWithJavaScriptExpression(jsExpression: "this.window.ozone.setNotification('\(COMMON.getPushParameterString("register"))');")
                }
                else{
                    let alert = UIAlertController(title: "ozone Would Like to Send You Push Notification", message: "Please go to your mobile notification setting and allow to send you notification.", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
                    alert.addAction(UIAlertAction(title: "Setting", style: UIAlertAction.Style.default, handler: {(event) in
                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, completionHandler: { (success) in
                            print("Settings opened: \(success)") // Prints true
                        })
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    func pushNotificationOff(){
         self.evaluateWithJavaScriptExpression(jsExpression: "this.window.ozone.setNotification('\(COMMON.getPushParameterString("unregister"))');")
    }
    
    func closeApplication(){
        exit(0)
    }
    
    func saveGuid(){
        COMMON.getGUID = ""
    }
    
    func deleteGuid(){
        COMMON.getGUID = ""
    }
    
    func getGuid(){
        self.evaluateWithJavaScriptExpression(jsExpression: "this.window.ozone.getGuidFromApp('\(COMMON.getGUID)');")
    }
    
    func setAppDetails(){
        COMMON.getAppDetails { (value) in
            DispatchQueue.main.async {
            self.evaluateWithJavaScriptExpression(jsExpression: "this.window.ozone.setAppDetails('\(value)');")
            }
        }
    }
    
//    func openCamera(){
//        let vc = UIImagePickerController()
//        vc.sourceType = .camera
//        vc.allowsEditing = true
//        vc.delegate = self
//        present(vc, animated: true)
//    }
    
    fileprivate func evaluateWithJavaScriptExpression(jsExpression: String){
        webView.evaluateJavaScript(jsExpression, completionHandler: { (_, error) in
            if((error) != nil){
                print("fail")
                print(error?.localizedDescription ?? "")
                print(error as Any)
            }else{
                
            }
        })
    }
    
    
    func showSpalceView() {
        
        splace = Bundle.main.loadNibNamed("SplaceView", owner: self, options: nil)?.first as? SplaceView
        splace?.frameSetX(0, y: 0)
        splace?.frameSetWidth(self.view.frame.width, height: self.view.frame.height)
        self.view.addSubview(splace!)
    }
    
    func removeSplaceView() {
        self.splace?.removeFromSuperview()
    }
}

extension ViewController: WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler{
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        //        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        if traitCollection.userInterfaceStyle == .light {
            evaluateWithJavaScriptExpression(jsExpression: "this.window.ozone.setDarkMode(false);")
        } else {
            evaluateWithJavaScriptExpression(jsExpression: "this.window.ozone.setDarkMode(true);")
        }
        
        //Call JS function for set device token
//        evaluateWithJavaScriptExpression(jsExpression: "this.window.ozone.setDeviceToken('\(COMMON.getDeviceToken())');")
        
        if splace != nil{
            removeSplaceView()
        }
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        //Receive and act calls from WKWebView
        
        switch message.name {
        case "callScanner":
            CallScannerVC()
        case "pushNotificationOn":
            pushNotificationOn()
        case "pushNotificationOff":
            pushNotificationOff()
        case "saveGuid":
            saveGuid()
        case "deleteGuid":
            deleteGuid()
        case "getGuid":
            getGuid()
        case "callOnCameraPermissionAllow":
            onCameraPermissionAllow()
        case "getAppDetails":
            setAppDetails()
//        case "openCamera":
//            openCamera()
//        case "closeApp":
//            closeApplication()
        default: break
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
      
        if navigationAction.navigationType == .linkActivated  {
            if let url = navigationAction.request.url,
                UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
                print(url)
                decisionHandler(.cancel)
            }
        } else {
            print("not a user click")
            decisionHandler(.allow)
        }
    }
}



//extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        picker.dismiss(animated: true)
//
//        guard let image = info[.editedImage] as? UIImage else {
//            print("No image found")
//            return
//        }
//
//        let data = image.jpegData(compressionQuality: 1.0)
//        print(data!)
//        self.evaluateWithJavaScriptExpression(jsExpression: "this.window.ozone.getCameraImage('\(data!)');")
////        self.evaluateWithJavaScriptExpression(jsExpression: "this.window.ozone.getCameraImage('\(image.toBase64()!)');")
//        picker.dismiss(animated: true, completion: nil)
//    }
//}
//
//extension UIImage {
//    func toBase64() -> String? {
//        guard let imageData = self.pngData() else { return nil }
//        return imageData.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
//    }
//}



