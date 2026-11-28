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

    private let onLoad: ((CGImage) -> Void)?

    @State private var loadedImage: LoadedImage?

    @Environment(\.imageURLSession) private var imageURLSession

    public init(url: URL?, onLoad: ((CGImage) -> Void)? = nil) {
        self.url = url
        self.onLoad = onLoad
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
            guard
                let url,
                loadedImage?.url != url,
                let image = try? await image(at: url, session: imageURLSession),
                !Task.isCancelled
            else { return }

            withAnimation(.easeOut(duration: 0.2)) {
                loadedImage = LoadedImage(url: url, image: image)
                onLoad?(image)
            }
        }
    }

    @concurrent
    private nonisolated func image(at url: URL, session: URLSession) async throws -> CGImage? {
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
        let (data, _) = try await session.data(for: request)

        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else { return nil }

        return CGImageSourceCreateImageAtIndex(source, 0, [kCGImageSourceShouldCacheImmediately: true] as CFDictionary)
    }
}

private struct LoadedImage {
    let url: URL
    let image: CGImage
}

extension EnvironmentValues {
    /// The session `CustomAsyncImage` loads through, and so the cache it reads.
    @Entry public var imageURLSession: URLSession = .shared
}

#Preview {
    CustomAsyncImage(url: nil)
        .aspectRatio(2 / 3, contentMode: .fit)
}
