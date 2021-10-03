//
//  BreedsModel.swift
//  SwiftUI-DogBreeds-REST-API
//
//  Created by Waleerat Gottlieb on 2021-10-01.
//

import Foundation

struct FetchImageModel: Identifiable,Hashable {
    var id: String
    let imageUrl: String
}

struct FetchBreedModel: Identifiable,Hashable {
    var id: String
    var nameOfDog: String
}

 
struct BreedModel: Identifiable, Hashable {
    var id: String
    var nameOfDog: String
    var thumbnail: String
    var isFavorite: Bool
    var imageUrls: [FetchImageModel]
}
