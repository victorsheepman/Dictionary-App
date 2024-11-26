//
//  DictionaryOO.swift
//  Dictionary-App
//
//  Created by Victor Marquez on 26/11/24.
//

import Foundation
import AVFoundation


final class DictionaryOO: ObservableObject {
    
    @Published var word: DictionaryDO?
    @Published var wordSearched: String = ""
    @Published var isTextfieldEmpty: Bool = false
    @Published var isWordNoFound: Bool = false
   
    private var player: AVPlayer?
    
    var audio: String? {
        word?.phonetics?.first { audio in
            guard let audioValue = audio.audio else { return false }
            return !audioValue.isEmpty
        }?.audio
    }
    
    var nouns: [Definition]? {
        word?.meanings?.first(where: {
            $0.partOfSpeech == PartOfSpeech.noun.rawValue
        })?
        .definitions?.prefix(3).map { $0 }
    }
    
    var verbs: [Definition]? {
        word?.meanings?.first(where: {
            $0.partOfSpeech == PartOfSpeech.verb.rawValue
        })?
        .definitions?.prefix(3).map { $0 }
    }
    
    
    func playAudio(url: String) {
        guard let audioPath = URL(string: url) else {
            return
        }
        
        player = AVPlayer(url: audioPath)
        player?.play()
    }

    func fetchWord() async {
        reset()
        do {
            word = try await fetchWordData().first
                        
        } catch NetworkError.emptySearch {
            isTextfieldEmpty = true
            word = nil
            print(Constansts.Errors.emptySearch)
        } catch NetworkError.invalidData {
            print(Constansts.Errors.invalidData)
        } catch NetworkError.invalidURL {
            print(Constansts.Errors.invalidURL)
        } catch NetworkError.invalidResponse {
            print(Constansts.Errors.invalidResponse)
            isWordNoFound = true
        } catch {
            print(Constansts.Errors.unexpected)
        }
    }
        
    private func fetchWordData() async throws -> [DictionaryDO] {
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
            return try decoder.decode([DictionaryDO].self, from: data)
        } catch {
            throw NetworkError.invalidData
        }
    }
    
    private func reset() -> Void {
        word = nil
        isTextfieldEmpty = false
        isWordNoFound = false
    }
}
