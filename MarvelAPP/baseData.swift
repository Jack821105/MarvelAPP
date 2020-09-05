//
//  baseData.swift
//  MarvelAPP
//
//  Created by 許自翔 on 2020/9/4.
//

import Foundation



//第一層物件
struct baseData:Codable {
    var code:Int
    var status:String
    var copyright:String
    var attributionText:String
    var attributionHTML:String
    var etag:String
    var data:secondData

}

//第二層物件
struct secondData:Codable {
    var offset:Int
    var limit:Int
    var total:Int
    var count:Int
    var results:[results]
}

//第三層物件
struct results:Codable{
    
    var id:Int
    var description:String
    var name:String
    var thumbnail:Thumbnail
}

struct Thumbnail:Codable{
    var path:URL
    
}
