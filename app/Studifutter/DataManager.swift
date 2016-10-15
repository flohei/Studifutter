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
 - Add caching
 
 */

typealias JSON = [String: AnyObject]

enum RestAPIError: Error {
    case DownloadError
    case JSONParsingError
}

struct RestAPIRequest {
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
    
    func getCafeterias(cafeterias: @escaping (([Cafeteria]) -> Void)) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        var results: [Cafeteria] = []
        
        for key in CafeteriaKey.allValues {
            DispatchQueue.global(qos: .background).async {
                self.getCafeteria(key: key, newCafeteria: { cafeteria in
                    DispatchQueue.main.async {
                        results.append(cafeteria)
                        cafeterias(results)
                    }
                })
            }
        }
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    func getCafeteria(key: CafeteriaKey, newCafeteria: @escaping ((Cafeteria) -> Void)) {
        let request = RestAPIRequest()
        var resultJSON: JSON? = nil
        
        request.loadData(cafeteria: key) { (jsonData) in
            guard let data = jsonData else { return }
            
            do {
                resultJSON = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? JSON
            } catch {
                print(error.localizedDescription)
            }
            
            let parser = JSONParser()
            guard let cafeteria = parser.parseCafeteria(jsonObject: resultJSON!) else { return }
            newCafeteria(cafeteria)
        }
    }
}
