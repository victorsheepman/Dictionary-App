//
//  ContentView.swift
//  Dictionary-App
//
//  Created by Victor Marquez on 9/10/24.
//

import SwiftUI
import AVKit

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


struct ContentView: View {
    
    @State private var word: Word?
    @State private var isDarkMode: Bool = false
    @State private var wordSearched: String = ""
    @State private var isEmpty: Bool = false
    @State private var player: AVPlayer?
    
    private var textFieldBorderColor: Color {
        if isEmpty {
            return Color("Orange-1")
        } else {
            return isDarkMode ? Color("Black-2") : Color("Gray-3")
        }
    }
    
    var audio: String? {
        return word?.phonetics?.first { audio in
            guard let audioValue = audio.audio else { return false }
            return !audioValue.isEmpty
        }?.audio
    }
    
    var nouns: [Definition]? {
        return word?.meanings?.first(where: {$0.partOfSpeech == PartOfSpeech.noun.rawValue })?.definitions?.prefix(3).map { $0 }
    }
    
    var verbs: [Definition]? {
        return word?.meanings?.first(where: {$0.partOfSpeech == PartOfSpeech.verb.rawValue })?.definitions?.prefix(3).map { $0 }
    }
    
    var isNoun:Bool {
        return ((word?.meanings?.contains(where: { $0.partOfSpeech == PartOfSpeech.noun.rawValue })) ?? false)
    }
    
    var isVerb:Bool {
        return ((word?.meanings?.contains(where: { $0.partOfSpeech == PartOfSpeech.verb.rawValue })) ?? false)
    }

    
    
    var body: some View {
        ZStack {
            Color(isDarkMode ? Color("Black-1") : .white)
                .edgesIgnoringSafeArea(.all)
            VStack {
                header
                
                textField
            
                mainWord
                if isNoun {
                    noun
                }
    
                if isVerb {
                    verb
                }
    

                
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
    
    var mainWord: some View {
        HStack{
            VStack(alignment:.leading){
                Text(word?.word?.uppercased() ?? "")
                    .foregroundStyle(Color(isDarkMode ? .white : Color("Black-3")))
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .font(.title)
                    .bold()
                Text(word?.phonetic ?? "")
                    .font(.subheadline)
                    .foregroundStyle(Color("Purple-1"))
            }
            Spacer()
            if let audio = audio {
                Button(
                    action: {
                        
                        playAudio(url: audio)
                        
                    }) {
                        Image(systemName: "play.fill")
                            .font(.system(size: 24))
                            .foregroundColor(Color("Purple-1"))
                            .padding(20)
                            .background(Color("Purple-1").opacity(0.25))
                            .clipShape(Circle())
                        
                    }
            }
            
        }.padding(.top)
    }
    
    
    var noun: some View {
        VStack(alignment:.leading) {
            HStack{
               Text("noun")
                    .bold()
                    .font(.footnote)
                    .foregroundStyle(Color(isDarkMode ? .white : Color("Black-3")))
                VStack{
                    Divider()
                }
            }
            
            Text("Meaning")
                .font(.title3)
                .padding(.vertical)
                .foregroundColor(Color("Gray-1"))
                
            ForEach(nouns ?? [], id: \.definition) { definition in
                if let def = definition.definition {
                    Label {
                        Text(def)
                            .foregroundStyle(Color(isDarkMode ? .white : Color("Black-3")))
                    } icon: {
                        Image(systemName:"circle.fill")
                            .resizable()
                            .frame(width: 5, height: 5)
                            .foregroundColor(Color("Purple-1"))
                    }
                }
            }
            if let synonym = word?.meanings?.first?.synonyms?.first {
                HStack{
                    Text("Synonyms")
                        .font(.subheadline)
                        .padding(.vertical)
                        .foregroundColor(Color("Gray-1"))
                    
                    Text(synonym)
                        .font(.subheadline)
                        .bold()
                        .foregroundStyle(Color("Purple-1"))
                    
                }

            }
        }
    }
    
    var verb: some View {
        VStack(alignment:.leading) {
            HStack{
               Text("verb")
                    .bold()
                    .font(.footnote)
                    .foregroundStyle(Color(isDarkMode ? .white : Color("Black-3")))
                VStack{
                    Divider()
                       
                }
            }
            
            Text("Meaning")
                .font(.title3)
                .padding(.vertical)
                .foregroundColor(Color("Gray-1"))
                
            ForEach(verbs ?? [], id: \.definition) { definition in
                if let def = definition.definition {
                    Label {
                        Text(def)
                            .foregroundStyle(Color(isDarkMode ? .white : Color("Black-3")))
                    } icon: {
                        Image(systemName:"circle.fill")
                            .resizable()
                            .frame(width: 5, height: 5)
                            .foregroundColor(Color("Purple-1"))
                    }
                }
                
                if let example = definition.example {
                    Text(example)
                        .foregroundStyle(Color("Gray-1"))
                        .padding([.top, .horizontal])
                }
                
            }
           
        }
    }
    
    
    private func fetchWord() async {
        do {
            word = try await getWord().first
            isEmpty = false
            
        } catch NetworkError.emptySearch {
            isEmpty = true
            word = nil
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
    
    private func playAudio(url: String) {
        
        guard let audioPath = URL(string: url) else {
            return
        }
        
        player = AVPlayer(url: audioPath)
        
        player?.play()
    }
    
    
    
}

#Preview {
    ContentView()
}
