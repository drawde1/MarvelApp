//
//  CharacterModels.swift
//  marvel
//
//  Created by Rave Bizz on 7/14/21.
//

import Foundation

struct CharacterModel: Decodable{
    let data: CharacterData
}
struct CharacterData: Decodable{
    let results: [CharacterResults]
}
struct CharacterResults: Decodable{
    let name: String?
    let description: String?
    let thumbnail: ImageThumbnail
}
struct ImageThumbnail: Decodable{
    enum CodingKeys: String, CodingKey {
            case path
            case ext = "extension"
        }
    let path: String?
    let ext: String?
}
