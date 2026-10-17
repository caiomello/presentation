//
//  NavigationRouteProtocol.swift
//
//
//  Created by Caio Mello on 17.10.26.
//

import SwiftUI

public protocol NavigationRouteProtocol: Hashable {
    associatedtype Screen: View

    @MainActor @ViewBuilder var screen: Screen { get }

    static var pathKey: WritableKeyPath<EnvironmentValues, Binding<[Self]>> { get }

    static var backgroundColor: Color { get }

    static var tintColor: Color { get }
}

extension Binding where Value: RangeReplaceableCollection, Value.Element: NavigationRouteProtocol {
    public func navigate(to route: Value.Element) {
        wrappedValue.append(route)
    }
}
