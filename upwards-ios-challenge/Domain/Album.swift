//
//  Album.swift
//  upwards-ios-challenge
//
//  Created by Alex Livenson on 9/13/21.
//

import Foundation

struct AlbumFeed: Decodable {
    struct Feed: Decodable {
        struct Link: Decodable {
//            let name: String
            let url: String?
        }
        struct Author: Decodable {
            let name: String
            let url: String
        }

        struct Album: Decodable, Identifiable {
            struct Genre: Decodable {
                let genreId: String
                let name: String
                let url: URL
            }
            
            let id: String
            let name: String
            let artworkUrl100: URL?
            let artistName: String
            let releaseDate: Date
            
            let kind, artistId: String
            let artistUrl: String
            let genres: [Genre] // show safari?
            let url: URL // url? maybe show this in safari..
            let contentAdvisoryRating: String?
        }

        let title: String
        let id: String
        let author: Author
        let links: [Link]
        let copyright: String
        let country: String
        let icon: URL
        
        let results: [Album]
    }

    let feed: Feed
}


func their<A, B: Comparable>(
    _ f: @escaping (A) -> B,
    by: @escaping (B, B) -> Bool
) -> (A, A) -> Bool {
    {
        by(f($0), f($1))
    }
}
