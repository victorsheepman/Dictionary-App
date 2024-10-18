//
//  ContentView.swift
//  Dictionary-App
//
//  Created by Victor Marquez on 9/10/24.
//

import SwiftUI
import AVKit


struct ContentView: View {
    
    
    @State private var word: Word?
    @State private var isDarkMode: Bool = false
    @State private var wordSearched: String = ""
    @State private var isEmpty: Bool = false
    @State private var player: AVPlayer?
    @State private var isNoFound: Bool = false
    
    @StateObject private var viewModel = DictionaryModelView()
    
    
   
    private var textFieldBorderColor: Color {
        if isEmpty {
            return Color("Orange")
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
            
                mainWord
                
                if viewModel.isNoun {
                    noun
                }
    
                if viewModel.isVerb {
                    verb
                }
                
                if viewModel.isNoFound {
                    noData
                }
                if let url = viewModel.word?.sourceUrls?.first {
                    
                    Divider()
                    
                    VStack(alignment: .leading) {
                        Text("Source")
                            .font(.title3)
                            .foregroundColor(Color("Gray-1"))
                            .underline()
                        Link(url, destination: URL(string: url)!)
                    }
                }
                
                
                Spacer()
            }
            .padding()
        }
    }
    
    var header: some View {
        HStack{
            Image(systemName: Constansts.Icons.book)
                .resizable()
                .frame(width: 28, height: 32)
                .aspectRatio(contentMode: .fit)
                .foregroundColor(Color("Gray-1"))
            
            Spacer()
            
            HStack(spacing:12){
                Toggle(isOn: $isDarkMode){}
                    .toggleStyle(SwitchToggleStyle(tint: Color("Purple")))
                    .foregroundColor(.blue)
                Image(systemName: Constansts.Icons.moon)
                    .resizable()
                    .frame(width: 19, height: 20)
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(Color(isDarkMode ? Color("Purple") : Color("Gray-1")))
            }
            
            
        }
        
    }
    
    var textField: some View {
        VStack {
            HStack(alignment: .top) {
                Image(systemName: Constansts.Icons.search)
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(Color("Purple"))
                TextField("", text: $viewModel.wordSearched)
                    .onSubmit {
                        Task {
                            await viewModel.fetchWord()
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
            if viewModel.isEmpty {
                Text(Constansts.NoData.empty)
                    .foregroundStyle(Color("Orange"))
                    .multilineTextAlignment(.leading)
                    .padding([.horizontal],0)
            }
        }
    }
    
    var mainWord: some View {
        HStack{
            VStack(alignment:.leading){
                Text(viewModel.word?.word?.uppercased() ?? "")
                    .foregroundStyle(Color(isDarkMode ? .white : Color("Black-3")))
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .font(.title)
                    .bold()
                Text(viewModel.word?.phonetic ?? "")
                    .font(.subheadline)
                    .foregroundStyle(Color("Purple"))
            }
            Spacer()
            if let audio = viewModel.audio {
                Button(
                    action: {
                        
                        viewModel.playAudio(url: audio)
                        
                    }) {
                        Image(systemName: Constansts.Icons.play)
                            .font(.system(size: 24))
                            .foregroundColor(Color("Purple"))
                            .padding(20)
                            .background(Color("Purple").opacity(0.25))
                            .clipShape(Circle())
                        
                    }
            }
            
        }.padding(.top)
    }
    
    
    var noun: some View {
        VStack(alignment:.leading) {
            HStack{
                Text(Constansts.sections.noun)
                    .bold()
                    .font(.footnote)
                    .foregroundStyle(Color(isDarkMode ? .white : Color("Black-3")))
                VStack{
                    Divider()
                }
            }
            
            Text(Constansts.sections.meaning)
                .font(.title3)
                .padding(.vertical)
                .foregroundColor(Color("Gray-1"))
                
            ForEach(viewModel.nouns ?? [], id: \.definition) { definition in
                if let def = definition.definition {
                    Label {
                        Text(def)
                            .foregroundStyle(Color(isDarkMode ? .white : Color("Black-3")))
                    } icon: {
                        Image(systemName:Constansts.Icons.circle)
                            .resizable()
                            .frame(width: 5, height: 5)
                            .foregroundColor(Color("Purple"))
                    }
                }
            }
            if let synonym = viewModel.word?.meanings?.first?.synonyms?.first {
                HStack{
                    Text(Constansts.sections.synonyms)
                        .font(.subheadline)
                        .padding(.vertical)
                        .foregroundColor(Color("Gray-1"))
                    
                    Text(synonym)
                        .font(.subheadline)
                        .bold()
                        .foregroundStyle(Color("Purple"))
                    
                }

            }
        }
    }
    
    var verb: some View {
        VStack(alignment:.leading) {
            HStack{
                Text(Constansts.sections.verb)
                    .bold()
                    .font(.footnote)
                    .foregroundStyle(Color(isDarkMode ? .white : Color("Black-3")))
                VStack{
                    Divider()
                       
                }
            }
            
            Text(Constansts.sections.meaning)
                .font(.title3)
                .padding(.vertical)
                .foregroundColor(Color("Gray-1"))
                
            ForEach(viewModel.verbs ?? [], id: \.definition) { definition in
                if let def = definition.definition {
                    Label {
                        Text(def)
                            .foregroundStyle(Color(isDarkMode ? .white : Color("Black-3")))
                    } icon: {
                        Image(systemName: Constansts.Icons.circle)
                            .resizable()
                            .frame(width: 5, height: 5)
                            .foregroundColor(Color("Purple"))
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
    
    var noData: some View {
        VStack{
            Image(systemName: Constansts.Icons.danger)
                .resizable()
                .frame(width: 64, height: 64)
                .aspectRatio(contentMode: .fit)
                .foregroundColor(Color(isDarkMode ? Color("Purple") : Color("Gray-1")))
            Text(Constansts.NoData.title)
                .foregroundStyle(Color(isDarkMode ? .white : Color("Black-3")))
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .font(.system(size: 20))
                .padding(.top)
            
            Text(Constansts.NoData.body)
                .font(.subheadline)
                .foregroundColor(Color(isDarkMode ? Color("Purple") : Color("Gray-1")))
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding(.top)
                
        }
    }
}

#Preview {
    ContentView()
}
