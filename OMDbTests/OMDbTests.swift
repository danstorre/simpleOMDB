//
//  OMDbTests.swift
//  OMDbTests
//
//  Created by Daniel Torres on 4/4/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import XCTest
@testable import OMDb

class OMDbTests: XCTestCase {

    var json: Data?
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        if let path = Bundle.main.path(forResource: "sampleMedia", ofType: "json") {
            do {
                json = try Data(contentsOf: URL(fileURLWithPath: path),
                                options: .mappedIfSafe)
            } catch {
                fatalError("error reading sampleMedia.json file")
            }
        }
    }
    
    override func tearDown() {
        json = nil
    }
    
    func testExample() {
        let mediaArray = OMBDB_API.parseListMediaData(json!)!
        XCTAssertEqual(mediaArray[0].name, "Money Heist")
        XCTAssertEqual(mediaArray[0].year, "2017–")
        XCTAssertEqual(mediaArray[0].type, MediaType.series)
        XCTAssertEqual(mediaArray[0].poster, "https://m.media-amazon.com/images/M/MV5BOTI5OTI0YTQtM2UxNC00MjMxLWE5NjQtZWIzNGRhZTlmMjdhXkEyXkFqcGdeQXVyMTkxNjUyNQ@@._V1_SX300.jpg")
    }

}
