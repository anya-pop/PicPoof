//
//  DeletionView.swift
//  PicPoof
//
//  Created by Aleks Bursac and Anya Popova on 2024-12-03.
//

import SwiftUI
import Photos

struct ConfirmationView: View {
    @Environment(\.rootPresentationMode) var rootPresentationMode
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.dismiss) private var dismiss
    @Binding var deletionList: Set<String>
    @State var photos: [PHAsset]
    let date: (year: String?, month: String?)

    var body: some View {
        VStack {
            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3)) {
                    ForEach(photos, id: \.localIdentifier) { photo in
                        ZStack {
                            PhotoThumbnailView(asset: photo)
                                .scaledToFill()
                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 200)
                                .clipped()
                                .overlay(
                                    deletionList.contains(photo.localIdentifier) ?
                                        Color.blue.opacity(0.5) : Color.clear
                                )
                            if deletionList.contains(photo.localIdentifier) {
                                Image(systemName: "trash")
                                    .font(.title)
                                    .foregroundColor(.white)
                            }
                        }
                        .clipped()
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if deletionList.contains(photo.localIdentifier) {
                                deletionList.remove(photo.localIdentifier)
                            } else {
                                deletionList.insert(photo.localIdentifier)
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }

            Button {
                performDeletion()
            } label: {
                Text("DELETE ") +
                Text("\(deletionList.count)").foregroundColor(.blue) +
                Text(" ITEMS?")
            }
            .font(
                Font.custom("Montserrat", size: 30)
                    .weight(.bold)
            )
            .foregroundColor(.black)
            .padding(.horizontal, 15)
            .padding(.vertical, 5)
            .frame(alignment: .center)
            .cornerRadius(5)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .inset(by: 0.5)
                    .stroke(.black, lineWidth: 1)
            )
        }
        .padding(.bottom, 32)
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
        }
        .navigationBarBackButtonHidden(true)
//        .onAppear {
//            print("confirmation view:")
//            print(photos)
//            print(deletionList)
//        }
    }

    private func performDeletion() {
        // alert on successful delete and how much storage saved
        // then persist some statistics to coredata
        print("Performing deletion for \(deletionList.count) items.")
        NotificationCenter.default.post(name: Notification.Name("DismissSwipingView"), object: nil)
        presentationMode.wrappedValue.dismiss()
    }
}

//#Preview {
//    ConfirmationView()
//}
