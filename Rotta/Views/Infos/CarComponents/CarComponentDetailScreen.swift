//
//  CarComponentDetailScreen.swift
//  Rotta
//

import AudioToolbox
import SwiftUI
import UIKit

struct CarComponentDetailScreen: View {
    let component: ComponentModel

    @State private var isVibrating = false
    @State private var buttonShake: CGFloat = 0
    @State private var imageShake: CGFloat = 0
    @State private var buttonScale: CGFloat = 1
    @State private var vibrationTask: Task<Void, Never>?

    var body: some View {
        DetailScaffold {
            backgroundImage
        } content: {
            componentImage
                .frame(width: 192, height: 156)
                .offset(y: imageShake)

            Text(component.name ?? "")
                .font(Fonts.title1)
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)

            vibrateButton

            DetailTextBox(background: .fillsTextBox) {
                Text(component.details ?? "")
                    .font(Fonts.bodyRegular)
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 4)
                    .padding(.vertical, 4)
            }

            DetailTextBox(background: .fillsTextBox) {
                VStack(spacing: 8) {
                    Text("Caracteristicas")
                        .font(Fonts.subtitle1)

                    Text(component.property ?? "")
                        .font(Fonts.bodyRegular)
                }
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 4)
                .padding(.vertical, 4)
            }

            ExploreCarousel(title: "Explore outros componentes")
        }
        .navigationTitle("Detalhes")
        .onDisappear(perform: stopVibrating)
    }

    // MARK: - Botão de vibração

    private var vibrateButton: some View {
        Text("Sinta a vibração do motor")
            .font(Fonts.bodyRegular)
            .foregroundStyle(.black)
            .frame(maxWidth: .infinity)
            .frame(height: 48)
            .background(
                Color.rottaYellow.opacity(isVibrating ? 0.8 : 1.0),
                in: .rect(cornerRadius: 24)
            )
            .scaleEffect(buttonScale)
            .offset(x: buttonShake)
            .padding(.horizontal, 20)
            .contentShape(.rect)
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in
                        guard !isVibrating else { return }
                        startVibrating()
                    }
                    .onEnded { _ in stopVibrating() }
            )
    }

    private func startVibrating() {
        isVibrating = true

        withAnimation(.linear(duration: 0.05).repeatForever(autoreverses: true)) {
            buttonShake = 3
        }
        withAnimation(.linear(duration: 0.05).repeatForever(autoreverses: true)) {
            imageShake = 2
        }
        withAnimation(.easeInOut(duration: 0.15).repeatForever(autoreverses: true)) {
            buttonScale = 0.98
        }

        vibrationTask = Task { @MainActor in
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.prepare()

            while !Task.isCancelled {
                generator.impactOccurred()
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                try? await Task.sleep(for: .milliseconds(150))
            }
        }
    }

    private func stopVibrating() {
        vibrationTask?.cancel()
        vibrationTask = nil

        guard isVibrating else { return }
        isVibrating = false

        withAnimation(.linear(duration: 0.1)) {
            buttonShake = 0
            imageShake = 0
            buttonScale = 1
        }
    }

    // MARK: - Imagens

    @ViewBuilder
    private var backgroundImage: some View {
        if let name = component.image, let image = UIImage(named: name) {
            Image(uiImage: image).resizable().scaledToFill()
        } else {
            Color.clear
        }
    }

    @ViewBuilder
    private var componentImage: some View {
        if let name = component.image, let image = UIImage(named: name) {
            Image(uiImage: image).resizable().scaledToFit()
        } else {
            Color.clear
        }
    }
}
