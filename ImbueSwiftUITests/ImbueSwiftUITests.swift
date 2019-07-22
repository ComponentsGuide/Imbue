//
//  ImbueSwiftUITests.swift
//  ImbueSwiftUITests
//
//  Created by Patrick Smith on 21/6/19.
//  Copyright © 2019 Royal Icing. All rights reserved.
//

import XCTest
@testable import ImbueSwiftUI

func Then(_ description: String, _ block: () -> ()) {
    XCTContext.runActivity(named: "Then \(description)") { _ in
        block()
    }
}

class AdjustableColorInstanceTests: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testWhenNoAdjustments() {
        let a = AdjustableColorInstance(state: .init(inputColor: ColorValue.sRGB(.init(r: 0.25, g: 0.75, b: 0.5))))
        
        Then("output color is same as input color") {
            XCTAssertEqual(a.outputColor, ColorValue.sRGB(.init(r: 0.25, g: 0.75, b: 0.5)))
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
