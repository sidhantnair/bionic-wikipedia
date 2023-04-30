//
//  WikipediaContentParser.swift
//  BionicWikipedia
//
//  Created by Sidhant Nair on 4/23/23.
//

// WikipediaContentParser.swift

import SwiftSoup
import Foundation

enum WikipediaContentType {
    case header(String)
    case paragraph(String)
    case image(URL?)
    case list([String])
}

struct WikipediaContentParser {
    static func parse(html: String) -> [WikipediaContentType] {
        var content: [WikipediaContentType] = []
        do {
            let document = try SwiftSoup.parse(html)
            let body = try document.body()
            let elements = try body?.children() ?? Elements()
            
            print("Number of elements: \(elements.count)")
            
            for element in elements {
                let tagName = try element.tagName()
                print("Element tag name: \(tagName)")
                
                if tagName == "h2" {
                    let headerText = try element.text()
                    content.append(.header(headerText))
                } else if tagName == "p" {
                    let paragraphText = try element.text()
                    content.append(.paragraph(paragraphText))
                } else if tagName == "img" {
                    let src = try element.attr("src")
                    let imageURL = URL(string: src)
                    content.append(.image(imageURL))
                } else if tagName == "ul" {
                    let listItems = try element.select("li").array()
                    let listText = listItems.compactMap { try? $0.text() }
                    content.append(.list(listText))
                }
            }
        } catch {
            print("Error parsing HTML: \(error)")
        }
        print("Parsed content: \(content)")
        return content
    }
}

