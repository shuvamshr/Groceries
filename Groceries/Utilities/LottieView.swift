//
//  LottieView.swift
//  Groceries
//
//  Created by Shuvam Shrestha on 2/10/2026.
//

import Lottie
import SwiftUI

/// Plays a Lottie animation from the app bundle once, then calls `onFinished`.
/// Lottie draws into a `UIView`, so it needs a representable to reach SwiftUI.
struct LottieView: UIViewRepresentable {
    let name: String
    var speed: CGFloat = 1
    var onFinished: () -> Void = {}

    func makeUIView(context: Context) -> LottieAnimationView {
        let animationView = LottieAnimationView(name: name)
        animationView.contentMode = .scaleAspectFill
        animationView.animationSpeed = speed
        // Lottie holds playback until the view reaches a window, so starting it
        // here is fine. The flag says whether it ran to the end; either way the
        // animation is over, so `onFinished` is called for both.
        animationView.play { _ in onFinished() }
        return animationView
    }

    /// Nothing to update: it plays once and is then thrown away.
    func updateUIView(_ animationView: LottieAnimationView, context: Context) {}

    /// Without this the view takes its intrinsic size, which is the artboard
    /// the animation was drawn on (1242x2688 for the confetti) rather than the
    /// space it was offered, leaving it scaled far off-screen.
    func sizeThatFits(_ proposal: ProposedViewSize, uiView: LottieAnimationView, context: Context) -> CGSize? {
        proposal.replacingUnspecifiedDimensions()
    }
}
