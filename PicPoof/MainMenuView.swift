//
//  ContentView.swift
//  PicPoof
//
//  Created by Aleks Bursac and Anya Popova on 2024-11-21.
//

import SwiftUI
import Photos

struct MainMenuView: View {
    @State private var photosByYearMonth: [String: [String: [PHAsset]]] = [:]
        @State private var selectedMonth: String?
        @State private var selectedPhotos: [PHAsset] = []
        @State private var showSwipingView = false

        var body: some View {
            NavigationView {
                ScrollView {
                    LazyVStack(spacing: 20) {
                        ForEach(Array(photosByYearMonth.keys).sorted(by: >), id: \.self) { year in
                            VStack(alignment: .leading) {
                                Text(year)
                                    .font(.headline)

                                ScrollView(.horizontal) {
                                    HStack {
                                        ForEach(Array(photosByYearMonth[year]!.keys).sorted(), id: \.self) { month in
                                            Button(month) {
                                                selectedMonth = month
                                                selectedPhotos = photosByYearMonth[year]?[month] ?? []
                                                showSwipingView = true
                                            }
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.top)
                }
                .navigationTitle("PicPoof")
                .onAppear {
                    fetchPhotosByYearMonth()
                }
                // this will show a SwipingView for the selected month in a sheet for now
                // you can refactor it after I make a navbar for SwipingView
                .sheet(isPresented: $showSwipingView) {
                    SwipingView(photos: selectedPhotos)
                }
            }
        }
    

    func fetchPhotosByYearMonth() {
        PHPhotoLibrary.requestAuthorization { status in
            if status == .authorized {
                let fetchOptions = PHFetchOptions()
                fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
                let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)

                for i in 0..<fetchResult.count {
                    let asset = fetchResult[i]
                    guard let creationDate = asset.creationDate else { continue }
                    let year = creationDate.formatted(.dateTime.year())
                    let monthName = creationDate.formatted(.dateTime.month(.wide))

                    photosByYearMonth[year, default: [:]][monthName, default: []].append(asset)
                }
            } else {
                print("Photo library access denied.")
            }
        }
    }
}

struct PhotoThumbnailView: View {
    let asset: PHAsset
    @State private var image: UIImage?

    var body: some View {
        if let image = image {
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
        } else {
            ProgressView()
                .onAppear {
                    loadPhoto()
                }
        }
    }

    func loadPhoto() {
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.isSynchronous = false

        PHImageManager.default().requestImage(
            for: asset,
            targetSize: CGSize(width: 800, height: 800),
            contentMode: .aspectFit,
            options: options
        ) { (result, _) in
            self.image = result
        }
    }
}

#Preview {
    MainMenuView()
}
