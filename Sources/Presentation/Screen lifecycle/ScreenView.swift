//
//  ScreenView.swift
//  Watchlist
//
//  Created by Caio Mello on 30.08.26.
//  Copyright © 2026 Caio Mello. All rights reserved.
//

import SwiftUI

/// The view half of a screen pair. It supplies `body`, so no screen wires up its own lifecycle:
/// `observe()` restarts with every appearance, `load()` runs once per screen.
public protocol ScreenView: View {
    associatedtype Controller: ScreenController
    associatedtype Screen: View

    var controller: Controller { get }

    @ViewBuilder var screen: Screen { get }
}

extension ScreenView {
    public var body: some View {
        screen
            .task { await controller.observe() }
            .task { await controller.loadIfNeeded() }
    }
}
