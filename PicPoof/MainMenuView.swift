//
//  ContentView.swift
//  PicPoof
//
//  Created by Aleks Bursac and Anya Popova on 2024-11-21.
//

import SwiftUI
import Photos

struct MainMenuView: View {
    @Environment(\.rootPresentationMode) var rootPresentationMode
    @Environment(\.presentationMode) var presentationMode
    @State private var photosByYearMonth: [String: [String: [PHAsset]]] = [:]
    @State private var recentPhotos: [PHAsset] = []
    @State private var randomPhotos: [PHAsset] = []
    @State private var showSwipingView = false
    @State private var selectedPhotos: [PHAsset] = []
    @State private var selectedDate: (year: String?, month: String?)? = nil
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    VStack(spacing: 10) {
                        Button(action: {
                            loadFlashbackPhotos()
                        }) {
                            HStack {
                                Text("Flashbacks")
                                    .font(Font.custom("Montserrat", size: 20).weight(.semibold))
                                    .foregroundColor(.black)
                                    .padding(.trailing)
                                
                                Spacer()
                                
                                Image("cloud")
                                    .foregroundColor(.white)
                                    .padding(.trailing)
                            }
                            .padding()
                            .frame(maxWidth: .infinity, minHeight: 90)
                            .background(Gradients.gradients["Flashbacks"])
                            .cornerRadius(10)
                        }
                        
                        Button(action: {
                            loadRecentPhotos()
                        }) {
                            HStack {
                                Text("Recents")
                                    .font(Font.custom("Montserrat", size: 20).weight(.semibold))
                                    .foregroundColor(.black)
                                    .padding(.trailing)
                                
                                Spacer()
                                
                                Image("clock")
                                    .foregroundColor(.white)
                                    .padding(.trailing)
                            }
                            .padding()
                            .frame(maxWidth: .infinity, minHeight: 90)
                            .background(Gradients.gradients["Recents"])
                            .cornerRadius(10)
                        }
                        
                        Button(action: {
                            loadRandomPhotos()
                        }) {
                            HStack {
                                Text("Random")
                                    .font(Font.custom("Montserrat", size: 20).weight(.semibold))
                                    .foregroundColor(.black)
                                    .padding(.trailing)
                                
                                Spacer()
                                
                                Image("shuffle")
                                    .foregroundColor(.white)
                                    .padding(.trailing)
                            }
                            .padding()
                            .frame(maxWidth: .infinity, minHeight: 90)
                            .background(Gradients.gradients["Random"])
                            .cornerRadius(10)
                        }
                    }
                    .padding()
                    
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                        ForEach(Array(photosByYearMonth.keys).sorted(by: >), id: \.self) { year in
                            ForEach(Array(photosByYearMonth[year]!.keys).sorted(), id: \.self) { month in
                                NavigationLink(
                                    destination: SwipingView(
                                        photos: photosByYearMonth[year]?[month] ?? [],
                                        date: (year: year, month: month)
                                    )
                                ) {
                                    Text("\(month.prefix(3).uppercased()) ‘\(year.suffix(2))")
                                        .font(Font.custom("Montserrat", size: 20).weight(.semibold))
                                        .foregroundColor(.black)
                                        .padding(.horizontal, 28)
                                        .padding(.vertical, 13)
                                        .frame(width: 175, height: 55, alignment: .center)
                                        .background(
                                            Gradients.gradients[month] ?? LinearGradient(
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
            .background(
                NavigationLink(
                    destination: SwipingView(
                        photos: selectedPhotos,
                        date: (year: selectedDate?.year ?? "", month: selectedDate?.month ?? "")
                    ),
                    isActive: $showSwipingView,
                    label: { EmptyView() }
                )
                .isDetailLink(false)
            )
        }
        .navigationViewStyle(.stack)
        .environment(\.rootPresentationMode, self.$showSwipingView)
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
    
    func loadRecentPhotos() {
        PHPhotoLibrary.requestAuthorization { status in
            guard status == .authorized else { return }
            
            let fetchOptions = PHFetchOptions()
            fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            fetchOptions.fetchLimit = 3
            
            let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
            recentPhotos = Array(fetchResult.objects(at: IndexSet(0..<min(fetchResult.count, 20))))
            
            selectedPhotos = recentPhotos
            selectedDate = (year: nil, month: nil)
            showSwipingView = true
        }
    }
    
    func loadRandomPhotos() {
        PHPhotoLibrary.requestAuthorization { status in
            guard status == .authorized else { return }
            
            let fetchOptions = PHFetchOptions()
            let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
            
            var assets = Array(fetchResult.objects(at: IndexSet(0..<fetchResult.count)))
            assets.shuffle()
            randomPhotos = Array(assets.prefix(3))
            
            selectedPhotos = randomPhotos
            selectedDate = (year: nil, month: nil)
            showSwipingView = true
        }
    }
    
    func loadFlashbackPhotos() {
        PHPhotoLibrary.requestAuthorization { status in
            guard status == .authorized else { return }
            
            let fetchOptions = PHFetchOptions()
            let calendar = Calendar.current
            let currentDate = Date()
            let oneYearAgo = calendar.date(byAdding: .year, value: -1, to: currentDate)!
            
            let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: oneYearAgo))!
            let endOfMonth = calendar.date(byAdding: .month, value: 1, to: startOfMonth)!.addingTimeInterval(-1)
            
            fetchOptions.predicate = NSPredicate(format: "creationDate >= %@ AND creationDate <= %@", startOfMonth as CVarArg, endOfMonth as CVarArg)
            fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            
            let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
            
            var flashbackPhotos: [PHAsset] = []
            for i in 0..<fetchResult.count {
                flashbackPhotos.append(fetchResult[i])
            }
            
            selectedPhotos = flashbackPhotos
            selectedDate = (year: String(Calendar.current.component(.year, from: oneYearAgo)), month: String(Calendar.current.component(.month, from: oneYearAgo)))
            showSwipingView = true
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
