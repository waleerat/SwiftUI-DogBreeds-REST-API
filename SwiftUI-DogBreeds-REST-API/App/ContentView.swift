//
//  ContentView.swift
//  SwiftUI-DogBreeds-REST-API
//
//  Created by Waleerat Gottlieb on 2021-10-01.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        
        NavigationView {
            BreedsListView()
                .modifier(NavigationBarHiddenModifier())
        }.navigationViewStyle(StackNavigationViewStyle())
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
