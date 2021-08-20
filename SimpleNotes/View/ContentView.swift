//
//  ContentView.swift
//  SimpleNotes
//
//  Created by Indra Kurniawan on 17/08/21.
//

import SwiftUI
import CoreData
import Combine

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @State var activateNavigationLink = false
    
//    @FetchRequest(
//        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
//        animation: .default)
    
    
    //private var items: FetchedResults<Item>
    @State var items = [Item]()
    @State private var refreshID = UUID()   // can be actually anything, but unique

    
    //private var items = ["tes", "tes", "tes"]
    
    var body: some View {
        NavigationView{
            VStack{
                List(items, id: \.id) {item in
                        NavigationLink(
                            destination: EditorView(id: item.objectID, title: item.title!, attributedNote: item.note!).onDisappear(perform: {self.refreshID = UUID()}),
                            label: {
                                CardView(item: item)
                            })
                }
                .id(refreshID)
                
                .toolbar {
                    ToolbarItem {
                        Button("Add", action: addItem)
                    }
                }
                
                NavigationLink(
                    destination: EditorView(id: nil, title: nil, attributedNote: nil).onDisappear(perform: {self.refreshID = UUID()}),
                    isActive: $activateNavigationLink
                ){
                    EmptyView()
                }
            }
            
        }
        .onReceive(Just(refreshID)) { newID in
            fetch()
        }
        
    }
    
    private func fetch(){
        var fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Item")
        do {
            self.items = try viewContext.fetch(fetchRequest) as [Item]
        }catch let error as NSError {
            print("Could not fetch \(error)")
        }
    }
    
    private func addItem() {
        activateNavigationLink = true
    }
    
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct CardView: View {
    @ObservedObject var item: Item
    
    var body: some View {
        Text(item.title!)
    }
        
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
