//
//  BreedVM.swift
//  SwiftUI-DogBreeds-REST-API
//
//  Created by Waleerat Gottlieb on 2021-10-01.
//
 

import Foundation
import Alamofire


class BreedVM : ObservableObject {
     
    @Published var contentRows: [BreedModel] = []
    @Published var selectedRow: BreedModel?
    @Published var favoriteBreeds: [BreedModel] = []
    
    init(){
        getDogBreedInfo()
    }
    
    func getDogBreedInfo(){
        
        self.getAllBreed { breedRows in
            
            for breed in breedRows {
                
                self.getBreedImages(nameOfDog: breed.nameOfDog) { breedImages in
                    // Note: - Every App loaded will have random thumbnail
                    var thumbnail: String = ""
                    if let image = breedImages.randomElement() {
                        thumbnail =  image.imageUrl
                    }
                    if breedImages.count > 0 {
                        self.contentRows.append(BreedModel(id: UUID().uuidString,
                                                            nameOfDog: breed.nameOfDog,
                                                            thumbnail: thumbnail,
                                                            isFavorite: false,
                                                            imageUrls: breedImages))
                    }
                   
                }
            }
        }
         
    }
    
    func setFavoriteByObjectId(objectId: String) {
        if let index = contentRows.firstIndex(where: { $0.id == objectId }) {
            contentRows[index].isFavorite.toggle()
        }
    }
    
}
// Note: - Featch Data from APIs

extension BreedVM {
    
    func getAllBreedsWithSubBread(completion: @escaping ([FetchBreedModel]) -> Void) {
        // Note: - Map reponse data with BreedsListAllResponse
        Alamofire.request(kBreedsListAllURL).responseObject { (response: DataResponse<BreedsListAllResponse>) in
            let breedsResponse = response.result.value
            completion(breedsResponse?.breeds ?? [])
        }
    }
    
    func getAllBreed(completion: @escaping ([FetchBreedModel]) -> Void) {
        // Note: - Map reponse data with BreedsListResponse
        Alamofire.request(kBreedsListURL).responseObject { (response: DataResponse<BreedsListResponse>) in
            let breedsResponse = response.result.value
            completion(breedsResponse?.breeds ?? [])
        }
    }

    func getBreedImages(nameOfDog: String, completion: @escaping ([FetchImageModel]) -> Void) {
        // Note: - Map reponse data with ImagesByBreedResponse
        let url = kImagesByBreedURL(for: nameOfDog)
        
        Alamofire.request(url).responseObject { (response: DataResponse<ImagesByBreedResponse>) in
            let breedsResponse = response.result.value
            completion(breedsResponse?.images ?? [])
        }
    } 
     
}
