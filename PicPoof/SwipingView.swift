//
//  SwipingView.swift
//  PicPoof
//
//  Created by Aleks Bursac and Anya Popova on 2024-12-03.
//

import SwiftUI
import Photos

struct SwipingView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var photos: [PHAsset]
    @State private var currentPhotoIndex = 0
    @State private var deletionList: Set<String> = []
    @State private var photoOffset: CGFloat = 0
    @State private var isCompleted = false
    
    let date: (year: String, month: String)

    var body: some View {
        VStack {
            if currentPhotoIndex < photos.count {
                PhotoThumbnailView(asset: photos[currentPhotoIndex])
                    .id(currentPhotoIndex)
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
                    Button("DELETE") {
                        deleteCurrentPhoto()
                    }
                    .font(Font.custom("Montserrat", size: 30).weight(.bold))
                    .foregroundColor(.black)
                    .padding()
                    
                    Spacer()
                    
                    Button("KEEP") {
                        keepCurrentPhoto()
                    }
                    .font(Font.custom("Montserrat", size: 32).weight(.bold))
                    .foregroundColor(.black)
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
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.black)
                        Text("\(date.month.prefix(3).uppercased())")
                            .font(Font.custom("Montserrat", size: 18).weight(.semibold))
                            .foregroundColor(.black)
                        Text("'\(date.year.suffix(2))")
                            .font(Font.custom("Geist", size: 18).weight(.semibold))
                            .foregroundColor(.black)
                    }
                }
            }

            ToolbarItem(placement: .navigationBarTrailing) {
                HStack {
                    Button(action: undoLastDeletion) {
                        Text("\(currentPhotoIndex + 1)/\(photos.count)")
                            .font(Font.custom("Geist", size: 18).weight(.semibold))
                            .foregroundColor(.black)
                        Image(systemName: "arrow.uturn.left")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.black)
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
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
    
    private func undoLastDeletion() {
        if currentPhotoIndex > 0 {
            currentPhotoIndex -= 1
            deletionList.remove(photos[currentPhotoIndex].localIdentifier)
        }
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
