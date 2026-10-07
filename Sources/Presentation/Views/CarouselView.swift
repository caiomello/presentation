//
//  CarouselView.swift
//  Watchlist
//
//  Created by Caio Mello on 2026-09-11.
//  Copyright © 2026 Caio Mello. All rights reserved.
//

import SwiftUI

public struct CarouselView<Content: View>: View {
    public let title: String
    public let alignment: VerticalAlignment
    public let spacing: CGFloat
    public let margin: CGFloat

    @ViewBuilder public let content: () -> Content

    public init(
        title: String,
        alignment: VerticalAlignment,
        spacing: CGFloat,
        margin: CGFloat,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.title = title
        self.alignment = alignment
        self.spacing = spacing
        self.margin = margin
        self.content = content
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.title2)
                .fontWeight(.medium)
                .padding(.horizontal, margin)

            ScrollView(.horizontal) {
                LazyHStack(alignment: alignment, spacing: spacing) {
                    content()
                }
            }
            .contentMargins(.horizontal, margin, for: .scrollContent)
            .scrollIndicators(.hidden)
        }
    }
}
