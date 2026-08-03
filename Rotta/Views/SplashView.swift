//
//  SplashView.swift
//  Rotta
//

import Lottie
import SwiftUI

struct SplashView: View {
    let onFinish: () -> Void

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            LottieAnimationRepresentable(
                name: "Rotta",
                fromProgress: 0.0,
                toProgress: 0.9,
                onFinish: onFinish
            )
            .ignoresSafeArea()
        }
    }
}

/// Envolve `LottieAnimationView` porque precisamos do callback de conclusão
/// com faixa de progresso específica (0 → 0.9), como no `SplashScreenVC`.
private struct LottieAnimationRepresentable: UIViewRepresentable {
    let name: String
    let fromProgress: AnimationProgressTime
    let toProgress: AnimationProgressTime
    let onFinish: () -> Void

    func makeUIView(context: Context) -> UIView {
        let container = UIView()
        container.backgroundColor = .black

        let animationView = LottieAnimationView(name: name)
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .playOnce
        animationView.animationSpeed = 1.0
        animationView.translatesAutoresizingMaskIntoConstraints = false

        container.addSubview(animationView)
        NSLayoutConstraint.activate([
            animationView.topAnchor.constraint(equalTo: container.topAnchor),
            animationView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            animationView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            animationView.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])

        animationView.play(
            fromProgress: fromProgress,
            toProgress: toProgress,
            loopMode: .playOnce
        ) { _ in
            onFinish()
        }

        return container
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}
