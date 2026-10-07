//
//  ScreenControllerTests.swift
//
//
//  Created by Caio Mello on 07.10.26.
//

import Observation
import Presentation
import Testing

private struct TestError: Error {}

@MainActor
@Observable
private final class TestScreenController: ScreenController {
    var content: ContentState<String, Never> = .loading
    var actionFailed = false
    var hasLoaded = false

    private(set) var loadCount = 0

    func load() async {
        loadCount += 1
    }
}

@MainActor
struct ScreenControllerTests {
    @Test func loadIfNeededLoadsOnce() async {
        let controller = TestScreenController()

        await controller.loadIfNeeded()
        await controller.loadIfNeeded()

        #expect(controller.loadCount == 1)
        #expect(controller.hasLoaded)
    }

    @Test func loadIfNeededLoadsAgainAfterACancelledLoad() async {
        let controller = TestScreenController()

        let cancelledLoad = Task { await controller.loadIfNeeded() }
        cancelledLoad.cancel()
        await cancelledLoad.value

        #expect(controller.loadCount == 1)
        #expect(controller.hasLoaded == false, "A cancelled load must leave the screen unloaded.")

        await controller.loadIfNeeded()

        #expect(controller.loadCount == 2)
        #expect(controller.hasLoaded)
    }

    @Test func performActionSetsActionFailedOnThrow() {
        let controller = TestScreenController()

        controller.performAction { throw TestError() }

        #expect(controller.actionFailed)
    }

    @Test func performActionLeavesActionFailedUnsetOnSuccess() {
        let controller = TestScreenController()

        controller.performAction {}

        #expect(controller.actionFailed == false)
    }
}
