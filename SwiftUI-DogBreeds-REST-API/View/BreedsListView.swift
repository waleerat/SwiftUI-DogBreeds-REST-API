//
//  DogBreedsListView.swift
//  SwiftUI-DogBreeds-REST-API
//
//  Created by Waleerat Gottlieb on 2021-10-01.
//

import SwiftUI
import Kingfisher

struct BreedsListView: View { 
    @AppStorage("isPortrait") private var isPortrait: Bool = false
   
    @ObservedObject var dogVM = BreedVM()
    @State var selectionLink:String?
    
    @State var txtSearch:String = ""
    @State var isSearch:Bool = false
    // To show dynamic...
    @State var columns: Int = 2
    // Smooth Hero Effect...
    @Namespace var animation
    
    
    var body: some View {
        
            VStack(spacing: 10) {
                HStack{
                    Image("logo")
                        .renderingMode(.original)
                        .resizable()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                    
                    Text("Dog's Breeds").modifier(TextBoldModifier(fontStyle: .title))
                    Spacer()
                    
                    HStack {
                        ButtonIconAction(systemName: "star", action: {
                            selectionLink = "BreedView"
                        })
                        ButtonIconAction(systemName: "magnifyingglass", action: {
                            isSearch.toggle()
                            if !isSearch {
                                txtSearch = ""
                            }
                        })
                    }
                }//: HSTACK
                .padding(.horizontal)
                
                if isSearch {
                    SearchView(txtSearch: $txtSearch)
                } 
                
                StaggeredGrid(columns: isPortrait ? 2 : 4 ,
                              list: dogVM.contentRows.filter({ $0.nameOfDog.contains(txtSearch.lowercased()) || txtSearch.isEmpty}),
                              content: { breedRow in
                    
                    // Card View...
                    DogCardView(breedRow: breedRow)
                        .environmentObject(dogVM)
                        .matchedGeometryEffect(id: breedRow.id, in: animation)
                    
                })
                .padding(.horizontal)
                .animation(.easeInOut, value: columns)
                
                NavigationLink(destination: FavoriteView().environmentObject(dogVM), tag: "BreedView", selection: $selectionLink) { EmptyView() }
                Spacer()
            }//: VSTACK
            .onAppear() {
                columns = isPortrait ? 2 : 4
            }
            .modifier(NavigationBarHiddenModifier())
        
    }//: BODY
    
}
 
struct DogBreedsListView_Previews: PreviewProvider {
    static var previews: some View {
        BreedsListView()
    }
}
