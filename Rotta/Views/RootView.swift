//
//  RootView.swift
//  Rotta
//

import SwiftUI

/// Mostra a splash com a animação Lottie e, ao terminar, revela o app.
struct RootView: View {
    @State private var isSplashFinished = false

    var body: some View {
        Group {
            if isSplashFinished {
                NavigationStack {
                    MainTabView()
                }
                .tint(.rottaYellow)
            } else {
                SplashView { isSplashFinished = true }
            }
        }
    }
}
