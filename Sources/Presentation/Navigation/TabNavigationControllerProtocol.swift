//
//  TabNavigationControllerProtocol.swift
//
//
//  Created by Caio Mello on 17.10.26.
//

/// The tab selection authority of an app's root.
/// `selectTab(_:)` switches tabs, and reselecting the current tab pops it to its root
/// through `popToRoot(_:)`.
@MainActor
public protocol TabNavigationControllerProtocol: AnyObject {
    associatedtype Tab: Hashable

    var selectedTab: Tab { get set }

    func popToRoot(_ tab: Tab)
}

extension TabNavigationControllerProtocol {
    public func selectTab(_ tab: Tab) {
        if tab == selectedTab { popToRoot(tab) }
        selectedTab = tab
    }
}
