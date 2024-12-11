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
    @State private var dragAmount = CGSize.zero
    @State private var isCompleted = false
    let date: (year: String?, month: String?)

    var body: some View {
        VStack {
            if currentPhotoIndex < photos.count {
                ZStack {
                    if currentPhotoIndex + 1 < photos.count {
                        PhotoThumbnailView(asset: photos[currentPhotoIndex + 1])
                            .id(currentPhotoIndex + 1)
                            .opacity(0.25)
                            .scaleEffect(0.75)
                    }
                    
                    PhotoThumbnailView(asset: photos[currentPhotoIndex])
                        .id(currentPhotoIndex)
                        .onAppear {
                            print("SwipingView loaded with \(photos.count) photos")
                        }
                        .frame(maxHeight: 600)
                        .offset(dragAmount)
                        .rotationEffect(.degrees(Double(dragAmount.width / 10)))
                        .opacity(1 - min(abs(dragAmount.width) / 300.0, 0.5))
                        .overlay(
                            Rectangle()
                                .fill(dragAmount.width > 0
                                      ? Color.green.opacity(Double(abs(dragAmount.width) / 300.0))
                                      : Color.red.opacity(Double(abs(dragAmount.width) / 300.0)))
                                .blendMode(.overlay)
                                .offset(dragAmount)
                                .rotationEffect(.degrees(Double(dragAmount.width / 10)))
                        )
                        .gesture(
                            DragGesture()
                                .onChanged {
                                    dragAmount = $0.translation
                                }
                                .onEnded { gesture in
                                    let threshold: CGFloat = 100
                                    let isSwipeRight = gesture.translation.width > threshold
                                    let isSwipeLeft = gesture.translation.width < -threshold
                                    
                                    let offScreenTranslation = CGSize(width: isSwipeRight ? 600 : (isSwipeLeft ? -600 : 0), height: -300)
                                    let offScreenRotation: CGFloat = isSwipeRight ? 30 : (isSwipeLeft ? -30 : 0)
                                    
                                    if isSwipeRight || isSwipeLeft {
                                        withAnimation(.easeOut(duration: 0.3)) {
                                            dragAmount = offScreenTranslation
                                        }
                                        
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                            dragAmount = .zero
                                            handleSwipe(gesture.translation.width)
                                        }
                                    } else {
                                        withAnimation {
                                            dragAmount = .zero
                                        }
                                    }
                                }
                        )
                }

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
                        VStack {
                            Text("Are you sure?")
                                .font(Font.custom("Montserrat", size: 24).weight(.semibold))
                                .foregroundColor(.black)
                            HStack{
                                Text("Confirm Deletion")
                                    .font(Font.custom("Montserrat", size: 20).weight(.semibold))
                                    .foregroundColor(.green)
                                Image(systemName: "arrow.right")
                                        .foregroundColor(.green)
                                
                            }
                        }
                        
                    }
                )
                .padding()
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

                        if let month = date.month, let year = date.year {
                            Text("\(month.prefix(3).uppercased())")
                                .font(Font.custom("Montserrat", size: 18).weight(.semibold))
                                .foregroundColor(.black)
                            Text("'\(year.suffix(2))")
                                .font(Font.custom("Geist", size: 18).weight(.semibold))
                                .foregroundColor(.black)
                        }
                    }
                }
            }

            ToolbarItem(placement: .navigationBarTrailing) {
                HStack() {
                    Button(action: undoLastDeletion) {
                        Text("\(currentPhotoIndex < photos.count ? currentPhotoIndex + 1 : currentPhotoIndex)/\(photos.count)")
                            .font(Font.custom("Geist", size: 18).weight(.semibold))
                            .foregroundColor(.black)
                        Image(systemName: "arrow.uturn.left")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.black)
                            .opacity(currentPhotoIndex == 0 ? 0.25 : 1)
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }

    private func handleSwipe(_ width: CGFloat) {
        if width < -100 {
            deleteCurrentPhoto()
        } else if width > 100 {
            keepCurrentPhoto()
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
        if currentPhotoIndex < photos.count - 1 {
            currentPhotoIndex += 1
        } else {
            currentPhotoIndex += 1
            isCompleted = true
        }
    }
}

