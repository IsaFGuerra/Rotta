//
//  RottaApp.swift
//  Rotta
//

import SwiftUI

@main
struct RottaApp: App {
    init() {
        Task {
            print("🚀 Verificando/Iniciando seed do CloudKit...")
            let cloudKitSeed = CloudKitSeed(database: Database.shared)

            await cloudKitSeed.seedDatabase()
        }
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .preferredColorScheme(.dark)
        }
    }
}
