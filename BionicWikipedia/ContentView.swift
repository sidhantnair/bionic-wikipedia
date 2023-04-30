//
//  ContentView.swift
//  BionicWikipedia
//
//  Created by Sidhant Nair on 4/23/23.
//

import SwiftUI

struct ContentView: View {
    @State private var searchText = ""
    @StateObject private var searchResultsViewModel = SearchResultsViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Search...", text: $searchText)
                    .onChange(of: searchText, perform: searchResultsViewModel.search)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                // Pass the non-binding value here
                SearchResultsView(searchResults: searchResultsViewModel.searchResults)
            }
            .navigationBarTitle("Wikipedia Search")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



