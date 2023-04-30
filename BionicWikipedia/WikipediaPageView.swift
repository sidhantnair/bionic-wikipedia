//
//  WikipediaPageView.swift
//  BionicWikipedia
//
//  Created by Sidhant Nair on 4/23/23.
//

import SwiftUI

struct WikipediaPageView: View {
    let pageTitle: String
    @ObservedObject var viewModel = WikipediaPageViewModel()
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            switch viewModel.pageContent {
            case .loading:
                ProgressView()
            case .loaded(let content):
                WikipediaContentView(content: content)
            case .error(let message):
                Text(message)
                    .foregroundColor(.red)
            }
        }
        .onAppear {
            print("Page title received: \(pageTitle)")
            viewModel.loadWikipediaPage(title: pageTitle)
        }
        .navigationBarTitle(Text(pageTitle), displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Image(systemName: "chevron.backward")
                        Text("Back")
                    }
                }
            }
        }
    }
}

class WikipediaPageViewModel: ObservableObject {
    @Published var pageContent: PageContent = .loading
    private var wikipediaAPI = WikipediaAPI()

    func loadWikipediaPage(title: String) {
        print("Loading Wikipedia page with title: \(title)")
        pageContent = .loading
        wikipediaAPI.fetchPageContent(title: title) { content in
            if let content = content {
                self.pageContent = .loaded(content)
            } else {
                self.pageContent = .error("An error occurred while loading the content. Please try again.")
            }
        }
    }
    
    enum PageContent {
        case loading
        case loaded([WikipediaContentType])
        case error(String)
    }
}
