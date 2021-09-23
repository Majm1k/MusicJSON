//
//  SearchResponse.swift
//  MusicJSON
//
//  Created by Дмитрий Рузайкин on 07.09.2021.
//

import Foundation

struct SearchResponse: Decodable { //Decodable - для конвертации данных (Грубо говоря расшифровка)
    var resultCount: Int
    var results: [Track]
}

struct Track: Decodable {
    var trackName: String
    var collectionName: String?
    var artistName: String
    var artworkUrl60: String?
}


