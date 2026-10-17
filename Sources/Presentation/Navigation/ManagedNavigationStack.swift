//
//  ManagedNavigationStack.swift
//  Watchlist
//
//  Created by Caio Mello on 24.08.26.
//  Copyright © 2026 Caio Mello. All rights reserved.
//

import SwiftUI

/// The navigation stack an app builds every screen hierarchy in, tabs and sheets alike.
/// It resolves each pushed route through `screen`, gives every screen the route type's
/// `backgroundColor` and `tintColor`, and places the path in the environment at `pathKey`,
/// so any screen in the stack can push with `navigate(to:)`.
public struct ManagedNavigationStack<Route: NavigationRouteProtocol, Content: View>: View {
    private let path: Binding<[Route]>
    private let content: Content

    public init(path: Binding<[Route]>, @ViewBuilder content: () -> Content) {
        self.path = path
        self.content = content()
    }

    public var body: some View {
        NavigationStack(path: path) {
            content
                .navigationDestination(for: Route.self) {
                    $0.screen
                        .scrollContentBackground(.hidden)
                        .background(Route.backgroundColor.ignoresSafeArea())
                        .tint(Route.tintColor)
                        .environment(Route.pathKey, path)
                }
                .scrollContentBackground(.hidden)
                .background(Route.backgroundColor.ignoresSafeArea())
                .tint(Route.tintColor)
                .environment(Route.pathKey, path)
        }
    }
}
