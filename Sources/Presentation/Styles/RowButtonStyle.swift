//
//  RowButtonStyle.swift
//  Watchlist
//
//  Created by Caio Mello on 06.09.26.
//  Copyright © 2026 Caio Mello. All rights reserved.
//

import SwiftUI

public struct RowButtonStyle: ButtonStyle {
    public let highlight: Color
    public let isSelected: Bool

    public init(highlight: Color, isSelected: Bool = false) {
        self.highlight = highlight
        self.isSelected = isSelected
    }

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .contentShape(.rect)
            .background(configuration.isPressed || isSelected ? highlight : Color.clear)
            .animation(configuration.isPressed ? nil : .easeOut, value: configuration.isPressed)
    }
}
