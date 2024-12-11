//
//  SwipingView.swift
//  PicPoof
//
//  Created by Aleks Bursac and Anya Popova on 2024-12-03.
//

import SwiftUI
import Photos

struct SwipingView: View {
    @Environment(\.rootPresentationMode) var rootPresentationMode
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.dismiss) private var dismiss
    @State var photos: [PHAsset]
    @State private var currentPhotoIndex = 0
    @State private var deletionList: Set<String> = []
    @State private var dragAmount = CGSize.zero
    @State private var dragging: Bool = false
    @State private var showOverlay: Bool = false
    @State private var photoInfo = "Photo info"
    @State private var blurAmount: CGFloat = 0
    @State private var photoInfoOpacity = 0.0
    
    @State private var isCompleted = false
    let date: (year: String?, month: String?)

    var body: some View {
        VStack {
            Spacer()
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
                        .frame(maxHeight: 600)
                        .offset(dragAmount)
                        .rotationEffect(.degrees(Double(dragAmount.width / 10)))
                        .opacity(1 - min(abs(dragAmount.width) / 600.0, 0.5))
                        .blur(radius: blurAmount)
                        .overlay(
                            ZStack {
                                if showOverlay {
                                    Text(photoInfo)
                                        .font(Font.custom("Montserrat", size: 18).weight(.semibold))
                                        .foregroundColor(.white)
                                        .padding()
                                        .background(Color.black.opacity(0.7))
                                        .cornerRadius(10)
                                        .offset(dragAmount)
                                        .rotationEffect(.degrees(Double(dragAmount.width / 10)))
                                        .opacity(photoInfoOpacity)
                                            .onAppear {
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                                    withAnimation(.easeIn(duration: 0.2)) {
                                                        if dragging {
                                                            photoInfoOpacity = 1.0
                                                            blurAmount = 2
                                                        }
                                                    }
                                                }
                                            }
                                            .onDisappear {
                                                DispatchQueue.main.async {
                                                    photoInfoOpacity = 0.0
                                                    blurAmount = 0
                                                    dragging = false
                                                }
                                            }
                                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                                        .padding([.leading], 16)
                                }
                                Rectangle()
                                    .fill(dragAmount.width > 0
                                          ? Color.green.opacity(Double(abs(dragAmount.width) / 300.0))
                                          : Color.red.opacity(Double(abs(dragAmount.width) / 300.0)))
                                    .blendMode(.overlay)
                                    .offset(dragAmount)
                                    .rotationEffect(.degrees(Double(dragAmount.width / 10)))
                            }
                        )
                        .gesture(
                            DragGesture()
                                .onChanged {
                                    dragging = true
                                    dragAmount = $0.translation
                                    showOverlay = true
                                    photoInfo = "Photo taken at \(photos[currentPhotoIndex].creationDate?.formatted() ?? "Unknown date")"
                                    
                                }
                                .onEnded { gesture in
                                    dragging = false
                                    withAnimation(.easeIn(duration: 0.2)) {
                                        photoInfoOpacity = 0.0
                                        blurAmount = 0
                                    }
                                    showOverlay = false
                                    
                                    let threshold: CGFloat = 100
                                    let isSwipeRight = gesture.translation.width > threshold
                                    let isSwipeLeft = gesture.translation.width < -threshold
                                    
                                    let offScreenTranslation = CGSize(width: isSwipeRight ? 600 : (isSwipeLeft ? -600 : 0), height: -300)
//                                    let offScreenRotation: CGFloat = isSwipeRight ? 30 : (isSwipeLeft ? -30 : 0)
                                    
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
                Spacer()

                HStack {
                    Button("DELETE") {
                        deleteCurrentPhoto()
                    }
                    .font(Font.custom("Montserrat", size: 30).weight(.bold))
                    .foregroundColor(.black)
                    .padding(.leading)
                    Text("\(deletionList.count)")
                      .font(
                        Font.custom("Geist", size: 22)
                          .weight(.medium)
                      )
                      .foregroundColor(.black)
                    
                    Spacer()
                   
                    Text("\(currentPhotoIndex - deletionList.count)")
                        .font(
                            Font.custom("Geist", size: 22)
                                .weight(.medium)
                        )
                        .foregroundColor(.black)
                    
                    Button("KEEP") {
                        keepCurrentPhoto()
                    }
                    .font(Font.custom("Montserrat", size: 32).weight(.bold))
                    .foregroundColor(.black)
                    .padding(.trailing)
                }
            } else {
                NavigationLink(
                    destination: ConfirmationView(
                        deletionList: $deletionList,
                        photos: photos ,
                        date: (year: date.year ?? "", month: date.month ?? "")
                    ),
                    isActive: $isCompleted,
                    label: {
                        VStack {
                            Spacer()
                            Text("Are you sure? 🤔")
                                .font(Font.custom("Montserrat", size: 30).weight(.semibold))
                                .foregroundColor(.black)
                            HStack{
                                Text("Confirm Deletion")
                                    .font(Font.custom("Montserrat", size: 20).weight(.semibold))
                                    .foregroundColor(.green)
                                Image(systemName: "arrow.right")
                                        .foregroundColor(.green)
                                
                            }
                            Spacer()
                        }
                        
                    }
                )
                .padding()
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("DismissSwipingView"))) { _ in
            print("dismissing VIEW")
            presentationMode.wrappedValue.dismiss()
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

