//
//  ManagedSheet.swift
//  Watchlist
//
//  Created by Caio Mello on 2026-09-08.
//  Copyright © 2026 Caio Mello. All rights reserved.
//

import SwiftUI

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
