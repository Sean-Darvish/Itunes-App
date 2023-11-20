//
//  FeedSettingsMenuView.swift
//  upwards-ios-challenge
//
//  Created by Shahab Darvish on 11/1/23.
//

import SwiftUI

struct FeedSettingsMenuView: View {
    @Binding var mediaType: MediaType
    @Binding var storeFront: Storefront
    @Binding var subtype: String
    @Binding var feedOption: String
    let mediaTypeSubtypes: [String]
    let feedOptionCount: Int
    let feedOptions: [String]
    @Binding var resultLimit: Double
    @Binding var deliveryFormat: DeliveryFormat
    
    var body: some View {
        VStack {
            Picker("Media Type", selection: $mediaType) {
                ForEach(MediaType.allCases, id: \.self) { type in
                    Text(type.capitalizedRawValue)
                        .tag(type)
                }
            }

            Picker("Storefront", selection: $storeFront) {
                ForEach(Storefront.allCases, id: \.self) { storeFront in
                    Text(storeFront.rawValue)
                        .tag(storeFront)
                }
            }
            
            Picker("Sub Type", selection: $subtype) {
                ForEach(mediaTypeSubtypes, id: \.self) { subtype in
                    Text(subtype).tag(subtype)
                }
            }
            .pickerStyle(.segmented)
            
            switch feedOptionCount {
            case 1:
                Text("One Option: \(feedOption)")
            default:
                Picker("Feed", selection: $feedOption) {
                    if feedOptionCount > 3 {
                        ForEach(feedOptions, id: \.self) { feed in
                            Text(feed).tag(feed)
                        }

                    } else {
                        ForEach(feedOptions, id: \.self) { feed in
                            Text(feed).tag(feed)
                        }
                        .pickerStyle(.segmented) // conditional style not supported by swiftui
                    }
                }
            }
            
            Text("Result limit: \(Int(resultLimit))")
            
            Slider(value: $resultLimit, in: 1...20, step: 1)
            
            Picker("Format", selection: $deliveryFormat) {
                ForEach(DeliveryFormat.allCases, id: \.self) { format in
                    Text(format.localizedTitle).tag(format)
                }
            }
            .pickerStyle(.segmented)
        }
    }
}

