//
//  ContentView.swift
//  Dictionary-App
//
//  Created by Victor Marquez on 9/10/24.
//

import SwiftUI

enum NetworkError: Error {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case decodingError(Error)
    case invalidData
}

struct ContentView: View {
    
    @State private var word: Word?
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            
            Text("Hello, world!")
            
        }
        .padding()
        .task {
            do {
                word = try await getWord()
                print(word ?? "")
            } catch NetworkError.invalidData {
                print("Error: Invalid Data")
            } catch NetworkError.invalidURL {
                print("Error: La URL es inválida.")
            } catch NetworkError.invalidResponse {
                print("Error: La respuesta del servidor no es válida.")
            } catch {
                print("Error: Unexpected")
            }
        }
    }
    
    func getWord() async throws -> [WordModel] {
        let endpoint = "https://api.dictionaryapi.dev/api/v2/entries/en/hello"
        
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
}

#Preview {
    ContentView()
}
