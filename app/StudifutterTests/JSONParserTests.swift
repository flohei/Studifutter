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
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAddressParser() {
        
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
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
