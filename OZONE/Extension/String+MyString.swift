//
//  String+MyString.swift
//  WEATCB
//
//  Created by Kevin Baldha on 20/05/20.
//  Copyright © 2020 Eugeniuses. All rights reserved.
//

import Foundation

extension String {
    
    func convertToJsonString(object :  [String : AnyObject]) -> String {
        
        let data: NSData? = try? JSONSerialization.data(withJSONObject: object, options: JSONSerialization.WritingOptions.prettyPrinted) as NSData?
        var jsonStr: String?
        if data != nil {
            jsonStr = String(data: data! as Data, encoding: String.Encoding.utf8)
        }
        return jsonStr ?? ""
    }
    
    func convertDictToJASONString(dict : [String : AnyObject])->String{
        if let theJSONData = try? JSONSerialization.data(
            withJSONObject: dict,
            options: []) {
            let theJSONText = String(data: theJSONData,
                                     encoding: String.Encoding.utf8)
            print("JSON string = \(theJSONText!)")
            return theJSONText!
        }
        return ""
    }
}
