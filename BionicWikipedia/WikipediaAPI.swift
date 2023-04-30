//
//  WikipediaAPI.swift
//  BionicWikipedia
//
//  Created by Sidhant Nair on 4/23/23.
//

import Foundation
import Combine

struct WikipediaSearchResult: Decodable {
    let title: String
    let snippet: String
}

class WikipediaAPI: ObservableObject {
    private let baseURL = "https://en.wikipedia.org/w/api.php"
    private let session = URLSession.shared
    
    func search(query: String, completion: @escaping ([WikipediaSearchResult]) -> Void) {
        guard var urlComponents = URLComponents(string: baseURL) else {
            completion([] as [WikipediaSearchResult])
            return
        }
        
        let queryItems = [
            URLQueryItem(name: "action", value: "query"),
            URLQueryItem(name: "format", value: "json"),
            URLQueryItem(name: "list", value: "search"),
            URLQueryItem(name: "utf8", value: "1"),
            URLQueryItem(name: "srsearch", value: query),
            URLQueryItem(name: "srlimit", value: "10")
        ]
        urlComponents.queryItems = queryItems
        
        guard let url = urlComponents.url else {
            completion([] as [WikipediaSearchResult])
            return
        }
        
        let task = session.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    if let jsonDictionary = json as? [String: Any],
                       let query = jsonDictionary["query"] as? [String: Any],
                       let searchResults = query["search"] as? [[String: Any]] {
                        let results = searchResults.compactMap { result -> WikipediaSearchResult? in
                            if let title = result["title"] as? String,
                               let snippet = result["snippet"] as? String {
                                return WikipediaSearchResult(title: title, snippet: snippet)
                            }
                            return nil
                        }
                        completion(results)
                    } else {
                        completion([])
                    }
                } catch {
                    print("Error parsing search results: \(error)")
                    completion([])
                }
            } else {
                print("Error fetching search results: \(error?.localizedDescription ?? "Unknown error")")
                completion([])
            }
        }
        task.resume()
    }
    
    func fetchPageContent(title: String, completion: @escaping ([WikipediaContentType]?) -> Void) {
        guard var urlComponents = URLComponents(string: baseURL) else {
            DispatchQueue.main.async {
                completion(nil)
            }
            return
        }

        let queryItems = [
            URLQueryItem(name: "action", value: "parse"),
            URLQueryItem(name: "format", value: "json"),
            URLQueryItem(name: "page", value: title),
            URLQueryItem(name: "utf8", value: "1"),
            URLQueryItem(name: "prop", value: "text"),
            URLQueryItem(name: "formatversion", value: "2")
        ]

        urlComponents.queryItems = queryItems

        guard let url = urlComponents.url else {
            DispatchQueue.main.async {
                completion(nil)
            }
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching page content: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }

            if let data = data, let html = String(data: data, encoding: .utf8) {
                print("Raw HTML content: \(html)")
                let parsedContent = WikipediaContentParser.parse(html: html)
                DispatchQueue.main.async {
                    completion(parsedContent)
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
        task.resume()
    }
}

struct WikipediaPageResponse: Decodable {
    let parse: Parse
    struct Parse: Decodable {
        let title: String
        let text: String
    }
    
}
