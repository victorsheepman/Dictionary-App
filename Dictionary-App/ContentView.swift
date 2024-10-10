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
    @State private var isDarkMode: Bool = false
    
    var body: some View {
        ZStack {
            Color(isDarkMode ? Color("Black-1") : .white)
                .edgesIgnoringSafeArea(.all)
            VStack {
                header
                
                Spacer()
                
            }
            .padding()
        }
        
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
    
    var header: some View {
        HStack{
            Image(systemName: "book.closed")
                .resizable()
                .frame(width: 28, height: 32)
                .aspectRatio(contentMode: .fit)
                .foregroundColor(Color("Gray-1"))
            
            Spacer()
            
            HStack(spacing:12){
                Toggle(isOn: $isDarkMode){}
                    .toggleStyle(SwitchToggleStyle(tint: Color("Purple-1")))
                    .foregroundColor(.blue)
                Image(systemName: "moon")
                    .resizable()
                    .frame(width: 19, height: 20)
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(Color(isDarkMode ? Color("Purple-1") : Color("Gray-1")))
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
