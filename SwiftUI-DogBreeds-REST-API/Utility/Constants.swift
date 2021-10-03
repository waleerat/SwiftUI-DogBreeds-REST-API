//
//  Constants.swift
//  SwiftUI-DogBreeds-REST-API
//
//  Created by Waleerat Gottlieb on 2021-10-01.
//

import Foundation


public let kForegroundColor = "foreground"
public let kBackgroundColor = "background"


public let baseURL: URL = URL(string: "https://dog.ceo")! //This will never fail
public let apiURL: URL = baseURL.appendingPathComponent("api")

public let kBreedsListURL: URL = apiURL.appendingPathComponent("breeds/list")
public let kBreedsListAllURL: URL = apiURL.appendingPathComponent("breeds/list/all")
public func kImagesByBreedURL(for breedName: String) -> URL {
    return apiURL.appendingPathComponent("/breed/\(breedName)/images")
}
