//
//  DictionaryModelView.swift
//  Dictionary-App
//
//  Created by Victor Marquez on 18/10/24.
//

import Foundation
import AVFoundation

final class DictionaryModelView: ObservableObject {
    
    @Published var word: Word?
    @Published var wordSearched: String = ""
    @Published var isEmpty: Bool = false
    @Published var isNoFound: Bool = false
    
    private var player: AVPlayer?
    
    var audio: String? {
        return word?.phonetics?.first { audio in
            guard let audioValue = audio.audio else { return false }
            return !audioValue.isEmpty
        }?.audio
    }
    
    var nouns: [Definition]? {
        return word?.meanings?.first(where: { $0.partOfSpeech == PartOfSpeech.noun.rawValue })?.definitions?.prefix(3).map { $0 }
    }
    
    var verbs: [Definition]? {
        return word?.meanings?.first(where: { $0.partOfSpeech == PartOfSpeech.verb.rawValue })?.definitions?.prefix(3).map { $0 }
    }
    
    var isNoun: Bool {
        return ((word?.meanings?.contains(where: { $0.partOfSpeech == PartOfSpeech.noun.rawValue })) ?? false)
    }
    
    var isVerb: Bool {
        return ((word?.meanings?.contains(where: { $0.partOfSpeech == PartOfSpeech.verb.rawValue })) ?? false)
    }
    
    var isSynonyms: Bool {
        return word?.meanings?.contains(where: { $0.synonyms?.isEmpty == false }) ?? false
    }

    
    // Fetch word from the API
    @MainActor
    func fetchWord() async {
        reset()
        do {
            word = try await getWord().first
                        
        } catch NetworkError.emptySearch {
            isEmpty = true
            word = nil
            print(Constansts.Errors.emptySearch)
        } catch NetworkError.invalidData {
            print(Constansts.Errors.invalidData)
        } catch NetworkError.invalidURL {
            print(Constansts.Errors.invalidURL)
        } catch NetworkError.invalidResponse {
            print(Constansts.Errors.invalidResponse)
            isNoFound = true
        } catch {
            print(Constansts.Errors.unexpected)
        }
    }
    
    private func reset() -> Void {
        word = nil
        isEmpty = false
        isNoFound = false
    }
    
    private func getWord() async throws -> [WordModel] {
        guard !wordSearched.isEmpty else {
            throw NetworkError.emptySearch
        }
        
        let endpoint = Constansts.Url.base + wordSearched.lowercased()
        
        guard let url = URL(string: endpoint) else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode([WordModel].self, from: data)
        } catch {
            throw NetworkError.invalidData
        }
    }
    
    func playAudio(url: String) {
        guard let audioPath = URL(string: url) else {
            return
        }
        
        player = AVPlayer(url: audioPath)
        player?.play()
    }
}
