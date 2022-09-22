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
    @State private var animatingButton : Bool = false
    @State private var showingSettingsView : Bool = false
    //MARK: - FECTHING DATA
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    //MARK: - FUNCTION
    private func addItem() {
        self.showingAddTodoView.toggle()
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
    
    private func colorize (priority : String) -> Color {
        switch priority {
        case "High":
            return .pink
        case "Normal" :
            return .green
        case "Low" :
            return .blue
        default:
            return .gray
        }
    }
    //MARK: - BODY
    var body: some View {
        NavigationView {
            ZStack {
                List {
                    ForEach(self.items, id: \.self) { item in
                        HStack {
                            Circle()
                                .frame(width: 12, height: 12, alignment: .center)
                                .foregroundColor(self.colorize(priority: item.priority ?? "Normal"))
                            Text(item.name ?? "Unknown")
                                .fontWeight(.semibold)
                            
                            Spacer()
                            
                            Text(item.priority ?? "Unknown")
                                .font(.footnote)
                                .foregroundColor(Color(UIColor.systemGray2))
                                .padding(3)
                                .frame(minWidth: 62)
                                .overlay(Capsule().stroke(Color(UIColor.systemGray2), lineWidth: 2))
                        } //: HSTACK
                        .padding(.vertical)
                    }
                    .onDelete(perform: deleteItems)
                } //: LIST
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        EditButton()
                    }
                    ToolbarItem {
                        Button {
                            self.showingSettingsView.toggle()
                        } label: {
                            Image(systemName: "paintbrush")
                        }
                        .sheet(isPresented: $showingSettingsView) {
                            SettingsView()
                        }

                            
                        
                    }
                } //: TOOLBAR
                //MARK: - NO TODO ITEMS
                if items.count == 0 {
                    EmptyListView()
                }
            } //: ZSTACK
            //MARK: - ADD BUTTON
            .overlay(
                ZStack{
                    Group{
                        Circle()
                            .fill(Color.blue)
                            .opacity(self.animatingButton ? 0.2 : 0.1)
                            .scaleEffect(self.animatingButton ? 1 : 0.1)
                            .frame(width: 68, height: 68, alignment: .center)
                        Circle()
                            .fill(Color.blue)
                            .opacity(self.animatingButton ? 0.15 : 0.1)
                            .scaleEffect(self.animatingButton ? 1 : 0.1)
                            .frame(width: 88, height: 88, alignment: .center)
                    }
                    .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true),value: animatingButton)
                    
                    Button(action: {
                        self.showingAddTodoView.toggle()
                    }, label: {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .background(Circle().fill(Color("ColorBase")))
                            .frame(width: 48, height: 48, alignment: .center)
                    }) //: BUTTON
                    .onAppear {
                        self.animatingButton.toggle()
                    }
                    .sheet(isPresented: $showingAddTodoView) {
                        AddTodoView()
                    }
                } //: ZSTACK
                    .padding(.bottom, 15)
                    .padding(.trailing, 15)
                ,alignment: .bottomTrailing
                    
            )
            
        }
    }


}

//MARK: - PREVIEW
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
