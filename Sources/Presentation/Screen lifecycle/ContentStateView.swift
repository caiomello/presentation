//
//  ContentStateView.swift
//  Watchlist
//
//  Created by Caio Mello on 22.08.26.
//  Copyright © 2026 Caio Mello. All rights reserved.
//

import SwiftUI

/// What a screen is currently showing.
///
/// Three rules hold across every screen:
///
/// - Empty results always map to `.empty`. Controllers never emit `.loaded([])`, so a list
///   cannot silently render blank.
/// - The controller names the empty state; its view supplies the copy and the symbol. Each
///   screen nests its own `EmptyState` enum, so the view switches over it exhaustively.
///   Screens that can never be empty use `Never`, which makes `.empty` unconstructible.
/// - Cache-first reads never regress to `.error`. With cached content on screen a failed update
///   is silent and the state stays `.loaded(cached)`; `.error` is reachable only when there is
///   nothing to display.
public enum ContentState<Content, EmptyState> {
    case loading
    case loaded(Content)
    case empty(EmptyState)
    case error
}

/// The one place `ContentState` is rendered.
public struct ContentStateView<Controller: ScreenController, LoadedContent: View, EmptyContent: View>: View {
    private let controller: Controller
    private let loaded: (Controller.Content) -> LoadedContent

    private let empty: ((Controller.EmptyState) -> EmptyContent)?

    public init(
        controller: Controller,
        @ViewBuilder loaded: @escaping (Controller.Content) -> LoadedContent,
        @ViewBuilder empty: @escaping (Controller.EmptyState) -> EmptyContent
    ) {
        self.controller = controller
        self.loaded = loaded
        self.empty = empty
    }

    public var body: some View {
        content
            .alert("Something Went Wrong", isPresented: Bindable(controller).actionFailed) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("Please try again.")
            }
    }

    @ViewBuilder private var content: some View {
        switch controller.content {
        case .loading:
            ProgressView()

        case .loaded(let value):
            loaded(value)

        case .empty(let state):
            if let empty {
                empty(state)
            }

        case .error:
            ContentUnavailableView {
                Label("Something Went Wrong", systemImage: "exclamationmark.circle")
            } description: {
                Text("Please try again.")
            } actions: {
                Button("Retry") {
                    Task { await controller.retry() }
                }
            }
        }
    }
}

extension ContentStateView where Controller.EmptyState == Never, EmptyContent == EmptyView {
    public init(controller: Controller, @ViewBuilder loaded: @escaping (Controller.Content) -> LoadedContent) {
        self.controller = controller
        self.loaded = loaded
        self.empty = nil
    }
}
