//
//  SwipingView.swift
//  PicPoof
//  991 694 498
//  991 683 351
//  Anya Popova
//  Aleks Bursac
//  PROG31975
//  Created by Aleks Bursac and Anya Popova on 2024-12-03.
//

import SwiftUI
import Photos
import CoreLocation
import CoreData
import Foundation

struct SwipingView: View {
    @Environment(\.rootPresentationMode) var rootPresentationMode
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    
    @State var photos: [PHAsset]
    @State private var currentPhotoIndex = 0
    @State private var deletionList: Set<String> = []
    @State private var dragAmount = CGSize.zero
    @State private var dragging: Bool = false
    @State private var photoInfoOpacity = 0.0
    @State private var blurAmount: CGFloat = 0
    @State private var showOverlay: Bool = false
    @State private var photoDate = "Photo date"
    @State private var photoLocation = "Photo location"
    @State private var photoSize = "Photo size"
    
    @State private var isCompleted = false
    @StateObject private var vm = CoreDataViewModel()

    let date: (year: String?, month: String?)
    
    func daySuffix(from day: Int) -> String {
        switch day {
        case 1, 21, 31: return "st"
        case 2, 22: return "nd"
        case 3, 23: return "rd"
        default: return "th"
        }
    }

    
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
                        .scaledToFit()
                        .offset(dragAmount)
                        .rotationEffect(.degrees(Double(dragAmount.width / 10)))
                        .opacity(1 - min(abs(dragAmount.width) / 600.0, 0.5))
                        .blur(radius: blurAmount)
                        .overlay(
                            ZStack {
                                if showOverlay {
                                    VStack() {
                                        VStack(alignment: .leading) {
                                            Text(photoDate)
                                            Text(photoLocation)
                                            Text(photoSize)
                                        }
                                        .multilineTextAlignment(.leading)
                                        .font(Font.custom("Geist", size: 18).weight(.semibold))
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
                                    }.padding(.top, 172)
                                }
                                Rectangle()
                                    .fill(dragAmount.width > 0
                                          ? Color.green.opacity(Double(abs(dragAmount.width) / 300.0))
                                          : Color.red.opacity(Double(abs(dragAmount.width) / 300.0)))
                                    .blendMode(.overlay)
                                    .offset(dragAmount)
                                    .rotationEffect(.degrees(Double(dragAmount.width / 10)))
                            }
                            .onAppear {
                                if let creationDate = photos[currentPhotoIndex].creationDate {
                                    let day = Calendar.current.component(.day, from: creationDate)
                                    let daySuffix = daySuffix(from: day)
                                    let dateFormatter = DateFormatter()
                                    dateFormatter.dateFormat = "MMM d'\(daySuffix)', yyyy"
                                    photoDate = dateFormatter.string(from: creationDate)
                                } else {
                                    photoDate = "Unknown date 😵‍💫"
                                }
                                
                                if let location = photos[currentPhotoIndex].location {
                                    let geocoder = CLGeocoder()
                                    geocoder.reverseGeocodeLocation(location) { placemarks, error in
                                        if let placemark = placemarks?.first {
                                            let country = placemark.country ?? ""
                                            let city = placemark.locality ?? ""
                                            
                                            if !city.isEmpty {
                                                photoLocation = "\(city), \(country)"
                                            } else {
                                                photoLocation = country
                                            }
                                        } else {
                                            photoLocation = "Unknown location 😵‍💫"
                                        }
                                    }
                                } else {
                                    photoLocation = "Unknown location 😵‍💫"
                                }
                                
                                let options = PHContentEditingInputRequestOptions()
                                photos[currentPhotoIndex].requestContentEditingInput(with: options) { input, _ in
                                    if let url = input?.fullSizeImageURL, let fileSize = try? FileManager.default.attributesOfItem(atPath: url.path)[.size] as? Int {
                                        let sizeInMB = Double(fileSize) / (1024 * 1024)
                                        photoSize = String(format: "%.2f MB", sizeInMB)
                                    } else {
                                        photoSize = "Unknown size"
                                    }
                                }
                            }
                        )
                        .gesture(
                            DragGesture()
                                .onChanged {
                                    dragging = true
                                    dragAmount = $0.translation
                                    showOverlay = true
                                    
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
                      .padding(.top, 4)
                    
                    Spacer()
                   
                    Text("\(currentPhotoIndex - deletionList.count)")
                        .font(
                            Font.custom("Geist", size: 22)
                                .weight(.medium)
                        )
                        .foregroundColor(.black)
                        .padding(.top, 4)
                    Button("KEEP") {
                        keepCurrentPhoto()
                    }
                    .font(Font.custom("Montserrat", size: 32).weight(.bold))
                    .foregroundColor(.black)
                    .padding(.trailing)
                }
                .padding(.bottom, 32)
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

                        if let month = date.month, !month.isEmpty, let year = date.year, !year.isEmpty {
                            Text("\(month.prefix(3).uppercased()) '\(year.suffix(2))")
                                .font(Font.custom("Geist", size: 18).weight(.semibold))
                                .foregroundColor(.black)
                        } else {
                            Text("Back") 
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
                markMonthAsCompleted()
            }
        }
    
    private func markMonthAsCompleted() {
            guard let year = date.year, let month = date.month else { return }
            vm.markMonthAsCompleted(year: year, month: month)
        
        NotificationCenter.default.post(name: Notification.Name("MonthCompleted"), object: nil)
            print("markMonthAsCompleted() called for \(year ?? "unknown year") \(month ?? "unknown month")")

        }
}

