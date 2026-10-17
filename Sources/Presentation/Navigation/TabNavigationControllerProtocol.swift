//
//  TabNavigationControllerProtocol.swift
//
//
//  Created by Caio Mello on 17.10.26.
//

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
