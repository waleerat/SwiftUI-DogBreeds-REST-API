//
//  ButtonIconAction.swift
//  SwiftUI-DogBreeds-REST-API
//
//  Created by Waleerat Gottlieb on 2021-10-02.
//

import SwiftUI

struct ButtonIconAction: View {
    var systemName:String
    @State var foregroundColor: Color = Color(kForegroundColor)
    
    var action: () -> Void
    var body: some View {
        Button(action: action , label: {
            Image(systemName: systemName)
                .foregroundColor(foregroundColor)
        })
    }
}
