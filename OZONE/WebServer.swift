//
//  WebServer.swift
//  WEATCB
//
//  Created by Diego Cando on 3/18/20.
//  Copyright © 2020 Eugeniuses. All rights reserved.
//

import Foundation

let webServer = GCDWebServer()

func startWeb() {
    
    webServer.addDefaultHandler(forMethod: "GET", request: GCDWebServerRequest.self, processBlock: {request in
        let path:String = request.path
        if(path == "/" || path == "/index.html"){
            var html: String = ""
            let script: String = """
            <script>(function() {
                      console.log(window.location.href);
                      var proxied = window.XMLHttpRequest.prototype.open;
                      window.XMLHttpRequest.prototype.open = function() {
                        arguments[1] = "/metaProxy/" + arguments[1];
                        return proxied.apply(this, [].slice.call(arguments));
                      };
                    })();</script></body></html>
            """
            
            if let filepath = Bundle.main.path(forResource: "index", ofType: "html") {
                do {
                    html = try String(contentsOfFile: filepath)
                    html = html.replacingOccurrences(of: "</body></html>", with: script)
                } catch {
                    // contents could not be loaded
                }
            } else { }
            
            
            if(html != "")
            {
                return GCDWebServerDataResponse(html: html)
            }else{
                do {
                    guard let fileURL = Bundle.main.url(forResource: "index", withExtension: "html") else {
                        throw NSError(domain: "YourAppDomain", code: 404, userInfo: [NSLocalizedDescriptionKey: "index.html file not found."])
                    }
                    
                    let data = try Data(contentsOf: fileURL)
                    return GCDWebServerDataResponse(data: data, contentType: "text/html")
                } catch {
                    print("Error loading index.html: \(error)")
                    return GCDWebServerResponse(statusCode: 500)
                }
            }
        }
        
        if (path.contains("metaProxy") || path.contains("webservice")) {
            var localData = Data("Nothing found".utf8)
            var query = "\(request.url)"
            query = String(query.split(separator: " ", maxSplits: .max, omittingEmptySubsequences: true).first ?? "")
            
            query = query.replacingOccurrences(of: "/metaProxy/", with: "")
            var statuscode : Int = 0
            let group = DispatchGroup()
            group.enter()
            ProxyManager.shared.getData(for: "\(query)", request: request) { (data, statusCode, error) in
                if let _ = error {
                    return
                }
                localData = data!
                statuscode = statusCode!
                group.leave()
            }
            group.wait()
    
            if statuscode == 500{
                return GCDWebServerDataResponse(statusCode : statuscode)
            }
            else{
                return GCDWebServerDataResponse(data: localData, contentType: "text")
            }
        }else{
            let fileExt:String = String(path.split(separator: ".", maxSplits: .max, omittingEmptySubsequences: true).last!)
            var fileName:String = String(path.split(separator: "/", maxSplits: .max, omittingEmptySubsequences: true).last!)
            var mimeType = ""
            
            switch fileExt {
                case "ico":
                    mimeType = "image/png"
                case "js":
                    mimeType = "text/javascript"
                case "html":
                    mimeType = "text/html"
                case "css":
                    mimeType = "text/css"
                case "map":
                    mimeType = "text/html"
                case "json":
                    mimeType = "application/json"
                case "png":
                    mimeType = "image/png"
                case "jpeg", "jpg":
                    mimeType = "image/jpeg"
                case "gif":
                    mimeType = "image/gif"
                case "svg":
                    mimeType = "image/svg+xml"
                case "mp3":
                    mimeType = "audio/mpeg"
                case "ogg":
                    mimeType = "audio/ogg"
                case "mp4":
                    mimeType = "video/mp4"
                case "webm":
                    mimeType = "video/webm"
                case "pdf":
                    mimeType = "application/pdf"
                case "xml":
                    mimeType = "application/xml"
                case "woff":
                    mimeType = "font/woff"
                case "woff2":
                    mimeType = "font/woff2"
                case "ttf":
                    mimeType = "font/ttf"
                case "otf":
                    mimeType = "font/otf"
                case "csv":
                    mimeType = "text/csv"
                case "txt":
                    mimeType = "text/plain"
                case "xls", "xlsx":
                    mimeType = "application/vnd.ms-excel"
                case "ppt", "pptx":
                    mimeType = "application/vnd.ms-powerpoint"
                case "zip":
                    mimeType = "application/zip"
                case "xhtml":
                    mimeType = "application/xhtml+xml"
                default:
                    mimeType = "application/octet-stream"
            }
            
            fileName = fileName.replacingOccurrences(of: ".\(fileExt)", with: "")
            do {
                guard let fileURL = Bundle.main.url(forResource: fileName, withExtension: fileExt) else {
                    throw NSError(domain: "YourAppDomain", code: 404, userInfo: [NSLocalizedDescriptionKey: "\(fileName).\(fileExt) file not found."])
                }
                print("DATATATATAT:L:::::::\(fileURL)")
                let data = try Data(contentsOf: fileURL)
                return GCDWebServerDataResponse(data: data, contentType: mimeType)
            } catch {
                print("Error loading \(fileName).\(fileExt): \(error)")
                return GCDWebServerResponse(statusCode: 404)
            }
        }
    })
    
    
    
    webServer.addHandler(forMethod: "POST", pathRegex: "/.*", request: GCDWebServerDataRequest.self, processBlock: { (request) -> GCDWebServerResponse? in
             
            var localData = Data("Nothing found".utf8)
            var statuscode : Int = 0
            var query = "\(request.url)"
            query = String(query.split(separator: " ", maxSplits: .max, omittingEmptySubsequences: true).first ?? "")
            query = query.replacingOccurrences(of: "/metaProxy/", with: "")
            
            let value = ((request as? GCDWebServerDataRequest)?.jsonObject)
        print((request as? GCDWebServerDataRequest)?.headers ?? "")
            let group = DispatchGroup()
            group.enter()
        ProxyManager.shared.postData(for: "\(query)", parameters : value as? [String : Any], reque: request as! GCDWebServerDataRequest) { (data,statusCode, error) in
    //            if let _ = error {
    //                statuscode = statusCode!
    //                return
    //            }
                localData = data!
                statuscode = statusCode!
                group.leave()
            }
            group.wait()
            
        if statuscode == 410{
            return GCDWebServerDataResponse(statusCode : 410)
        }
        else if statuscode == 404{
            return GCDWebServerDataResponse(statusCode : 404)
        }
        else if statuscode == 500{
            return GCDWebServerDataResponse(statusCode : 500)
        }
        else{
            return GCDWebServerDataResponse(data: localData, contentType: "text")
        }
        })
    
    
        webServer.addHandler(forMethod: "PUT", pathRegex: "/.*", request: GCDWebServerDataRequest.self, processBlock: { (request) -> GCDWebServerResponse? in
          
            var localData = Data("Nothing found".utf8)
            var query = "\(request.url)"
            query = String(query.split(separator: " ", maxSplits: .max, omittingEmptySubsequences: true).first ?? "")
            query = query.replacingOccurrences(of: "/metaProxy/", with: "")
            
            let value = ((request as? GCDWebServerDataRequest)?.jsonObject)
            var statuscode : Int = 0
            let group = DispatchGroup()
            group.enter()
            ProxyManager.shared.putData(for: "\(query)", parameters : value as? [String : Any], reque: request as! GCDWebServerDataRequest) { (data,statusCode, error) in
                if let _ = error {
                    
                    return
                }
                localData = data!
                statuscode = statusCode!
                group.leave()
            }
            group.wait()
            
            if statuscode == 500{
                return GCDWebServerDataResponse(statusCode : 500)
            }
            else{
                return GCDWebServerDataResponse(data: localData, contentType: "text")
            }
            
        })
        
        
        webServer.addHandler(forMethod: "DELETE", pathRegex: "/.*", request: GCDWebServerDataRequest.self, processBlock: { (request) -> GCDWebServerResponse? in
         
            var localData = Data("Nothing found".utf8)
            var query = "\(request.url)"
            query = String(query.split(separator: " ", maxSplits: .max, omittingEmptySubsequences: true).first ?? "")
            query = query.replacingOccurrences(of: "/metaProxy/", with: "")
            
            let value = ((request as? GCDWebServerDataRequest)?.jsonObject)
            var statuscode : Int = 0
            let group = DispatchGroup()
            group.enter()
            ProxyManager.shared.deleteData(for: "\(query)", parameters : value as? [String : Any], reque: request as! GCDWebServerDataRequest) { (data,statusCode, error) in
                if let _ = error {
                    
                    return
                }
                localData = data!
                statuscode = statusCode!
                group.leave()
            }
            group.wait()
            
            if statuscode == 500{
                return GCDWebServerDataResponse(statusCode : 500)
            }
            else{
                return GCDWebServerDataResponse(data: localData, contentType: "text")
            }
        })
    webServer.start(withPort: 8080, bonjourName: "Ionic")
//    do {
//        // Start the server on port 8080
//        try webServer.start(options: [
//            GCDWebServerOption_Port: 8080,
//            GCDWebServerOption_BindToLocalhost: true
//        ])
//
//        print("Server started on port \(webServer.port)")
//    } catch let error {
//        print("Error starting server: \(error)")
//    }
//    webServer.start(withPort: 8080, bonjourName: "Ionic")
}

func isServerRunning() -> Bool{
    return webServer.isRunning
}
