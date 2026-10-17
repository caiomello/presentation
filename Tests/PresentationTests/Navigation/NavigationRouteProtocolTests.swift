//
//  NavigationRouteProtocolTests.swift
//
//
//  Created by Caio Mello on 17.10.26.
//

import Observation
import Presentation
import SwiftUI
import Testing

private enum TestRoute: NavigationRouteProtocol {
    case first
    case second

    var screen: some View {
        EmptyView()
    }

    static var pathKey: WritableKeyPath<EnvironmentValues, Binding<[TestRoute]>> { \.testPath }

    static var backgroundColor: Color { .clear }

    static var tintColor: Color { .clear }
}

extension EnvironmentValues {
    @Entry fileprivate var testPath: Binding<[TestRoute]> = .constant([])
}

@Observable
private final class TestPathStorage {
    var routes: [TestRoute] = [.first]
}

struct NavigationRouteProtocolTests {
    @Test func navigateAppendsTheRouteToTheEndOfThePath() {
        @Bindable var storage = TestPathStorage()

        $storage.routes.navigate(to: .second)

        #expect(storage.routes == [.first, .second])
    }
}
