//
//  TabNavigationControllerProtocolTests.swift
//
//
//  Created by Caio Mello on 17.10.26.
//

import Presentation
import Testing

private enum TestTab: Hashable {
    case first
    case second
}

@MainActor
private final class TestTabNavigationController: TabNavigationControllerProtocol {
    var selectedTab: TestTab = .first

    private(set) var poppedTabs: [TestTab] = []

    func popToRoot(_ tab: TestTab) {
        poppedTabs.append(tab)
    }
}

@MainActor
struct TabNavigationControllerProtocolTests {
    @Test func selectingADifferentTabSelectsItWithoutPopping() {
        let controller = TestTabNavigationController()

        controller.selectTab(.second)

        #expect(controller.selectedTab == .second)
        #expect(controller.poppedTabs.isEmpty, "Switching tabs must not pop any tab.")
    }

    @Test func selectingTheCurrentTabPopsItToRoot() {
        let controller = TestTabNavigationController()

        controller.selectTab(.first)

        #expect(controller.selectedTab == .first)
        #expect(controller.poppedTabs == [.first])
    }
}
