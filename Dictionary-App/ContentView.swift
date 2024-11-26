//
//  ContentView.swift
//  Dictionary-App
//
//  Created by Victor Marquez on 9/10/24.
//

import SwiftUI
import AVKit


struct ContentView: View {
    
    @State private var isDarkMode: Bool = false

    var body: some View {
        ZStack {
            Color(isDarkMode ? Color("Black-1") : .white)
                .edgesIgnoringSafeArea(.all)
            DictionaryView(isDarkMode: $isDarkMode)
        }.ignoresSafeArea(.keyboard, edges: .all)
    }
    
}

#Preview {
    ContentView()
}
