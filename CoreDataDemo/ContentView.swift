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
    // nice thing about doing it this way is that your data is ready as soon as the view loads and it's always updated
    @FetchRequest(sortDescriptors: []) var people: FetchedResults<Person>
    // you can alternatively - manually call the FetchRequest
    
    
    var body: some View {
        
        VStack {
            Button(action: addItem) {
                Label("Add Item", systemImage: "plus")
            }
            List {
                ForEach(people) { person in
                    Text(person.name ?? "no name")
                        .onTapGesture {
                            //person.name = "Joe"
                            //try! viewContext.save()
                            // this updates coreData AND re-renders the UI component
                            
                            // or we might want to DELETE
                            viewContext.delete(person)
                            // TODO:  is save() really necessary?
                            try! viewContext.save()
                        }
                        
                }
            }
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
    }

    private func addItem() {
        
        // we are creating a new person object and specifying that we intend to save it in core Data
        let p = Person(context: viewContext)
        p.age = 20
        p.name = "Tom"
        
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
