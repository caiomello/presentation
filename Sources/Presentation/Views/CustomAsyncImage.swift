//
//  CustomAsyncImage.swift
//  Watchlist
//
//  Created by Caio Mello on 22.08.26.
//  Copyright © 2026 Caio Mello. All rights reserved.
//

import SwiftUI

public struct CustomAsyncImage: View {
    public let url: URL?

    public init(url: URL?) {
        self.url = url
    }

    public var body: some View {
        AsyncImage(
            request: url.map { URLRequest(url: $0, cachePolicy: .returnCacheDataElseLoad) },
            transaction: Transaction(animation: .easeOut(duration: 0.2))
        ) { phase in
            if let image = phase.image {
                image
                    .resizable()
                    .scaledToFill()
            } else {
                Rectangle()
                    .fill(.fill.tertiary)
            }
        }
    }
}

#Preview {
    CustomAsyncImage(url: nil)
        .aspectRatio(2 / 3, contentMode: .fit)
}
