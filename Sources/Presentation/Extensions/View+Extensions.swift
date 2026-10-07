//
//  View+Extensions.swift
//  Watchlist
//
//  Created by Caio Mello on 2026-09-11.
//  Copyright © 2026 Caio Mello. All rights reserved.
//

import SwiftUI

extension View {
    public func frame(size: CGSize, alignment: Alignment = .center) -> some View {
        frame(width: size.width, height: size.height, alignment: alignment)
    }
}
