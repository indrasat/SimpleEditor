//
//  SimpleNotesApp.swift
//  SimpleNotes
//
//  Created by Indra Kurniawan on 17/08/21.
//

import SwiftUI

@main
struct SimpleNotesApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
