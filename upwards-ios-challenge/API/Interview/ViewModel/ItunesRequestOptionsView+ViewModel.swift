//
//  ItunesRequestOptionsView+ViewModel.swift
//  upwards-ios-challenge
//
//  Created by Shahab Darvish on 11/1/23.
//

import SwiftUI
import Combine

extension ItunesRequestOptionsView {
    typealias Album = AlbumFeed.Feed.Album
    final class ViewModel: ObservableObject {
        @Published var mediaType: MediaType
        @Published var storeFront: Storefront
        @Published var resultLimit: Double
        @Published var deliveryFormat: DeliveryFormat
        @Published var subtype: String
        @Published var feedOption: String
        @Published var isMock: Bool
        @Published var extraDelay: Double
        @Published var isFetchInFlight: Bool
        @Published var sortOption: SortOption
        @Published var sortedAlbums: [Album] = []
        @Published var isAscending: Bool = false

        @Published private var albums: [Album] = []
        private let itunesClient: ItunesClient
        private var cancellable: AnyCancellable?
        private var itunesFetchToken: AnyCancellable?
        private var sortedAlbumToken: AnyCancellable?

        init(
            mediaType: MediaType = .music,
            storeFront: Storefront = .unitedStates,
            resultLimit: Double = 10,
            format: DeliveryFormat = .json,
            isMock: Bool = false,
            itunesClient: ItunesClient = .mock,
            extraDelay: Double = .zero,
            isFetchInFlight: Bool = false,
            sortOption: SortOption = .name
        ) {
            self.mediaType = mediaType
            self.storeFront = storeFront
            self.resultLimit = resultLimit
            self.deliveryFormat = format
            self.subtype = mediaType.subtypes[0]
            self.feedOption = mediaType.feedOptions[0]
            self.isMock = isMock
            self.itunesClient = itunesClient
            self.extraDelay = extraDelay
            self.isFetchInFlight = isFetchInFlight
            self.sortOption = sortOption
            bind()
        }
        
        var feedOptionCount: Int {
            mediaType.feedOptions.count
        }
        
        var feedOptions: [String] {
            mediaType.feedOptions
        }

        var urlString: String? {
            urlComponents.string
        }
        
        private var urlComponents: URLComponents {
            var components = URLComponents()
            components.scheme = "https"
            components.host = "rss.applemarketingtools.com"
            components.path = "/api/v2/\(storeFront.countryCode)/\(mediaType.pathString)/\(feedOption.kebabCase)/\(Int(resultLimit))/\(subtype.kebabCase).\(deliveryFormat.asString)"
            return components
        }
        
        func onAppear() {
            onFetchTapped()
        }
        
        func onMockChanged() {
            albums = []
        }
        
        func onFetchTapped() {
            guard let url = urlComponents.url else { return }
            albums = []
            isFetchInFlight = true
            
            var request = URLRequest(url: url)
            request.httpMethod = HTTPMethod.get.rawValue
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")

            
            itunesFetchToken = itunesClient
                .fetch(request)
                .delay(for: .seconds(isMock ? extraDelay : .zero), scheduler: DispatchQueue.main)
                .sink(
                    receiveCompletion: { [weak self] _ in
                        self?.isFetchInFlight = false
                    }, receiveValue: { albums in
                        self.albums = albums.feed.results
                })
            
        }
        
        private func bind() {
            cancellable = $mediaType.sink { [weak self] in
                if let firstFeedOption = $0.feedOptions.first {
                    self?.feedOption = firstFeedOption
                }
                
                if let firstSubtype = $0.subtypes.first {
                    self?.subtype = firstSubtype
                }
            }
            
            sortedAlbumToken = Publishers.CombineLatest3(
                $sortOption,
                $albums,
                $isAscending
            )
            .map { option, albums, isAscending in
                switch option {
                case .releaseDate:
                    return isAscending
                    ? albums.sorted(by: their(\.releaseDate, by: <))
                    : albums.sorted(by: their(\.releaseDate, by: >))
                case .name:
                    return isAscending
                    ? albums.sorted(by: their(\.name, by: <))
                    : albums.sorted(by: their(\.name, by: >))
                case .articleName:
                    return isAscending
                    ? albums.sorted(by: their(\.artistName, by: <))
                    : albums.sorted(by: their(\.artistName, by: >))
                case .none:
                    return albums
                }
            }
            .sink { [weak self] sorted in
                self?.sortedAlbums = sorted
            }
        }
    }
}

struct ItunesClient {
    let fetch: (URLRequest) -> AnyPublisher<AlbumFeed, Error>
    
    static let mock = ItunesClient { _ in
        Bundle.main
            .url(forResource: "AlbumStubs", withExtension: "json")
            .flatMap { url in try? Data(contentsOf: url) }
            .flatMap { data in try? itunesJsonDecoder.decode(AlbumFeed.self, from: data) }
            .map(Just.init)!
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}

let itunesJsonDecoder: JSONDecoder = {
    let decoder = JSONDecoder()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    decoder.dateDecodingStrategy = .formatted(dateFormatter)
    return decoder
}()
