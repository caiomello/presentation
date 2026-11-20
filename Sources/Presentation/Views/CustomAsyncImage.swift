//
//  CustomAsyncImage.swift
//  Watchlist
//
//  Created by Caio Mello on 22.08.26.
//  Copyright © 2026 Caio Mello. All rights reserved.
//

import ImageIO
import SwiftUI

public struct CustomAsyncImage: View {
    public let url: URL?

    @State private var loadedImage: LoadedImage?

    public init(url: URL?) {
        self.url = url
    }

    public var body: some View {
        Group {
            if let loadedImage, loadedImage.url == url {
                Image(decorative: loadedImage.image, scale: 1)
                    .resizable()
                    .scaledToFill()
            } else {
                Rectangle()
                    .fill(.fill.tertiary)
            }
        }
        // Not AsyncImage: it never retries a load cancelled by a disappearance, and SwiftUI hides and shows a split
        // view's new root while it pops. `.task` restarts with every appearance, so a cut-short load runs again.
        .task(id: url) {
            guard let url, loadedImage?.url != url, let image = try? await image(at: url) else { return }

            withAnimation(.easeOut(duration: 0.2)) {
                loadedImage = LoadedImage(url: url, image: image)
            }
        }
    }

    @concurrent
    private nonisolated func image(at url: URL) async throws -> CGImage? {
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
        let (data, _) = try await URLSession.shared.data(for: request)

        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else { return nil }

        return CGImageSourceCreateImageAtIndex(source, 0, [kCGImageSourceShouldCacheImmediately: true] as CFDictionary)
    }
}

private struct LoadedImage {
    let url: URL
    let image: CGImage
}

#Preview {
    CustomAsyncImage(url: nil)
        .aspectRatio(2 / 3, contentMode: .fit)
}
