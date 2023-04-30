//
//  WikipediaContentView.swift
//  BionicWikipedia
//
//  Created by Sidhant Nair on 4/23/23.
//

import SwiftUI

struct WikipediaContentView: View {
    let content: [WikipediaContentType]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                ForEach(content, id: \.self) { item in
                    switch item {
                    case .header(let text):
                        Text(text)
                            .font(.headline)
                            .bold()
                    case .paragraph(let text):
                        Text(text)
                            .font(.body)
                    case .image(let url):
                        if let url = url {
                            AsyncImage(url: url)
                        }
                    case .list(let items):
                        VStack(alignment: .leading) {
                            ForEach(items, id: \.self) { listItem in
                                Text("• \(listItem)")
                            }
                        }
                    }
                }
            }
            .padding()
        }
    }
}

extension WikipediaContentType: Hashable {
    static func == (lhs: WikipediaContentType, rhs: WikipediaContentType) -> Bool {
        switch (lhs, rhs) {
        case (.header(let lhsText), .header(let rhsText)):
            return lhsText == rhsText
        case (.paragraph(let lhsText), .paragraph(let rhsText)):
            return lhsText == rhsText
        case (.image(let lhsURL), .image(let rhsURL)):
            return lhsURL == rhsURL
        case (.list(let lhsItems), .list(let rhsItems)):
            return lhsItems == rhsItems
        default:
            return false
        }
    }
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case .header(let text):
            hasher.combine(text)
        case .paragraph(let text):
            hasher.combine(text)
        case .image(let url):
            hasher.combine(url)
        case .list(let items):
            hasher.combine(items)
        }
    }
}
