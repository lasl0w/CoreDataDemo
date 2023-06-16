//
//  GetCoreDataRef.swift
//  CoreDataDemo
//
//  Created by tom montgomery on 6/13/23.
//

import Foundation

// possible instantiation but not the right way
let a = PersistenceController()
let z = a.container

// Best practice is to use the shared resource - the static var
// so we don't have different instances of the DB
let b = PersistenceController.shared

// we really want the VIEWCONTEXT - it's our CRUD
let myDB = b.container.viewContext
// CORE DATA BEST PRACTICE IS TO USE A SINGLETON
// RISK:  a singleton is a global variable effectively.   potentially hard to debug things
