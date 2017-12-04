//
//  MovieDetails+CoreDataProperties.swift
//  MovieCatalog
//
//  Created by vlaghane on 12/4/17.
//  Copyright © 2017 Drones. All rights reserved.
//
//

import Foundation
import CoreData


extension MovieDetails {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MovieDetails> {
        return NSFetchRequest<MovieDetails>(entityName: "MovieDetails")
    }

    @NSManaged public var city: String?
    @NSManaged public var id: String?
    @NSManaged public var latitude: Float
    @NSManaged public var location: String?
    @NSManaged public var longitude: Float
    @NSManaged public var movieName: String?
    @NSManaged public var state: String?
    @NSManaged public var yearRelease: Int16
    @NSManaged public var zip: String?

}
