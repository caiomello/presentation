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
/// width, with no toggle. On compact width, a selection shows the detail and going back to the
/// sidebar clears it. It gets the route type's `backgroundColor` and `tintColor`, `path` in the
/// environment at `pathKey`, and the selection at `selectionKey`, where selecting the route already
/// selected empties `path` too.
public struct ManagedNavigationSplitView<Route: NavigationRouteProtocol, Sidebar: View>: View {
    private let selection: Binding<Route?>
    private let path: Binding<[Route]>
    private let sidebar: Sidebar

    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

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
        NavigationSplitView(
            columnVisibility: .constant(.all),
            preferredCompactColumn: preferredCompactColumn
        ) {
            sidebar
                .scrollContentBackground(.hidden)
                .background(Route.backgroundColor.ignoresSafeArea())
                .tint(Route.tintColor)
                .environment(Route.pathKey, path)
                .environment(Route.selectionKey, sidebarSelection)
                .environment(\.isSidebarBesideDetail, horizontalSizeClass == .regular)
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

    private var sidebarSelection: Binding<Route?> {
        Binding(
            get: {
                selection.wrappedValue
            },
            set: { route in
                if route == selection.wrappedValue {
                    path.wrappedValue = []
                } else {
                    selection.wrappedValue = route
                }
            }
        )
    }

    private var preferredCompactColumn: Binding<NavigationSplitViewColumn> {
        Binding(
            get: {
                selection.wrappedValue == nil ? .sidebar : .detail
            },
            set: { column in
                // SwiftUI reports the sidebar on every pop in the detail stack, on any width, before it shortens
                // `path`: only a report on compact width with `path` already empty is going back to the sidebar.
                if column == .sidebar && path.wrappedValue.isEmpty && horizontalSizeClass == .compact {
                    selection.wrappedValue = nil
                }
            }
        )
    }
}

extension View {
    /// Selects `route` in the enclosing `ManagedNavigationSplitView` on regular width whenever nothing
    /// is selected. A sidebar passes its first item, or `nil` for an empty list.
    public func initialSelection<Route: NavigationRouteProtocol>(_ route: Route?) -> some View {
        modifier(InitialSelectionModifier(route: route))
    }
}

private struct InitialSelectionModifier<Route: NavigationRouteProtocol>: ViewModifier {
    let route: Route?

    @Environment(Route.selectionKey) private var selection
    @Environment(\.isSidebarBesideDetail) private var isSidebarBesideDetail

    func body(content: Content) -> some View {
        content
            .onChange(of: route, initial: true) {
                selectIfNeeded()
            }
            .onChange(of: selection.wrappedValue == nil) {
                selectIfNeeded()
            }
            .onChange(of: isSidebarBesideDetail) {
                selectIfNeeded()
            }
    }

    private func selectIfNeeded() {
        guard isSidebarBesideDetail, selection.wrappedValue == nil, let route else { return }

        selection.wrappedValue = route
    }
}

extension EnvironmentValues {
    /// The split view's own width class: the sidebar column reports compact even beside the detail.
    @Entry var isSidebarBesideDetail = false
}
