//
//  FeedModels.swift
//  upwards-ios-challenge
//
//  Created by Shahab Darvish on 11/1/23.
//

import Foundation

enum SortOption: String, CaseIterable {
    case releaseDate
    case name
    case articleName
    case none
}

enum MediaType: String, CaseIterable {
    case music
    case podcasts
    case apps
    case books
    case audiobooks
    
    var pathString: String {
        switch self {
        case .music:
            "music"
        case .podcasts:
            "podcasts"
        case .apps:
            "apps"
        case .books:
            "books"
        case .audiobooks:
            "audio-books"
        }
    }
     
    var subtypes: [String] {
        switch self {
        case .music:
            [
                "Albums",
                "Music Videos",
                "Playlists",
                "Songs",
            ]
        case .podcasts:
            [
                "Podcasts",
                "Podcast Episodes",
                "Podcast Channels",
            ]
        case .apps:
            [
                "Apps"
            ]
        case .books:
            [
                "Books"
            ]
        case .audiobooks:
            [
                "Audio Books"
            ]
        }
    }
    
    var feedOptions: [String] {
        switch self {
        case .music:
            ["Most Played"]
        case .podcasts:
            ["Top", "Top Subscriber"]
        case .apps, .books:
            ["Top Free", "Top Paid"]
        case .audiobooks:
            ["Top"]
        }
    }
        
    var capitalizedRawValue: String {
        rawValue.capitalized
    }
}

enum DeliveryFormat: CaseIterable {
    case json
    case rss
    case atom
    
    var localizedTitle: String {
        switch self {
        case .json:
            "JSON"
        case .rss:
            "XML (RSS)"
        case .atom:
            "XML (Atom)"
        }
    }
    
    var asString: String {
        switch self {
        case .json:
            "json"
        case .rss:
            "rss"
        case .atom:
            "atom"
        }
    }
}

enum Storefront: String, CaseIterable {
    case unitedStates = "United States"
    case canada = "Canada"
    case unitedKingdom = "United Kingdom"
    case france = "France"
    
    var countryCode: String {
        switch self {
        case .unitedStates:
            "us"
        case .canada:
            "ca"
        case .unitedKingdom:
            "gb"
        case .france:
            "fr"
        }
    }
}

extension String {
    var kebabCase: String {
        trimmingCharacters(in: .whitespaces)
            .replacingOccurrences(of: " ", with: "-")
            .lowercased()
    }
}
