//
//  ManagedNavigationSplitView.swift
//
//
//  Created by Caio Mello on 15.11.26.
//

import SwiftUI

/// The split view a tab whose root is a list that opens items builds its hierarchy in.
/// The sidebar shows the list, whose selection drives the detail column: a `ManagedNavigationStack`
/// on `path`, rooted at the selected route's screen, or a "No Selection" placeholder when nothing
/// is selected. Selecting another route empties `path`. The sidebar is always shown on regular
/// width, with no toggle. It gets the route type's `backgroundColor` and `tintColor`, and `path` in
/// the environment at `pathKey`.
public struct ManagedNavigationSplitView<Route: NavigationRouteProtocol, Sidebar: View>: View {
    private let selection: Binding<Route?>
    private let path: Binding<[Route]>
    private let sidebar: Sidebar

    public init(
        selection: Binding<Route?>,
        path: Binding<[Route]>,
        @ViewBuilder sidebar: () -> Sidebar
    ) {
        self.selection = selection
        self.path = path
        self.sidebar = sidebar()
    }

    public var body: some View {
        NavigationSplitView(columnVisibility: .constant(.all)) {
            sidebar
                .scrollContentBackground(.hidden)
                .background(Route.backgroundColor.ignoresSafeArea())
                .tint(Route.tintColor)
                .environment(Route.pathKey, path)
                .toolbar(removing: .sidebarToggle)
        } detail: {
            ManagedNavigationStack(path: path) {
                if let route = selection.wrappedValue {
                    route.screen
                        .id(route)
                } else {
                    ContentUnavailableView {
                        Text("No Selection")
                    }
                }
            }
        }
        .onChange(of: selection.wrappedValue) {
            path.wrappedValue = []
        }
    }
}
