//
//  AddTodoView.swift
//  ToDoList(Advanced)-SwiftUI
//
//  Created by JunHyuk Lim on 20/9/2022.
//

import SwiftUI

struct AddTodoView: View {
    //MARK: - PROPERTIES
    @Environment(\.dismiss) var dismiss
    
    @Environment(\.managedObjectContext) private var viewContext
    @State private var name : String = ""
    @State private var priority : String = "Normal"
    
    let priorities = ["High", "Normal", "Low"]
    
    @State private var errorShowing : Bool = false
    @State private var errorTitle : String = ""
    @State private var errorMessage : String = ""
    
    //MARK: - FUNCTION
    private func addItem() {
        withAnimation {
            if self.name != "" {
                let todo = Item(context: viewContext)
                todo.name = name
                todo.priority = priority
                todo.id = UUID()
                
                do{
                    try viewContext.save()
                    print("New todo : \(todo.name ?? ""), Priority : \(todo.priority ?? "")")
                } catch {
                    print(error)
                }
                self.dismiss()
                
            } else {
                self.errorShowing = true
                self.errorTitle = "Invalid Name"
                self.errorMessage = "Make sure to enter something for\nthe new todo item."
            }
            
        }
    }
    
    //MARK: - BODY
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    //MARK: - TODO NAME
                    TextField("Todo", text: $name)
                    
                    //MARK: - TODO PRIORITY
                    Picker("Priority", selection: $priority) {
                        ForEach(priorities, id: \.self  ) {
                            Text($0)
                        }
                    } //: PICKER
                    .pickerStyle(.segmented)
                    
                    //MARK: - SAVE BUTTON
                    Button {
                        addItem()
                    } label: {
                        Text("Save")
                    } //: SAVE BUTTON
                    
                } //: FORM
                
                
            } //: VSTACK
            .navigationTitle("New Todo")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                }
                
            }
            .alert(isPresented: $errorShowing) {
                Alert(title: Text(errorTitle), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }
        } //: NAVIGATION
    }
}

//MARK: - PREVIEW
struct AddTodoView_Previews: PreviewProvider {
    static var previews: some View {
        AddTodoView()
    }
}
