//
//  TesteNTConsultUITests.swift
//  TesteNTConsultUITests
//
//  Created by Filipe de Souza on 12/10/21.
//

@testable import TesteNTConsult
import XCTest

class TesteNTConsultUITests: XCTestCase {

    var utils: Utils!
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        utils = Utils()
    }
    
    func testeObterEventos() throws {
        XCTAssertNoThrow(try utils.formatacaoMoeda(valor: 2341.23133))
    }
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }


}
