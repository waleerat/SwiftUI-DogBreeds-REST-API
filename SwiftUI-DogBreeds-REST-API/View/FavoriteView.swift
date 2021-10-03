//
//  FavoriteView.swift
//  SwiftUI-DogBreeds-REST-API
//
//  Created by Waleerat Gottlieb on 2021-10-02.
//

import SwiftUI

struct FavoriteView: View {
    @Environment(\.presentationMode) var presentationMode
    @AppStorage("isPortrait") private var isPortrait: Bool = false
    @EnvironmentObject var dogVM: BreedVM
    
    // To show dynamic...
    @State var columns: Int = 2
    // Smooth Hero Effect...
    @Namespace var animation
    
    var body: some View { 
        VStack{
            HStack{
                Text("Favorite Breeds").modifier(TextBoldModifier(fontStyle: .title))
                Spacer()
                ButtonWithIconWithClipShapeCircleAction(systemName: "xmark") {
                    self.presentationMode.wrappedValue.dismiss()
                }
            }//: HSTACK
            .padding(.horizontal)
            
            StaggeredGrid(columns: isPortrait ? 2 : 4 ,
                          list: dogVM.contentRows.filter({ $0.isFavorite == true}),
                          content: { breedRow in
                
                // Card View...
                DogCardView(breedRow: breedRow)
                    .environmentObject(dogVM)
                    .matchedGeometryEffect(id: breedRow.id, in: animation)
                
            })
            .padding(.horizontal)
            .navigationTitle("Favorite Breeds")
            .navigationBarTitleDisplayMode(.inline)
            .animation(.easeInOut, value: columns)
        }//: VSTACK
        .onAppear() {
            columns = isPortrait ? 2 : 4
        }
        .modifier(NavigationBarHiddenModifier())
    }
}
