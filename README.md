 #

 # Dog API
 ### Xcode Version 13.0
 ###### SwiftUI, Alamofire, ObjectMapper, AlamofireObjectMapper, Kingfisher

I pick [Dog-API](https://dog.ceo/dog-api/documentation/) to improve my REST API skill because I could not do it in a progrmming test. I had always kept it in my mind that I would improve it one day. 

### The idea is that App 

1. Featch data form Dog-API with `Alamofire` only when the App loaded and use `ObjectMapper` save to Model object `[BreedModel]`. 
2. Use `@EnvironmentObject var dogVM: BreedVM` to pass values between views. 
3. Check orientation mode with `SceneDelegate` then save to `@AppStorage`. 
4. Use `StaggeredGrid` helper view for the better GridView.

 ### SwiftUI-DogBreeds-REST-API

 <img src="https://github.com/waleerat/GitHub-Photos-Shared/blob/main/SwiftUI-DogBreeds-REST-API/dog-1.png" width="30%" height="30%"> |
 <img src="https://github.com/waleerat/GitHub-Photos-Shared/blob/main/SwiftUI-DogBreeds-REST-API/dog-2.png" width="30%" height="30%"> |
 <img src="https://github.com/waleerat/GitHub-Photos-Shared/blob/main/SwiftUI-DogBreeds-REST-API/dog-4.png" width="30%" height="30%"> |


## How to setup project
1. Clone project to your Mac
2. Setup firebase  [See](https://firebase.google.com/docs/ios/setup)
3. Enable Firebase and Firestore [See](https://console.firebase.google.com/)
4. import your own GoogleService-Info.plist to the project
5. run pod install in Terminal

```sh
 run pod install
```

After you install you will see `Podfile`

```sh
  pod 'Alamofire', '~> 4.7'
  pod 'ObjectMapper', '~> 3.5'
  pod 'Kingfisher', '~> 6.0'
  pod 'AlamofireObjectMapper', '~> 5.2'
```


## Check these files

#### Constants.swift

```sh
public let baseURL: URL = URL(string: "https://dog.ceo")! //This will never fail
public let apiURL: URL = baseURL.appendingPathComponent("api")

public let kBreedsListURL: URL = apiURL.appendingPathComponent("breeds/list")
public let kBreedsListAllURL: URL = apiURL.appendingPathComponent("breeds/list/all")
public func kImagesByBreedURL(for breedName: String) -> URL {
    return apiURL.appendingPathComponent("/breed/\(breedName)/images")
}

```

####  BreedsModel.swift
 
```sh
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
```
#### ObjectMapper.swift

```sh 

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

```

#### BreedVM.swift

```sh
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
```
