//
//  DataManager.swift
//  Studifutter
//
//  Created by Florian Heiber on 12.10.2016.
//  Copyright © 2016 Florian Heiber. All rights reserved.
//

import Foundation

/*
 
 Todos
 
 - Request route for restaurants
 - Throw errors
 - Add error handling
 - Add parser for the data
 - Parse data into structs
 - Add manager class that first loads the data and triggers parsing
 - Add caching
 
 */

typealias JSON = [String: AnyObject]

enum RestAPIError: Error {
    case DownloadError
    case JSONParsingError
}

class RestAPIRequest {
    let basePath = "https://api.fachschaft.in/scrapi/meals/"
    
    func loadData(cafeteria: CafeteriaKey, callback: @escaping ((Data?) -> Void)) {
        let requestURL = NSURL(string: basePath + cafeteria.rawValue + ".json")
        let task = URLSession.shared.dataTask(with: requestURL as! URL) { (data, response, error) in
            if error != nil {
                print(error?.localizedDescription)
            } else {
                if (response as! HTTPURLResponse).statusCode == 200 {
                    callback(data)
                }
            }
        }
        
        task.resume()
    }
}

class DataManager {
    static let shared = DataManager()
    
    func getCafeterias() -> [Cafeteria] {
        return []
    }
    
    func getCafeteria(key: CafeteriaKey) -> Cafeteria? {
        let request = RestAPIRequest()
        var resultJSON: JSON? = nil
        var cafeteria: Cafeteria? = nil
        
        request.loadData(cafeteria: key) { (jsonData) in
            guard let data = jsonData else { return }
            
            do {
                resultJSON = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? JSON
            } catch {
                print(error.localizedDescription)
            }
            
            let parser = JSONParser()
            cafeteria = parser.parseCafeteria(jsonObject: resultJSON!)
            print(cafeteria)
        }
        
        return cafeteria
    }
}
