//
//  JSONParser.swift
//  Studifutter
//
//  Created by Florian Heiber on 12.10.2016.
//  Copyright © 2016 Florian Heiber. All rights reserved.
//

import Foundation

struct JSONParser {
    func parseCafeteria(jsonObject: JSON) -> Cafeteria? {
        let meals = parseMeals(jsonObject: jsonObject["meals"] as! [JSON])
        let days = reduceMeals(meals: meals)
        let description = jsonObject["description"] as? String
        let title = jsonObject["title"] as? String
        let address = parseAddress(addressString: jsonObject["address"] as! String)
        
        return Cafeteria(description: description, title: title, address: address, days: days)
    }
    
    func reduceMeals(meals: [Meal]?) -> [Day]? {
        guard let meals = meals else { return nil }
        var days: [Day] = []
        var lastDay = meals.first?.date
        
        // TODO: We need some clever combining here
        
        return []
    }
    
    func parseMeals(jsonObject: [JSON]) -> [Meal]? {
        var mealsArray: [Meal] = []
        
        for mealJSON in jsonObject {
            print(mealJSON)
            
            // Get all the raw values
            let title = mealJSON["title"] as? String
            let types = mealJSON["types"] as? [String]
            let rawPrices = mealJSON["prices"] as? [String]
            let dateString = mealJSON["date"] as? String
            
            // Parse all the things
            var prices: [Price]? = nil
            if rawPrices != nil {
                prices = parsePrices(prices: rawPrices!)
            }
            
            // Finish meal object
            let meal = Meal(title: title, date: date(string: dateString), prices: prices, types: types)
            mealsArray.append(meal)
        }
        
        return mealsArray
    }
    
    func date(string: String?) -> Date? {
        guard let dateString = string else { return nil }
        
        let dateFormat = "YYYY-mm-dd"
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .none
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.date(from: dateString)
    }
    
    func parseAddress(addressString: String) -> Address? {
        let types: NSTextCheckingResult.CheckingType = [.address]
        let detector = try? NSDataDetector(types: types.rawValue)
        var address = Address()
        detector?.enumerateMatches(in: addressString, options: [], range: NSMakeRange(0, addressString.characters.count), using: { (result, flags, _) in
            address.street = result?.components?[NSTextCheckingStreetKey]
            address.postCode = result?.components?[NSTextCheckingZIPKey]
            address.city = result?.components?[NSTextCheckingCityKey]
        })
        
        return address
    }
    
    func parsePrices(prices: [String]) -> [Price]? {
        var pricesArray: [Price] = []
        for rawPrice in prices {
            
            let components = rawPrice.components(separatedBy: " ")
            
            let numberFormatter = NumberFormatter()
            numberFormatter.locale = Locale.current
            numberFormatter.currencySymbol = components.last!
            numberFormatter.numberStyle = .currency
            numberFormatter.currencyDecimalSeparator = ","
            
            let number = numberFormatter.number(from: rawPrice)
            print(number)
            
            // Should be two components, first the value, second the currency symbol
            let priceValue = Float(components.first!)
            let currencySymbol = components.last!
            
            // TODO: Add the label
            pricesArray.append(Price(value: priceValue, currency: currencySymbol, label: ""))
        }
        return pricesArray
    }
}
