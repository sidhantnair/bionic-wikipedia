//
//  SeaarchResultsViewModel.swift
//  BionicWikipedia
//
//  Created by Sidhant Nair on 4/23/23.
//

import Foundation
import Combine

class SearchResultsViewModel: ObservableObject {
    @Published var searchResults: [WikipediaSearchResult] = []
    private var wikipediaAPI = WikipediaAPI()

    func search(query: String) {
        // If the query is empty, clear the search results and return
        if query.isEmpty {
            searchResults = []
            return
        }
        
        // Perform the search if the query is not empty
        wikipediaAPI.search(query: query) { results in
            DispatchQueue.main.async {
                self.searchResults = results
            }
        }
    }

    func resetSearchResults() {
        searchResults = []
    }
}






