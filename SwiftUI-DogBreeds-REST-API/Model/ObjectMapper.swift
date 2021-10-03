//
//  ObjectMapper.swift
//  SwiftUI-DogBreeds-REST-API
//
//  Created by Waleerat Gottlieb on 2021-10-01.
//


import SwiftUI
import ObjectMapper
import AlamofireObjectMapper

// Note: - Map response form https://dog.ceo/api/breeds/list/all
class BreedsListAllResponse: Mappable {
    
    var status: String = ""
    var breeds: [FetchBreedModel] = []
    
    required init?(map: Map){
        
        if let breedsStr: [String:Any] = try? map.value("message") {
            for breed in breedsStr {
                    
                    let subBreedItems = breed.value as! [String]
                    
                    if (subBreedItems.count > 0) {
                        for item in subBreedItems {
                            breeds.append(FetchBreedModel(id: UUID().uuidString, nameOfDog: "\(breed.key) \(item)"))
                        }
                    } else {
                        breeds.append(FetchBreedModel(id: UUID().uuidString, nameOfDog: breed.key))
                    }
            }
        }
    }
    
    func mapping(map: Map) {
        status <- map["status"]
    }
}

// Note: - Map response form https://dog.ceo/api/breeds/list/
struct BreedsListResponse: Mappable {

    var breeds: [FetchBreedModel] = []
    var status: String = ""

    init?(map: Map) {
      
        if let breedsStr: [String] = try? map.value("message") {
            self.breeds = breedsStr.map { FetchBreedModel(id: UUID().uuidString, nameOfDog: $0) }
        }
         
    }

    mutating func mapping(map: Map) {
        status <- map["status"]
    }
}

// Note: - Map response from https://dog.ceo/api/breed/affenpinscher/images
struct ImagesByBreedResponse: Mappable {

    var images: [FetchImageModel] = []
    var status: String = ""

    init?(map: Map) {
        if let imagesStr: [String] = try? map.value("message") {
            self.images = imagesStr.map { FetchImageModel(id: UUID().uuidString, imageUrl: $0) }
        }
    }

    mutating func mapping(map: Map) {
        status <- map["status"]
    }
}

