//
//  AlbumView.swift
//  upwards-ios-challenge
//
//  Created by Shahab Darvish on 11/1/23.
//

import SwiftUI

struct AlbumView: View {
    let title: String
    let caption: String
    let albumURL: URL?
    let showStar: Bool
    let isExplicit: Bool
    
    var body: some View {
        VStack {
            AsyncImage(
                url: albumURL,
                content: { image in
                    image
                        .resizable()
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .aspectRatio(1, contentMode: .fit)
                        .layoutPriority(1)

                }, placeholder: {
                    ProgressView()
                }
            )
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(lineWidth: 4)
            )
            .layoutPriority(1)
            
            
            Text(title)
                .multilineTextAlignment(.leading)
            
            HStack {
                Text(caption)
                    .font(.caption)
                    .badge(10)
                
                Spacer()
                
                if showStar {
                    Image(systemName: "star")
                }
                
                if isExplicit {
                    Text("E")
                        .fixedSize()
                        .multilineTextAlignment(.center)
                        .padding(.all, 4)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(lineWidth: 0.5)
                        )
                }
            }
            .frame(minHeight: 20)
        }
        .padding(.zero)
    }
}

#Preview {
    AlbumView(
        title: AlbumFeed.Feed.Album.mock.name,
        caption: AlbumFeed.Feed.Album.mock.artistName,
        albumURL: AlbumFeed.Feed.Album.mock.artworkUrl100,
        showStar: AlbumFeed.Feed.Album.mock.isRecent,
        isExplicit: AlbumFeed.Feed.Album.mock.isExplicit
    )
}

extension TimeInterval {
    static func days(_ num: Double) -> TimeInterval {
        60 * 60 * 24 * num
    }
}

extension AlbumFeed.Feed.Album {
    var isExplicit: Bool {
        contentAdvisoryRating == "Explict"
    }
    
    var isRecent: Bool {
        Date().distance(to: releaseDate) > .days(7)
    }

    static let mock = AlbumFeed.Feed.Album(
        id: "1713845538",
        name: "1989 (Taylor's Version) [Deluxe]",
        artworkUrl100: URL(string: "https://is1-ssl.mzstatic.com/image/thumb/Music116/v4/d2/d1/4d/d2d14d78-56eb-9f6a-ad01-509a80f4b8c1/196871484305.jpg/100x100bb.jpg")!,
        artistName: "Taylor Swift",
        releaseDate: Date().addingTimeInterval(.days(-8)),
        kind: "albums",
        artistId: "159260351",
        artistUrl: "https://music.apple.com/us/artist/taylor-swift/15926035",
        genres: [
            .init(
                genreId: "15",
                name: "R&B/Soul",
                url: URL(string: "https://itunes.apple.com/us/genre/id15")!
            ),
            .init(
                genreId: "34",
                name: "Music",
                url: URL(string: "https://itunes.apple.com/us/genre/id34")!
            ),
            .init(
                genreId: "15",
                name: "R&B/Soul",
                url: URL(string: "https://itunes.apple.com/us/genre/id15")!
            ),
        ],
        url: URL(string: "https://is1-ssl.mzstatic.com/image/thumb/Music116/v4/8e/35/6c/8e356cc2-0be4-b83b-d29e-b578623df2ac/23UM1IM34052.rgb.jpg/100x100bb.jpg")!,
        contentAdvisoryRating: "Explict"
    )
}
