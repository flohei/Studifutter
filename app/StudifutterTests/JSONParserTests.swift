//
//  JSONParserTests.swift
//  Studifutter
//
//  Created by Florian Heiber on 14.10.2016.
//  Copyright © 2016 rootof.net Heiber & Wiewel GbR. All rights reserved.
//

import XCTest
@testable import Studifutter

class JSONParserTests: XCTestCase {
    let parser = JSONParser()
    let exampleJSONFileName = "mensateria"
    var exampleJSON: JSON?
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        let bundle = Bundle(for: type(of: self))
        guard let filePath = bundle.path(forResource: exampleJSONFileName, ofType: "json") else { return }
        let fileURL = URL(fileURLWithPath: filePath)
        let data = try? Data(contentsOf: fileURL)
        exampleJSON = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! JSON
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAddressParser() {
        let addressString = "Hauptstraße 42, 12345 Bielefeld"
        
        let address = parser.parseAddress(addressString: addressString)
        XCTAssertEqual(address?.stringRepresentation, addressString, "Address strings don't match")
    }
    
    func testDateParser() {
        let dateString = "2016-10-14"
        
        let date = parser.date(string: dateString)
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .none
        dateFormatter.dateFormat = "YYYY-mm-dd"
        let compareDate = dateFormatter.date(from: dateString)
        
        XCTAssertTrue(date?.compare(compareDate!) == .orderedSame, "Dates don't match")
    }
    
    func testCafeteriaParser() {
        let cafeteria = parser.parseCafeteria(jsonObject: exampleJSON!)
        
        XCTAssertNotNil(cafeteria, "Cafeteria shouldn't be nil")
        XCTAssertEqual(cafeteria?.title, "Mensateria Ohm Nürnberg")
        XCTAssertEqual(cafeteria?.description, "Mensa am Hauptcampus der TH Nürnberg")
        
        let days = cafeteria?.days
        XCTAssertEqual(days?.count, 9)
        
        let addressString = cafeteria?.address?.stringRepresentation
        XCTAssertEqual(addressString, "Wollentorstraße 4, 90489 Nürnberg")
    }
    
    func testMealParser() {
        let cafeteria = parser.parseCafeteria(jsonObject: exampleJSON!)
        let day = cafeteria?.days?.first
        let firstMeal = day?.meals?.first
        let supposedTitle = "Schäuferle fränkische Art mit Soße Kloß Weißkrautsalat"
        let germanLocale = Locale(identifier: "de_DE")
        let supposedPrice1 = Decimal(string: "4,44", locale: germanLocale)
        let supposedPrice2 = Decimal(string: "5,44", locale: germanLocale)
        let supposedPrice3 = Decimal(string: "8,88", locale: germanLocale)
        let supposedType = "S"
        
        // Check if the meal has the same date as the day
        XCTAssertEqual(firstMeal?.date, day?.date)
        
        // Check title
        XCTAssertEqual(firstMeal?.title, supposedTitle, "Title does not match")
        
        // Check prices
        XCTAssertEqual(firstMeal?.prices?.count, 3, "There should be exactly three prices here")
        XCTAssertEqual(firstMeal?.prices?[0].value, supposedPrice1)
        XCTAssertEqual(firstMeal?.prices?[0].currency, "€", "Should be Euro")
        XCTAssertEqual(firstMeal?.prices?[1].value, supposedPrice2)
        XCTAssertEqual(firstMeal?.prices?[1].currency, "€", "Should be Euro")
        XCTAssertEqual(firstMeal?.prices?[2].value, supposedPrice3)
        XCTAssertEqual(firstMeal?.prices?[2].currency, "€", "Should be Euro")
        
        // Check symbols
        XCTAssertEqual(firstMeal?.types?.count, 1, "There should be exactly one type here")
        XCTAssertEqual(firstMeal?.types?.first, supposedType, "The only type should be S")
    }
    
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }
}
