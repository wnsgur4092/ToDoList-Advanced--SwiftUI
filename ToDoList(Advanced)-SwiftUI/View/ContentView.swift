//
//  ContentView.swift
//  ToDoList(Advanced)-SwiftUI
//
//  Created by JunHyuk Lim on 20/9/2022.
//

import SwiftUI
import CoreData

struct ContentView: View {
    //MARK: - PROPERTIES
    @State private var showingAddTodoView : Bool = false
    
    //MARK: - FECTHING DATA
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    //MARK: - FUNCTION
    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()

            do {
                try viewContext.save()
                
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
            
            self.showingAddTodoView.toggle()

        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {

                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    //MARK: - BODY
    var body: some View {
        NavigationView {
            List {
                ForEach(items) { item in
                        Text(item.name ?? "")
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                    .sheet(isPresented: $showingAddTodoView) {
                        AddTodoView()
                    }
                }
            }
            Text("Select an item")
        }
    }


}

//MARK: - PREVIEW
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
