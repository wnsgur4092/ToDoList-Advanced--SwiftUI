//
//  ToDoList_Advanced__SwiftUIApp.swift
//  ToDoList(Advanced)-SwiftUI
//
//  Created by JunHyuk Lim on 20/9/2022.
//

import SwiftUI

@main
struct ToDoList_Advanced__SwiftUIApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
