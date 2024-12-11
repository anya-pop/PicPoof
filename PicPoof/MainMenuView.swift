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
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                    ForEach(Array(photosByYearMonth.keys).sorted(by: >), id: \.self) { year in
                        ForEach(Array(photosByYearMonth[year]!.keys).sorted(), id: \.self) { month in
                            NavigationLink(destination: SwipingView(
                                photos: photosByYearMonth[year]?[month] ?? [],
                                date: (year: year, month: month) 
                            )) {
                                Text("\(month.prefix(3).uppercased()) ‘\(year.suffix(2))")
                                    .font(
                                        Font.custom("Montserrat", size: 20)
                                            .weight(.semibold)
                                    )
                                    .foregroundColor(.black)
                                    .padding(.horizontal, 28)
                                    .padding(.vertical, 13)
                                    .frame(width: 175, height: 55, alignment: .center)
                                    .background(
                                        MonthGradients.gradients[month] ?? LinearGradient(
                                            gradient: Gradient(colors: [Color.gray, Color.gray]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .cornerRadius(5)
                            }
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.top)
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Image("picpoof")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 48)
                }
            }
            .onAppear {
                fetchPhotosByYearMonth()
            }
        }
    }
    
    func fetchPhotosByYearMonth() {
        PHPhotoLibrary.requestAuthorization { status in
            guard status == .authorized else {
                print("Photo library access denied.")
                return
            }
            
            let fetchOptions = PHFetchOptions()
            fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)

            var tempPhotosByYearMonth: [String: [String: [PHAsset]]] = [:]

            for i in 0..<fetchResult.count {
                let asset = fetchResult[i]
                guard let creationDate = asset.creationDate else { continue }
                let year = creationDate.formatted(.dateTime.year())
                let month = creationDate.formatted(.dateTime.month(.wide))

                tempPhotosByYearMonth[year, default: [:]][month, default: []].append(asset)
            }

            photosByYearMonth = tempPhotosByYearMonth
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
