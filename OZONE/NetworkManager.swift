//
//  NetworkManager.swift
//  WEATCB
//
//  Created by Diego Cando on 4/1/20.
//  Copyright © 2020 Eugeniuses. All rights reserved.
//

import UIKit

class NetworkManager {
    static let shared = NetworkManager()
    private let baseUrl = "http://10.0.1.9:1337"
    let cache = NSCache<NSString, UIImage>()

    private init(){}

    func getData(for urlPath: String, completed: @escaping (Data?, String?) -> Void) {
         let endpoint = baseUrl + "\(urlPath)"

         guard let url = URL(string: endpoint) else {
            completed(nil, "Invalid request")
            return
         }

         let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
             if let _ = error {
                completed(nil, "There were an error")
                 return
             }

             guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                 completed(nil, "There were an error in the response")
                 return
             }

             guard let data = data else{
                 completed(nil, "No data was returned")
                 return
             }

             completed(data, nil)
             return
         }

         task.resume()
    }


}
