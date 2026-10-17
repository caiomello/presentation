//
//  ManagedSheet.swift
//  Watchlist
//
//  Created by Caio Mello on 2026-09-08.
//  Copyright © 2026 Caio Mello. All rights reserved.
//

import SwiftUI

/// A sheet that hosts its content in its own `ManagedNavigationStack`.
/// It owns the stack's path, so the path dies with the sheet, and supplies the close button.
public struct ManagedSheet<Route: NavigationRouteProtocol, Content: View>: View {
    @Environment(\.dismiss) private var dismiss

    @State private var path: [Route] = []

    private let content: Content

    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    public var body: some View {
        ManagedNavigationStack(path: $path) {
            content
                .toolbar {
                    ToolbarItem {
                        Button(role: .close) {
                            dismiss()
                        }
                    }
                }
        }
    }
}
