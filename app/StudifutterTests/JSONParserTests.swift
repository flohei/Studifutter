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
        XCTAssertEqual(cafeteria?.description, "Mensa am Hauptcampus der TH Nürnberg")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
