//
//  TabNavigationControllerProtocol.swift
//
//
//  Created by Caio Mello on 17.10.26.
//

import SwiftUI

/// The tab selection authority of an app's root.
/// `selectTab(_:horizontalSizeClass:)` switches tabs, and reselecting the current tab pops it to
/// its root through `popToRoot(_:horizontalSizeClass:)`, which receives the size class so a split
/// tab can decide how far to pop.
@MainActor
public protocol TabNavigationControllerProtocol: AnyObject {
    associatedtype Tab: Hashable

    var selectedTab: Tab { get set }

    func popToRoot(_ tab: Tab, horizontalSizeClass: UserInterfaceSizeClass?)
}

extension TabNavigationControllerProtocol {
    public func selectTab(_ tab: Tab, horizontalSizeClass: UserInterfaceSizeClass?) {
        if tab == selectedTab { popToRoot(tab, horizontalSizeClass: horizontalSizeClass) }
        selectedTab = tab
    }
}
