//
//  KeyValueView.swift
//  Watchlist
//
//  Created by Caio Mello on 2019-07-14.
//  Copyright © 2019 Caio Mello. All rights reserved.
//

import SwiftUI

public struct KeyValueItem: Identifiable {
    public let key: String
    public let value: String?

    public var id: String { key }

    public init(key: String, value: String?) {
        self.key = key
        self.value = value
    }
}

public struct KeyValueView: View {
    public let items: [KeyValueItem]

    public init(items: [KeyValueItem]) {
        self.items = items
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(items) { item in
                HStack(alignment: .firstTextBaseline, spacing: 8) {
                    Text(item.key)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    Text(item.value ?? "-")
                        .font(.body)

                    Spacer()
                }
            }
        }
    }
}

#Preview {
    KeyValueView(
        items: [
            KeyValueItem(key: "Seasons", value: "3"),
            KeyValueItem(key: "Episodes", value: "34"),
            KeyValueItem(key: "Status", value: "Returning Series"),
            KeyValueItem(key: "First aired", value: "August 14, 2020"),
            KeyValueItem(key: "Last aired", value: "May 31, 2023"),
            KeyValueItem(key: "Episode duration", value: "30m"),
            KeyValueItem(key: "Network", value: "Apple TV+"),
            KeyValueItem(key: "Genres", value: "Comedy, Drama"),
            KeyValueItem(key: "Production", value: "Doozer, Ruby's Tuna, Universal Television, Warner Bros. Television"),
            KeyValueItem(key: "Trailer", value: nil)
        ]
    )
    .padding()
}
