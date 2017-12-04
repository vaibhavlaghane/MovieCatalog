//
//  CoreDataManager.swift
//  MovieCatalog
//
//  Created by vlaghane on 12/3/17.
//  Copyright © 2017 Drones. All rights reserved.
//

import UIKit
import CoreData

let coreDataModel = "MovieCatalogCoreData"
let sqliteFile = "MovieCatalogCoreData"
let movieEntity = "MovieDetails"

class   MovieCatalog: NSObject {
    
    public var city: String? = ""
    public var id: String? = ""
    public var latitude: Float = 0.0
    public var location: String? = ""
    public var longitude: Float = 0.0
    public var movieName: String?
    public var state: String? = ""
    public var yearRelease: Int16 = 0
    public var zip: String? = ""
    
}

class CoreDataManager: NSObject {

    static let sharedInstance = CoreDataManager()

    @objc func updateCoreData( inpData:Array<Any>){
        
        if (  inpData.count == 0) { return }
        
        for (_, element ) in inpData.enumerated() {
            
            let movie = MovieCatalog()
            let catalogDetails = element  as! Array<Any>
            let location = catalogDetails[10] as? String
            
            if let id = catalogDetails[1] as? String, let movieName = catalogDetails[8] as? String
            {
                movie.id = id
                movie.movieName = movieName
                movie.location = location ?? ""
                saveEntity(movie: movie)
            }
        }
        
        
        
        saveContext()
    }
    
    
    func saveEntity(movie: MovieCatalog){
        
        let data = fetchData(movieID: movie.id!) as! Array<MovieDetails >
        
        if data.count > 0{ 
            for (_, element) in data.enumerated() {
            persistentContainer.viewContext.delete(element)
            }
        }
        
        let context =  self.persistentContainer.viewContext
        //    Now let’s create an entity and new user records.
        let entity = NSEntityDescription.entity(forEntityName: movieEntity, in: context)
        let movieE = NSManagedObject(entity: entity!, insertInto: context)
        //    At last, we need to add some data to our newly created record for each keys using
        movieE.setValue(movie.city, forKey: "city")
        movieE.setValue(movie.id, forKey: "id")
        movieE.setValue(movie.movieName, forKey: "movieName")
        movieE.setValue(movie.state, forKey: "state")
        movieE.setValue(movie.zip, forKey: "zip")
        movieE.setValue(movie.location, forKey: "location")
         
    }
    
    func fetchData(movieName: String )->Array<Any>{
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: movieEntity)
        request.predicate = NSPredicate(format: "movieName = %@", movieName)
        request.returnsObjectsAsFaults = false
        var result = Array<Any>()
        
        do {
             result = try self.persistentContainer.viewContext.fetch(request)
            for data in result as! [NSManagedObject] {
                print(data.value(forKey: "movieName") as! String)
            }
        } catch {
            print("Failed")
        }
        return result
    }
    
    func fetchData(movieID: String )->Array<Any>{
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: movieEntity)
        request.predicate = NSPredicate(format: "id = %@", movieID)
        request.returnsObjectsAsFaults = false
        var result = Array<Any>()
        
        do {
            result = try self.persistentContainer.viewContext.fetch(request)
            for data in result as! [NSManagedObject] {
                print(data.value(forKey: "movieName") as! String)
            }
        } catch {
            print("Failed")
        }
        return result
    }
    
    func fetchDataMovies()->Array<Any>{
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: movieEntity)
        //request.predicate = NSPredicate(format: "movieName = %@", movieName)
        request.returnsObjectsAsFaults = false
        var result = Array<Any>()
        
        do {
            result = try self.persistentContainer.viewContext.fetch(request)
            for data in result as! [NSManagedObject] {
                print(data.value(forKey: "movieName") as! String)
            }
        } catch {
            print("Failed")
        }
        return result
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: coreDataModel)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    //get context
    
    func getContext()->NSManagedObjectContext{
        return persistentContainer.viewContext
    }
    
    // MARK: - Core Data Saving support
    
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
    func updateEntity(){
        var context:NSManagedObjectContext = persistentContainer.viewContext// .managedObjectContext!
        
        var en = NSEntityDescription.entity(forEntityName: movieEntity, in: context)//("ENTITIES_NAME", inManagedObjectContext: context)
        
        let batchUpdateRequest = NSBatchUpdateRequest(entity: en!)
        batchUpdateRequest.resultType = NSBatchUpdateRequestResultType.updatedObjectIDsResultType
        batchUpdateRequest.propertiesToUpdate = ["OBJECT_KEY": "NEWVALUE"]
        batchUpdateRequest.propertiesToUpdate = ["OBJECT_KEY": "NEWVALUE"]
        batchUpdateRequest.propertiesToUpdate = ["OBJECT_KEY": "NEWVALUE"]
        batchUpdateRequest.propertiesToUpdate = ["OBJECT_KEY": "NEWVALUE"]
        batchUpdateRequest.propertiesToUpdate = ["OBJECT_KEY": "NEWVALUE"]
        batchUpdateRequest.propertiesToUpdate = ["OBJECT_KEY": "NEWVALUE"]
        batchUpdateRequest.propertiesToUpdate = ["OBJECT_KEY": "NEWVALUE"]
        
        //var batchUpdateRequestError: NSError?
        //
        do {
            _ = try context.execute(batchUpdateRequest)
            
        } catch {
            print("Failed")
        }
        
        //        context.executeRequest(batchUpdateRequest, error:&batchUpdateRequestError)
        //        if let error = batchUpdateRequestError {println("error")}
        //
        
    }
    
}

