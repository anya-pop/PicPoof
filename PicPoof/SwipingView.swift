//
//  SwipingView.swift
//  PicPoof
//
//  Created by Aleks Bursac and Anya Popova on 2024-12-03.
//

import SwiftUI
import Photos

struct SwipingView: View {
    @State var photos: [PHAsset]
    @State private var currentPhotoIndex = 0
    @State private var deletionList: Set<String> = []
    @State private var photoOffset: CGFloat = 0
    @State private var isCompleted = false

    var body: some View {
        VStack {
            Text("\(currentPhotoIndex + 1)/\(photos.count)") // debugging
            if currentPhotoIndex < photos.count {
                PhotoThumbnailView(asset: photos[currentPhotoIndex])
                    .onAppear {
                        print("SwipingView loaded with \(photos.count) photos")
                    }
                    .frame(maxHeight: 400)
                    .offset(x: photoOffset)
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                photoOffset = gesture.translation.width
                            }
                            .onEnded { gesture in
                                handleSwipe(gesture.translation.width)
                            }
                    )
                    .animation(.spring(), value: photoOffset)

                HStack {
                    Button("Delete") {
                        deleteCurrentPhoto()
                    }
                    .padding()
                    Spacer()
                    Button("Keep") {
                        keepCurrentPhoto()
                    }
                    .padding()
                }
            } else {
                NavigationLink(
                    destination: ConfirmationView(
                        deletionList: $deletionList,
                        photos: photos.filter { deletionList.contains($0.localIdentifier) }
                    ),
                    isActive: $isCompleted,
                    label: {
                        Text("Review Deletion List")
                    }
                )
                .padding()
                .onAppear {
                    if currentPhotoIndex >= photos.count {
                        isCompleted = true
                    }
                }
            }
        }
        .navigationBarTitle("SwipingView", displayMode: .inline)
    }

    // will clean this up to make swiping gesture smoother
    private func handleSwipe(_ width: CGFloat) {
        if width < -100 {
            deleteCurrentPhoto()
        } else if width > 100 {
            keepCurrentPhoto()
        } else {
            photoOffset = 0
        }
    }

    private func deleteCurrentPhoto() {
        deletionList.insert(photos[currentPhotoIndex].localIdentifier)
        moveToNextPhoto()
    }

    private func keepCurrentPhoto() {
        moveToNextPhoto()
    }

    private func moveToNextPhoto() {
        photoOffset = 0
        if currentPhotoIndex < photos.count - 1 {
            currentPhotoIndex += 1
        } else {
            currentPhotoIndex += 1
            isCompleted = true
        }
    }
}
