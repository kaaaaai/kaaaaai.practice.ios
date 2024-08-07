//
//  CodeFragmentationUITests_Swift.swift
//  CodeFragmentationUITests-Swift
//
//  Created by Kaaaaai on 2021/7/2.
//  Copyright © 2021 Kaaaaai. All rights reserved.
//

import XCTest

class CodeFragmentationUITests_Swift: XCTestCase {

    static var launched = false
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    override class func setUp() {
        super.setUp()
        
        let app = XCUIApplication()
        if !CodeFragmentationUITests_Swift.launched {
            
            app.launch()
            CodeFragmentationUITests_Swift.launched  = true
        }
        

        app.scrollViews.otherElements.staticTexts["动画"].tap()
        
        app.staticTexts["加载动画"].tap()
        app.staticTexts["加载动画"].tap()
        
        app.windows.firstMatch.swipeDown()
    }
    
    func testExample() throws {
        // UI tests must launch the application that they test.
        
//        let app = XCUIApplication()
//        let elementsQuery = app.scrollViews.otherElements
//        elementsQuery/*@START_MENU_TOKEN@*/.staticTexts["动画"]/*[[".buttons[\"动画\"].staticTexts[\"动画\"]",".staticTexts[\"动画\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
//        app.windows.children(matching: .other).element.children(matching: .other).element(boundBy: 1).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.swipeDown()
//        elementsQuery.buttons["权限封装"].tap()
//
//        let staticText = app.staticTexts["权限封装"]
//        staticText.tap()
//        staticText.swipeDown()
//        elementsQuery/*@START_MENU_TOKEN@*/.staticTexts["RxSwift"]/*[[".buttons[\"RxSwift\"].staticTexts[\"RxSwift\"]",".staticTexts[\"RxSwift\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
//        app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element(boundBy: 1).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.swipeDown()

        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
    }

    override class func tearDown() {
        
    }
    
    func testLaunchPerformance() throws {
//        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            
                                                // This measures how long it takes to launch your application.
//            measure(metrics: [XCTApplicationLaunchMetric()]) {
//                XCUIApplication().launch()
//            }
//        }
    }
}
