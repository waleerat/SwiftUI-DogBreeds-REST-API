//
//  SearchView.swift
//  SwiftUI-DogBreeds-REST-API
//
//  Created by Waleerat Gottlieb on 2021-10-02.
//

import SwiftUI

struct SearchView: View {
    @Binding var txtSearch:String
    
    var body: some View {
        HStack {
            HStack{
                
                Image(systemName: "magnifyingglass")
                    .font(.title2)
                    .foregroundColor(Color(kForegroundColor).opacity(0.8))
                
                TextField("Search", text: $txtSearch)
                    .modifier(TextRegularModifier(fontStyle: .description))
            }
            .padding(.vertical,10)
            .padding(.horizontal)
            .background(Color.primary.opacity(0.08))
            .cornerRadius(10) 
        }
        .padding()
    }
}

