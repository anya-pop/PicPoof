//
//  DeletionView.swift
//  PicPoof
//
//  Created by Aleks Bursac and Anya Popova on 2024-12-03.
//

import SwiftUI
import Photos

struct ConfirmationView: View {
    @Binding var deletionList: Set<String>
    @State var photos: [PHAsset]

    var body: some View {
        VStack {
            Text("DELETE \(deletionList.count) ITEMS?")
                .font(.headline)

            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(), count: 3)) {
                    ForEach(photos, id: \.localIdentifier) { photo in
                        PhotoThumbnailView(asset: photo)
                            .overlay(
                                deletionList.contains(photo.localIdentifier) ?
                                    Color.blue.opacity(0.5) : Color.clear
                            )
                            .onTapGesture {
                                if deletionList.contains(photo.localIdentifier) {
                                    deletionList.remove(photo.localIdentifier)
                                } else {
                                    deletionList.insert(photo.localIdentifier)
                                }
                            }
                    }
                }
            }

            Button("DELETE \(deletionList.count) ITEMS?") {
                performDeletion()
            }
            .padding()
        }
    }

    private func performDeletion() {
        // to implement after core bugs are fixed:
            // alert on successful delete and how much storage saved
            // then persist some statistics to coredata
        print("Performing deletion for \(deletionList.count) items.")
    }
}

//#Preview {
//    ConfirmationView()
//}
