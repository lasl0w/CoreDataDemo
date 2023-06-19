//
//  ContentView.swift
//  CoreDataDemo
//
//  Created by tom montgomery on 6/10/23.
//

import SwiftUI
import CoreData

struct ContentView: View {
    // uses the keypath init instead of the regular EO
    // use this line in any subView and we've got access to the
    @Environment(\.managedObjectContext) private var viewContext

    // To fetch all the data of a given type, use the fetch request wrapper
//    @FetchRequest(
//        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
//        animation: .default)
//    private var items: FetchedResults<Item>

    // OUR OWN FETCHRequest - property wrapper
    // even if you don't care about the sorting, still need an empty array
    // nice thing about doing it this way is that your data is ready as soon as the view loads and it's always updated.  FETCH - basic, bound to var
    //@FetchRequest(sortDescriptors: []) var people: FetchedResults<Person>
    
    // FETCH - with sort by age.  still nice as it's bount to the people var
    //@FetchRequest(sortDescriptors: [NSSortDescriptor(key: "age", ascending: true)]) var people: FetchedResults<Person>
    // you can alternatively - manually call the FetchRequest
    
    // FETCH - with sort & predicate.  predicate allows a filter query syntax
//    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "age", ascending: true)],
//                  predicate: NSPredicate(format: "name contains 'Joe'"))
//    var people: FetchedResults<Person>
    
    // FETCH - w/dynamicpredicate filtering
    @State var people = [Person]()
    // initially not filtered.  empty
    @State var filterByText = ""
    
    // FAMILY fetch wrapper
    @FetchRequest(sortDescriptors: []) var families: FetchedResults<Family>
    
    var body: some View {
        
        VStack {
            Button(action: addItem) {
                Label("Add Item", systemImage: "plus")
            }
            
//            TextField("Filter Text", text: $filterByText) { _ in
//                // Fetch new data
//                //trailing closure here executes on commit/enter
//                fetchData()
//            }
            //TextField("Filter Text", text: $filterByText)
//                .border(Color.black, width: 1)
//                .padding()
            
            
            
//            List {
//                ForEach(people) { person in
//                    Text("\(person.name ?? "no name"), age: \(String(person.age) )")
//                        .onTapGesture {
//                            person.name = "Joe"
//                            try! viewContext.save()
//                            // this updates coreData AND re-renders the UI component
//
//                            // or we might want to DELETE
//                            //viewContext.delete(person)
//                            // TODO:  is save() really necessary with delete()?
//                            //try! viewContext.save()
//                        }
//
//                }
//            }
            List {
                ForEach(families) { family in
                    Text("\(family.name ?? ""), member count: \(family.members!.count)")
                    
                }
            }
        }
        //.onChange(of: filterByText, perform: { value in
            // modifier on the VStack - when filterbyText changes, run fetch data - every key stroke
        //    fetchData()
        }
        

        

        
//        NavigationView {
////            List {
////                ForEach(items) { item in
////                    NavigationLink {
////                        Text("Item at \(item.timestamp!, formatter: itemFormatter)")
////                    } label: {
////                        Text(item.timestamp!, formatter: itemFormatter)
////                    }
////                }
////                .onDelete(perform: deleteItems)
////            }
////            .toolbar {
////                ToolbarItem(placement: .navigationBarTrailing) {
////                    EditButton()
////                }
////                ToolbarItem {
////                    Button(action: addItem) {
////                        Label("Add Item", systemImage: "plus")
////                    }
////                }
////            }
//            Text("Select an item")
//        }
    
    
    func FamilyTest() {
        
        // create a new Family record in our DB (in our viewContext)
        let f = Family(context: viewContext)
        // set the Family name
        f.name = "Collins Family"
        
        // create a new Person in our DB
        let p = Person(context: viewContext)
        // set the family relationship
        //p.family = f
        
        // alternate - set the family relationship using the function
        f.addToMembers(p)
        
        // save
        try! viewContext.save()
    }
    
    func fetchData() {
        
        // Create fetch request
        // goes back to our 'extension' class.  might need to cast it 'as'.  error - ambiguous use of fetchRequest.  may just change the function name - personFetchRequest
        //let request = Person.fetchRequest()
        
        // Instead of fetching people, now we can fetch family
        // If AMBIGUOUS error, go to extension and rename the fetch request,  ha! above ^^^
        let request = Family.familyFetchRequest()
        
        // set sort descriptors and predicates
        //request.sortDescriptors = [NSSortDescriptor(key: "age", ascending: true)]
        // no need for single quotes when using '%@'
        //request.predicate = NSPredicate(format: "name contains %@", filterByText)
        
        // For FAMILY, no sortDescriptors and no predicates in this example
        request.sortDescriptors = []
        
        // Execute the fetch - default is happening in a background thread
        // need to wrap it in DispatchQueue to force it to the main thread
        
        DispatchQueue.main.async {
            do {
                let results = try viewContext.fetch(request)
                // Update the state property
                //self.people = results
            }
            catch {
                print(error.localizedDescription)
            }
        }
        
    }

    private func addItem() {
        
        let family = Family(context: viewContext)
        family.name = String("Family #\(Int.random(in: 0...20))")
        
        let numberOfMembers = Int.random(in: 1...5)
        
        for _ in 0...numberOfMembers {
            
            let p = Person(context: viewContext)
            p.age = Int64.random(in: 0...20)
            p.name = "Tom"
            p.family = family
        }
        
        // we are creating a new person object and specifying that we intend to save it in core Data

        
        do {
            // Save to core data!
            try viewContext.save()
        }
        catch {
            // error with saving
        }
        
        
//        withAnimation {
//            let newItem = Item(context: viewContext)
//            newItem.timestamp = Date()
//
//            do {
//                try viewContext.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nsError = error as NSError
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//            }
//        }
    }

//    private func deleteItems(offsets: IndexSet) {
//        withAnimation {
//            offsets.map { items[$0] }.forEach(viewContext.delete)
//
//            do {
//                try viewContext.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nsError = error as NSError
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//            }
//        }
//    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
