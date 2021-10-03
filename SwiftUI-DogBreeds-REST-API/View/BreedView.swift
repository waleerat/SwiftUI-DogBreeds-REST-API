//
//  BreedView.swift
//  SwiftUI-DogBreeds-REST-API
//
//  Created by Waleerat Gottlieb on 2021-10-02.
//

import SwiftUI
import Kingfisher

struct BreedView: View {
    @Environment(\.presentationMode) var presentationMode
    @AppStorage("isPortrait") private var isPortrait: Bool = false
    @EnvironmentObject var dogVM: BreedVM
    
    // To show dynamic...
    @State var columns: Int = 2
    
    var body: some View {
        ZStack(alignment: .top){
            Color(kBackgroundColor)
                .ignoresSafeArea(.all)
            
            if let breedRow = dogVM.selectedRow {
                VStack{
                    HStack{
                        ButtonWithIconWithClipShapeCircleAction(systemName: "arrow.backward") {
                            self.presentationMode.wrappedValue.dismiss()
                        }
                        Text(breedRow.nameOfDog.capitalizingFirstLetter())
                            .modifier(TextBoldModifier(fontStyle: .title))
                        Spacer()
                        
                    }//: VSTACK
                    .padding(.horizontal)
                    
                    StaggeredGrid(columns: isPortrait ? 2 : 4 ,
                                  list: breedRow.imageUrls,
                                  content: { imageRow in
                        
                        // Card View...
                        KFImage(URL(string: imageRow.imageUrl))
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                        
                    })
                    .padding(.horizontal)
                    .animation(.easeInOut, value: columns)
                    
                }//: VSTACK
                .onAppear() {
                    columns = isPortrait ? 2 : 4
                }
            } else {
                
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                } , label: {
                    VStack {
                        Image(systemName: "info")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .foregroundColor(Color.yellow)
                        Text("Something went wrong!!").modifier(TextBoldModifier(fontStyle: .header))
                    }
                    
                })
            }
            
        }//: ZSTACK
        .modifier(NavigationBarHiddenModifier())
    }
}

