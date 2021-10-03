//
//  DogCardView.swift
//  SwiftUI-DogBreeds-REST-API
//
//  Created by Waleerat Gottlieb on 2021-10-02.
//

import SwiftUI
import Kingfisher

struct DogCardView: View {
    @EnvironmentObject var dogVM: BreedVM
    
    @State var breedRow:BreedModel
    @State var selectionLink:String?
    @State var isCheck:Bool = false
    
    var body: some View {
        VStack {
            ZStack(alignment: .bottom) {
                if !breedRow.thumbnail.isEmpty {
                    KFImage(URL(string: breedRow.thumbnail))
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
                
                VStack(alignment: .leading) {
                    Text(breedRow.nameOfDog.capitalizingFirstLetter())
                        .modifier(TextBoldModifier(fontStyle: .description))
                        .modifier(ClipShapeModifier())
                    Spacer()
                    HStack{
                        HStack{
                            ButtonIconAction(systemName: "photo.on.rectangle", action: {
                                dogVM.selectedRow = breedRow
                                selectionLink = "BreedView"
                            })
                            Text("\(breedRow.imageUrls.count)")
                                .modifier(TextRegularModifier(fontStyle: .caption))
                        }.modifier(ClipShapeModifier())
                        
                        Spacer()
                        Button(action: {
                            dogVM.setFavoriteByObjectId(objectId: breedRow.id)
                        } , label: {
                            Image(systemName: "star.circle.fill")
                                .foregroundColor(breedRow.isFavorite ? Color.yellow : Color(kForegroundColor))
                        })
                        .padding(2)
                        .background(Color(kBackgroundColor).opacity(0.3))
                        .clipShape(Capsule())
                    }
                    
                    
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
              //  .background(Color(kBackgroundColor).opacity(0.6))
                //.clipShape(Capsule())
            }.cornerRadius(10)
            NavigationLink(destination: BreedView().environmentObject(dogVM), tag: "BreedView", selection: $selectionLink) { EmptyView() }
        }
    }
    
    // Note: - Helper function

}
