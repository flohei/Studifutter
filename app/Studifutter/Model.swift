//
//  Model.swift
//  Studifutter
//
//  Created by Florian Heiber on 12.10.2016.
//  Copyright © 2016 Florian Heiber. All rights reserved.
//

import Foundation

enum CafeteriaKey: String {
    case Suedmensa = "er-suedmensa", LangemarckPlatz = "er-langemarckplatz", Baerenschanze = "nbg-baerenschanze", InselSchuett = "nbg-inselschuett", Hohfederstrasse = "nbg-hohfederstrasse", Mensateria = "nbg-mensateria-ohm", RegensburgerStrasse = "nbg-regensburger-strasse", StPaul = "nbg-st-paul", Ansbach = "ansbach", Eichstaett = "eichstaett", Ingolstadt = "ingolstadt", Triesdorf = "triesdorf"
    
    static let allValues = [Suedmensa, LangemarckPlatz, Baerenschanze, InselSchuett, Hohfederstrasse, Mensateria, RegensburgerStrasse, StPaul, Ansbach, Eichstaett, Ingolstadt, Triesdorf]
}

struct Address {
    var street: String?
    var city: String?
    var postCode: String?
    
    /// The address in string form of type "Street 123, 12345 City"
    var stringRepresentation: String {
        var result = ""
        
        // Add the street
        if street != nil {
           result = street!
        }
        
        // Add post code and city and adjust if we had a street
        if city != nil && postCode != nil {
            if result.characters.count > 0 {
                result = result + ", "
            }
            
            result = result + "\(postCode!) \(city!)"
        }
        
        return result
    }
}

struct Day {
    var date: Date?
    var meals: [Meal]?
}

struct Meal {
    var title: String?
    var date: Date?
    var prices: [Price]?
    var types: [String]?
}

struct Price {
    var value: Decimal?
    var currency: String?
    var label: String?
}

struct Cafeteria {
    enum Keys: String {
        case Description = "description",
        Title = "title",
        Address = "address",
        Days = "days"
    }
    
    var description: String?
    var title: String?
    var address: Address?
    var days: [Day]?
}
