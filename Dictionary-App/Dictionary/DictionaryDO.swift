//
//  DictionaryDO.swift
//  Dictionary-App
//
//  Created by Victor Marquez on 26/11/24.
//

import Foundation

struct DictionaryDO: Codable {
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

