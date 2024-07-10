//
//  ProxyManager.swift
//  WEATCB
//
//  Created by Diego Cando on 4/6/20.
//  Copyright © 2020 Eugeniuses. All rights reserved.
//

import UIKit

class ProxyManager {
    static let shared = ProxyManager()
    let cache = NSCache<NSString, UIImage>()
    
    private init(){}
    
    func getData(for urlPath: String, request: GCDWebServerRequest, completed: @escaping (Data?,Int?, String?) -> Void) {
        
        guard let url = URL(string: urlPath) else {
            completed(nil, 0,"Invalid request")
            return
        }
        
        let token = request.headers["Token"]
        print("**************************\(token ?? "")*******************************")
        var request = URLRequest(url: url)
        let session = URLSession.shared
        request.httpMethod = "GET" //set http method as GET
        request.addValue("\(token ?? "")", forHTTPHeaderField: "Token")
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if let _ = error {
                completed(nil,0, "There were an error")
                return
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode == 500 {
                completed(nil, response.statusCode, "There were an error in the response")
                return
            }
            
           
            
            guard let data = data else{
                completed(nil,0, "No data was returned")
                return
            }
            
            completed(data, 0, nil)
            return
        }
        
        task.resume()
    }
    
    func postData(for urlPath: String, parameters :  [String : Any]? , reque: GCDWebServerDataRequest ,completed: @escaping (Data?,Int?, String?) -> Void) {
        
        var request = URLRequest(url: URL(string: urlPath )!)
        let session = URLSession.shared
        request.httpMethod = "POST" //set http method as POST
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters ?? [:], options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
        } catch let error {
            print(error.localizedDescription)
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let token = reque.headers["Token"]
        print("**************************\(token ?? "")*******************************")
        request.addValue("\(token ?? "")", forHTTPHeaderField: "Token")
        
        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            if let _ = error {
                completed(nil,0, "There were an error")
                return
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode == 500 {
                completed(Data(), response.statusCode, "There were an error in the response")
                return
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode == 410 {
                completed(Data(), response.statusCode, "There were an error in the response")
                return
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode == 404 {
                completed(Data(), response.statusCode, "There were an error in the response")
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(Data(), 0, "There were an error in the response")
                return
            }
            
            guard let data = data else{
                completed(Data(), 0, "No data was returned")
                return
            }
            
            do{
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
                print(json ?? "")
            }
            catch{
                
            }
            
            completed(data, 0, nil)
            return
        })
        task.resume()
        
    }
    
    func putData(for urlPath: String, parameters :  [String : Any]? , reque: GCDWebServerDataRequest,completed: @escaping (Data?,Int?, String?) -> Void) {
        
        var request = URLRequest(url: URL(string: urlPath )!)
        let session = URLSession.shared
        request.httpMethod = "PUT" //set http method as POST
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters ?? [:], options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
        } catch let error {
            print(error.localizedDescription)
        }
        
        let token = reque.headers["Token"]
        print("**************************\(token ?? "")*******************************")
        request.addValue("\(token ?? "")", forHTTPHeaderField: "Token")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            if let _ = error {
                completed(nil,0, "There were an error")
                return
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode == 500 {
                completed(Data(), response.statusCode, "There were an error in the response")
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(Data(), 0, "There were an error in the response")
                return
            }
            
            guard let data = data else{
                completed(Data(), 0, "No data was returned")
                return
            }
            
            completed(data, 0, nil)
            return
        })
        task.resume()
        
    }
    
    func deleteData(for urlPath: String, parameters :  [String : Any]? , reque: GCDWebServerDataRequest,completed: @escaping (Data?,Int?, String?) -> Void) {
        
        var request = URLRequest(url: URL(string: urlPath )!)
        let session = URLSession.shared
        request.httpMethod = "DELETE" //set http method as POST
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters ?? [:], options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
        } catch let error {
            print(error.localizedDescription)
        }
        
        let token = reque.headers["Token"]
        print("**************************\(token ?? "")*******************************")
        request.addValue("\(token ?? "")", forHTTPHeaderField: "Token")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            if let _ = error {
                completed(nil,0, "There were an error")
                return
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode == 500 {
                completed(Data(), response.statusCode, "There were an error in the response")
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(Data(), 0, "There were an error in the response")
                return
            }
            
            guard let data = data else{
                completed(Data(), 0, "No data was returned")
                return
            }
            
            completed(data, 0, nil)
            return
        })
        task.resume()
        
    }
}
