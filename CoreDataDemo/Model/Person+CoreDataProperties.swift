//
//  Person+CoreDataProperties.swift
//  CoreDataDemo
//
//  Created by tom montgomery on 6/10/23.
//
//

import Foundation
import CoreData


extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged public var name: String?
    @NSManaged public var gender: String?
    @NSManaged public var age: Int64
    @NSManaged public var array: NSObject?

}

extension Person : Identifiable {

}