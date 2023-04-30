//
//  SearchResultsView.swift
//  BionicWikipedia
//
//  Created by Sidhant Nair on 4/23/23.
//

import SwiftUI

struct SearchResultsView: View {
    let searchResults: [WikipediaSearchResult]

    var body: some View {
        List(searchResults, id: \.title) { result in
            NavigationLink(destination: WikipediaPageView(pageTitle: result.title)) {
                Text(result.title)
            }
        }
    }
}



