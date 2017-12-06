//
//  MovieCatalogTests.swift
//  MovieCatalogTests
//
//  Created by Vaibhav N Laghane on 12/2/17.
//  Copyright © 2017 Drones. All rights reserved.
//

import XCTest
@testable import MovieCatalog

class MovieCatalogTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
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
    
    func testNetworkCall(){
        
        let net = NetworkSession()
        net.dataRequest(urltoRequest: url)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(testNetUpdate),
            name: NSNotification.Name(rawValue: Constants.notificationCoreDataUpdated),
            object: nil)
        XCTAssertNotNil( net.dataArray)
    }
    
    func testNetUpdate(){
        
        print("Network called ")
    }
    
    func testLocationMap(){
        let loc = MovieLocationViewController()
        loc.locationAddress = "SF Chronicle Building (901 Mission St)"
        loc.setLocation()
        sleep(1)
        XCTAssertNotNil( loc.mapV)
        }
    
    func testCoreDataSave(){
        let movie = MovieCatalog()
        movie.id = "123232234"
        movie.movieName = "movieName"
        movie.location = "location"
        movie.yearRelease =  "2017"
        CoreDataManager.sharedInstance.saveEntity(movie: movie, context: CoreDataManager.sharedInstance.persistentContainer.viewContext)
        let resut = CoreDataManager.sharedInstance.fetchData(movieName:  movie.movieName!  , context: CoreDataManager.sharedInstance.persistentContainer.viewContext ) as! [MovieDetails]
        print(resut)
        
        XCTAssertNotNil(resut)
        XCTAssert(resut[0].movieName == movie.movieName)
        
    }
    func testCoreDataFetch(){
        let movie = MovieCatalog()
        movie.id = "ID123232234"
        movie.movieName = "terminator"
        movie.location = "location"
        movie.yearRelease =  "2017"
        CoreDataManager.sharedInstance.saveEntity(movie: movie, context: CoreDataManager.sharedInstance.persistentContainer.viewContext)
        let resut = CoreDataManager.sharedInstance.fetchData(movieName:  movie.movieName!  , context: CoreDataManager.sharedInstance.persistentContainer.viewContext ) as! [MovieDetails]
        print(resut)
        
        XCTAssertNotNil(resut)
        XCTAssert(resut[0].movieName == movie.movieName)
        XCTAssert(resut[0].id    == movie.id)
        XCTAssert(resut[0].location == movie.location)
        XCTAssert(resut[0].yearRelease == movie.yearRelease)
    }
    
    func testLoadingView(){
        
        let lv = LoadingView()
        XCTAssertNotNil(lv)
    }
    
    func testViewController(){
        let mv = MovieCatalogTableViewController()
        XCTAssertNotNil(mv)
        
    }
}
