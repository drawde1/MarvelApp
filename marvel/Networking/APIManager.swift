//
//  APIManager.swift
//  marvel
//
//  Created by Rave Bizz on 7/14/21.
//
import var CommonCrypto.CC_MD5_DIGEST_LENGTH
import func CommonCrypto.CC_MD5
import typealias CommonCrypto.CC_LONG

import Foundation

class APIManager{
    
    static let shared = APIManager()
    
    func getTimeStamp() -> String {
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        var timestamp = format.string(from: date)
        timestamp = timestamp.replacingOccurrences(of: " ", with: "")
        return timestamp
    }
    
    func MD5(string: String) -> Data{
        let length = Int(CC_MD5_DIGEST_LENGTH)
             let messageData = string.data(using:.utf8)!
             var digestData = Data(count: length)

             _ = digestData.withUnsafeMutableBytes { digestBytes -> UInt8 in
                 messageData.withUnsafeBytes { messageBytes -> UInt8 in
                     if let messageBytesBaseAddress = messageBytes.baseAddress, let digestBytesBlindMemory = digestBytes.bindMemory(to: UInt8.self).baseAddress {
                         let messageLength = CC_LONG(messageData.count)
                         CC_MD5(messageBytesBaseAddress, messageLength, digestBytesBlindMemory)
                     }
                     return 0
                 }
             }
             return digestData
         }
    
    func getHash(ts: String) -> String {
        let md5Data =  MD5(string: "\(ts)\(APIKEYPRIVATE)\(APIKEYPUBLIC)")
        let md5Hex =  md5Data.map { String(format: "%02hhx", $0) }.joined()
        return md5Hex
    }
    func contructMarvelUrl() -> URL?{
        let timeStamp = self.getTimeStamp()
        let hash = self.getHash(ts: timeStamp)
        
        var MarvelUrlCompoent = URLComponents()
        
        MarvelUrlCompoent.scheme = "https"
        MarvelUrlCompoent.host = "gateway.marvel.com"
        MarvelUrlCompoent.port = 443
        MarvelUrlCompoent.path = "/v1/public/characters"
        MarvelUrlCompoent.queryItems = [URLQueryItem(name: "apikey", value: APIKEYPUBLIC), URLQueryItem(name: "ts", value: timeStamp), URLQueryItem(name:"hash", value: hash)]
        return MarvelUrlCompoent.url
    }
    
    func getData(from url: URL, completion: @escaping (Data) -> Void) {
       let task = URLSession.shared.dataTask(with: url, completionHandler:{
            data,response,error in
            guard let data = data else {
                print("APIManger failed to recive data")
                return
            }
            completion(data)
        })
        task.resume()
    }
    
}
