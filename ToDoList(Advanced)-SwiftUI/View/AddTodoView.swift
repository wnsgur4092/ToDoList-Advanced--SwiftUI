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
    func addItem() {
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
            Form {
                VStack(alignment: .leading, spacing: 10) {
                    //MARK: - TODO NAME
                    TextField("Todo", text: $name)
                        .padding()
                        .background(Color(UIColor.tertiarySystemFill))
                        .cornerRadius(9)
                        .font(.system(size: 24, weight: .bold, design: .default))
                    
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
                            .font(.system(size: 24, weight: .bold, design: .default))
                            .padding()
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(9)
                            .foregroundColor(.white)
                    } //: SAVE BUTTON
                    
                } //: VSTACK
                
                
            } //: Form
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
