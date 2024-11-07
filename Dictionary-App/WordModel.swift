//
//  WordModel.swift
//  Dictionary-App
//
//  Created by Victor Marquez on 9/10/24.
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

// MARK: - WordModel

struct WordModel: Codable {
    let word, phonetic: String?
    let phonetics: [Phonetic]?
    let origin: String?
    let meanings: [Meaning]?
    let sourceUrls: [String]?
}

// MARK: - Meaning
struct Meaning: Codable {
    let partOfSpeech: String?
    let definitions: [Definition]?
    let synonyms: [String]?
}

// MARK: - Definition
struct Definition: Codable {
    let definition, example: String?
    let synonyms, antonyms: [JSONAny]?
}

// MARK: - Phonetic
struct Phonetic: Codable {
    let text, audio: String?
}

typealias Word = WordModel


class JSONCodingKey: CodingKey {
    let key: String

    required init?(intValue: Int) {
            return nil
    }

    required init?(stringValue: String) {
            key = stringValue
    }

    var intValue: Int? {
            return nil
    }

    var stringValue: String {
            return key
    }
}

