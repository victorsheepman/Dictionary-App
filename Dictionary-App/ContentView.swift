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
    case emptySearch
    
}

struct ContentView: View {
    
    @State private var word: Word?
    @State private var isDarkMode: Bool = false
    @State private var wordSearched: String = ""
    @State private var isEmpty: Bool = false
    
    
    private var textFieldBorderColor: Color {
        if isEmpty {
            return Color("Orange-1")
        } else {
            return isDarkMode ? Color("Black-2") : Color("Gray-3")
        }
    }

    var body: some View {
        ZStack {
            Color(isDarkMode ? Color("Black-1") : .white)
                .edgesIgnoringSafeArea(.all)
            VStack {
                header
                
                textField
                Spacer()
                
            }
            .padding()
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
    
    var textField: some View {
        VStack {
            HStack(alignment: .top) {
                Image(systemName: "magnifyingglass")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(Color("Purple-1"))
                TextField("", text: $wordSearched)
                    .onSubmit {
                        Task {
                            await fetchWord()
                        }
                    }
            }
            .padding()
            .overlay(
                
                RoundedRectangle(cornerRadius: 16)
                    .stroke(textFieldBorderColor, lineWidth: 1)
                
                
            )
            .background(isDarkMode ? Color("Black-2") : Color("Gray-3"))
            .cornerRadius(16)
            .padding(.top)
            if isEmpty {
                Text("Whoops, can’t be empty…")
                    .foregroundStyle(Color("Orange-1"))
                    .multilineTextAlignment(.leading)
                    .padding([.horizontal],0)
            }
        }
    }
    
    private func fetchWord() async {
        do {
            word = try await getWord()
            isEmpty = false
            print(word ?? "")
        } catch NetworkError.emptySearch {
            isEmpty = true
            print("Error: La búsqueda está vacía.")
        } catch NetworkError.invalidData {
            print("Error: Datos inválidos")
        } catch NetworkError.invalidURL {
            print("Error: La URL es inválida.")
        } catch NetworkError.invalidResponse {
            print("Error: La respuesta del servidor no es válida.")
        } catch {
            print("Error: Inesperado")
        }
    }
    
    
    private func getWord() async throws -> [WordModel] {
        
        guard !wordSearched.isEmpty else {
            throw NetworkError.emptySearch
        }
        
        let endpoint = "https://api.dictionaryapi.dev/api/v2/entries/en/\(wordSearched.lowercased())"
        
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
