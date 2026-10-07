//
//  ScreenController.swift
//  Watchlist
//
//  Created by Caio Mello on 22.08.26.
//  Copyright © 2026 Caio Mello. All rights reserved.
//

import Foundation
import Observation

/// The controller owns all state and all provider calls; the view is pure presentation.
@MainActor
public protocol ScreenController: AnyObject, Observable {
    associatedtype Content

    /// The screen's own empty states — `Never` when it can't be empty.
    associatedtype EmptyState

    var content: ContentState<Content, EmptyState> { get }

    var actionFailed: Bool { get set }

    /// Set by `loadIfNeeded()`.
    var hasLoaded: Bool { get set }

    /// Long-lived: the `Observations` loop. Never returns.
    func observe() async

    /// One-shot: the initial fetch or sync. `ScreenView` calls it through `loadIfNeeded()`;
    /// call it directly to repeat the operation deliberately.
    func load() async

    func retry() async
}

extension ScreenController {
    /// `.task` restarts with every appearance, so the lifecycle entry point has to be the one
    /// that remembers. A load cut short by a disappear leaves the screen unloaded and runs again.
    public func loadIfNeeded() async {
        guard hasLoaded == false else { return }

        await load()

        hasLoaded = Task.isCancelled == false
    }

    public func observe() async {}

    public func load() async {}

    public func retry() async {}

    public var actionFailed: Bool {
        get { false }
        set { assertionFailure("\(Self.self) reported a failed action without declaring `actionFailed`") }
    }

    public func performAction(_ action: () throws -> Void) {
        do {
            try action()
        } catch {
            actionFailed = true
        }
    }
}
