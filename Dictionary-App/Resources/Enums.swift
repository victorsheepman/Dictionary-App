//
//  Enums.swift
//  Dictionary-App
//
//  Created by Victor Marquez on 26/11/24.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case decodingError(Error)
    case invalidData
    case emptySearch
    
}

enum PartOfSpeech: String {
    case noun = "noun"
    case verb = "verb"
}


