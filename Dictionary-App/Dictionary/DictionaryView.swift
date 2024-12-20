//
//  DictionaryView.swift
//  Dictionary-App
//
//  Created by Victor Marquez on 26/11/24.
//

import SwiftUI

struct DictionaryView: View {
    @Binding var isDarkMode: Bool
    @StateObject private var viewModel = DictionaryOO()
    
    private var textFieldBorderColor: Color {
        if viewModel.isTextfieldEmpty {
            return Color("Orange")
        } else {
            return isDarkMode ? Color("Black-2") : Color("Gray-3")
        }
    }
    var body: some View {
        VStack {
            
            header
            
            textField
            
            mainWord
                                
            
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
                    Spacer()
                    
                }
            }
            
            
            if let nouns = viewModel.nouns {
                definitions(Constansts.sections.noun, nouns)
            }
            
            if let verbs = viewModel.verbs {
                definitions(Constansts.sections.verb, verbs)
                    .padding(.top)
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
        .overlay {
            if viewModel.isWordNoFound {
                noData
            }
        }
        .padding()
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
                    .toggleStyle(SwitchToggleStyle(tint: .purple))
                
                Image(systemName: Constansts.Icons.moon)
                    .resizable()
                    .frame(width: 19, height: 20)
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(Color(isDarkMode ? "Purple" : "Gray-1"))
            }
        }
    }
    
    var textField: some View {
        VStack {
            HStack(alignment: .top) {
                
                Image(systemName: Constansts.Icons.search)
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.purple)
                
                TextField("Enter a word...", text: $viewModel.wordSearched)
                    .keyboardType(.default)
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
            
            if viewModel.isTextfieldEmpty {
                Text(Constansts.NoData.empty)
                    .foregroundStyle(Color("Orange"))
                    .multilineTextAlignment(.leading)
                    .padding([.horizontal],0)
            }
        }
    }
    
    var mainWord: some View {
        HStack {
            VStack(alignment:.leading) {
                Text(viewModel.word?.word?.uppercased() ?? "")
                    .foregroundStyle(Color(isDarkMode ? .white : .black))
                    .font(.title.bold())
                    
                Text(viewModel.word?.phonetic ?? "")
                    .font(.subheadline)
                    .foregroundStyle(.purple)
            }
            Spacer()
            if let audio = viewModel.audio {
                Button(action: {
                    withAnimation(.spring()) {
                            viewModel.playAudio(url: audio)
                        }
                    }) {
                        Image(systemName: Constansts.Icons.play)
                            .font(.system(size: 24))
                            .foregroundColor(.purple)
                            .padding(20)
                            .background(.purple.opacity(0.25))
                            .clipShape(Circle())
                    }
            }
        }.padding(.top)
    }
    
    var noData: some View {
        VStack(spacing: 20) {
            Image(systemName: Constansts.Icons.danger)
                .resizable()
                .frame(width: 64, height: 64)
                .aspectRatio(contentMode: .fit)
                .foregroundColor(Color(isDarkMode ? Color("Purple") : Color("Gray-1")))
            
            Text(Constansts.NoData.title)
                .foregroundStyle(isDarkMode ? .white : .black)
                .font(.title3.bold())
                
            
            Text(Constansts.NoData.body)
                .font(.subheadline)
                .foregroundColor(isDarkMode ? .purple : Color("Gray-1"))
                .multilineTextAlignment(.center)
        }
    }
    

    private func definitions(_ title: String, _ definitions: [Definition]?) -> some View {
        VStack(alignment:.leading) {
            HStack{
                Text(title)
                    .font(.headline.bold().italic())
                    .foregroundStyle(Color(isDarkMode ? .white : .black))
                
                VStack{
                    Divider()
                }
            }
            
            Text(Constansts.sections.meaning)
                .font(.callout)
                .padding(.vertical)
                .foregroundColor(.gray)
            
          listItems(definitions)

        }
        
    }
    
    private func listItems(_ definitions:  [Definition]?) -> some View {
        ForEach(definitions ?? [], id: \.definition) { definition in
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

#Preview {
    DictionaryView(isDarkMode: .constant(false))
}
