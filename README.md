 #

 # Dog API
 ### Xcode Version 13.0
 ###### SwiftUI, Alamofire, ObjectMapper, AlamofireObjectMapper, Kingfisher

I pick [Dog-API](https://dog.ceo/dog-api/documentation/) to improve my REST API skill because I could not do it in a progrmming test some months ago. The [Alamofire](https://cocoapods.org/pods/Alamofire) and [ObjectMapper](https://cocoapods.org/pods/ObjectMapper) make my life much easier. The code is also shorter and clean.


### The idea

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
2. run pod install in Terminal

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

## Setup Scene Delegate

`Note :` The orentation is detected by Scene Delegate and Xcode 13 you may notice it doesn’t have an Info.plist file. See setup below to get  Info.plist . 

You will put `@AppStorage` to every view that you want to be rotated.
```sh
@AppStorage("isPortrait") private var isPortrait: Bool = false
``` 

1. Go to Application Scene Minifest  -> Scene Configuration -> Application Role
2. Delegate Class Name  put `$(PRODUCT_MODULE_NAME).SceneDelegate`
3. Configuration Name  put  `Default Configuration` 
4. Set `Allow Arbitrary Loads` -> `App Transport Security Settings` for requst API. 


<img src="https://github.com/waleerat/GitHub-Photos-Shared/blob/main/SwiftUI-DogBreeds-REST-API/info.png" width="70%" height="70%">


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
