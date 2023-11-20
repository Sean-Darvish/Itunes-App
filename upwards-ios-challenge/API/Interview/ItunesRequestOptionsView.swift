//
//  ItunesRequestOptionsView.swift
//  upwards-ios-challenge
//
//  Created by Shahab Darvish on 10/31/23.
//

import SwiftUI

struct ItunesRequestOptionsView: View {
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        Form {
            Section("Feed Settings") {
                
                Text("Use the dropdowns to pick setting to generate a new RSS feed URL.")
                    .multilineTextAlignment(.center)
                    .font(.caption)
                
                FeedSettingsMenuView(
                    mediaType: $viewModel.mediaType,
                    storeFront: $viewModel.storeFront.animation(.bouncy),
                    subtype: $viewModel.subtype.animation(.bouncy),
                    feedOption: $viewModel.feedOption,
                    mediaTypeSubtypes: viewModel.mediaType.subtypes,
                    feedOptionCount: viewModel.feedOptionCount,
                    feedOptions: viewModel.feedOptions,
                    resultLimit: $viewModel.resultLimit,
                    deliveryFormat: $viewModel.deliveryFormat
                )
                .disabled(viewModel.isFetchInFlight)
            }
            
            Section("Try me") {
                Toggle(viewModel.isMock ? "Mock" : "Live", isOn: Binding(
                    get: { viewModel.isMock },
                    set: {
                        viewModel.onMockChanged()
                        viewModel.isMock = $0
                    }
                ))
                
                Toggle(viewModel.isAscending ? "ASC" : "DESC", isOn: $viewModel.isAscending)
                
                Picker("sort options", selection: $viewModel.sortOption) {
                    ForEach(SortOption.allCases, id: \.self) { option in
                        Text(option.rawValue.capitalized)
                    }
                }

                if viewModel.isMock {
                    HStack {
                        Text("Simulate delay: \(viewModel.extraDelay)")
                        Slider(value: $viewModel.extraDelay, in: 0...5)
                    }
                }

                if let urlString = viewModel.urlString {
                    Text(urlString)
                }

                HStack {
                    Spacer()
                    
                    Button.init(action: {
                        viewModel.onFetchTapped()
                    }, label: {
                        Text(viewModel.isFetchInFlight ? "Fetching..." : "Fetch")
                            .foregroundColor(viewModel.isFetchInFlight ? .orange : .white)
                    })
                    .disabled(viewModel.isFetchInFlight)
                    
                    
                    if viewModel.isFetchInFlight {
                        ProgressView().padding(.leading, 8)
                    }
                    
                    Spacer()
                }
            }
            
            ScrollView {
                LazyVGrid(
                    columns: [
                        GridItem(.flexible(), spacing: 0),
                        GridItem(.flexible(), spacing: 0),
                    ],
                    content: {
                        ForEach(viewModel.sortedAlbums) { album in
                            AlbumView(
                                title: album.name,
                                caption: album.artistName,
                                albumURL: album.artworkUrl100,
                                showStar: album.isRecent,
                                isExplicit: album.isExplicit
                            )
                            .frame(height: 200)
                        }
                    }
                )
                .padding()
            }
        }.onAppear {
            viewModel.onAppear()
        }
    }
}

#Preview {
    ItunesRequestOptionsView(viewModel: .init())
}
