//
//  ImageViewer.swift
//  Presentation
//
//  Created by Caio Mello on 2026-11-22.
//  Copyright © 2026 Caio Mello. All rights reserved.
//

import SwiftUI

public struct ImageViewer: View {
    public let url: URL

    @State private var image: CGImage?

    @Environment(\.dismiss) private var dismiss

    public init(url: URL) {
        self.url = url
    }

    public var body: some View {
        NavigationStack {
            Group {
                if let image {
                    #if os(iOS)
                    ZoomScrollView(image: image)
                    #else
                    Image(decorative: image, scale: 1)
                        .resizable()
                        .scaledToFit()
                    #endif
                } else {
                    CustomAsyncImage(
                        url: url,
                        onLoad: { image in
                            self.image = image
                        }
                    )
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black)
            .ignoresSafeArea()
            .toolbar {
                ToolbarItem {
                    if let image {
                        ShareLink(
                            item: Image(decorative: image, scale: 1),
                            preview: SharePreview(
                                url.lastPathComponent,
                                image: Image(decorative: image, scale: 1)
                            )
                        )
                    } else {
                        Button("Share", systemImage: "square.and.arrow.up") {}
                            .disabled(true)
                    }
                }

                ToolbarItem {
                    Button(role: .close) {
                        dismiss()
                    }
                }
            }
        }
        .onChange(of: url) {
            image = nil
        }
    }
}

#if os(iOS)
private struct ZoomScrollView: UIViewRepresentable {
    let image: CGImage

    func makeUIView(context: Context) -> ImageScrollView {
        ImageScrollView(image: UIImage(cgImage: image))
    }

    func updateUIView(_ scrollView: ImageScrollView, context: Context) {}
}

private final class ImageScrollView: UIScrollView, UIScrollViewDelegate {
    private let imageView: UIImageView

    private var lastBoundsSize: CGSize = .zero

    init(image: UIImage) {
        imageView = UIImageView(image: image)

        super.init(frame: .zero)

        contentInsetAdjustmentBehavior = .never
        contentSize = imageView.bounds.size
        delegate = self
        addSubview(imageView)

        let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
        doubleTapRecognizer.numberOfTapsRequired = 2
        addGestureRecognizer(doubleTapRecognizer)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        guard bounds.size != lastBoundsSize else { return }

        lastBoundsSize = bounds.size
        resetZoomToFit()
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        centerImage()
    }

    private func resetZoomToFit() {
        let imageSize = imageView.bounds.size

        guard imageSize.width > 0, imageSize.height > 0, bounds.width > 0, bounds.height > 0 else { return }

        let fitScale = min(bounds.width / imageSize.width, bounds.height / imageSize.height)

        minimumZoomScale = fitScale
        maximumZoomScale = fitScale * 3
        zoomScale = fitScale

        centerImage()
        contentOffset = CGPoint(x: -contentInset.left, y: -contentInset.top)
    }

    private func centerImage() {
        let horizontalInset = max(0, (bounds.width - contentSize.width) / 2)
        let verticalInset = max(0, (bounds.height - contentSize.height) / 2)

        contentInset = UIEdgeInsets(
            top: verticalInset,
            left: horizontalInset,
            bottom: verticalInset,
            right: horizontalInset
        )
    }

    @objc private func handleDoubleTap(_ recognizer: UITapGestureRecognizer) {
        guard zoomScale <= minimumZoomScale else {
            setZoomScale(minimumZoomScale, animated: true)
            return
        }

        let tappedPoint = recognizer.location(in: imageView)
        let zoomedSize = CGSize(width: bounds.width / maximumZoomScale, height: bounds.height / maximumZoomScale)
        let zoomedRectangle = CGRect(
            x: tappedPoint.x - zoomedSize.width / 2,
            y: tappedPoint.y - zoomedSize.height / 2,
            width: zoomedSize.width,
            height: zoomedSize.height
        )

        zoom(to: zoomedRectangle, animated: true)
    }
}
#endif

#Preview {
    @Previewable @State var isPresented = true

    Color.clear
        .sheet(isPresented: $isPresented) {
            ImageViewer(url: URL(string: "https://lh3.googleusercontent.com/d/1smOiwTdZFy2AXrZjH64RF2n-pG4HD1FK=w2940")!)
        }
}
