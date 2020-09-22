//
//  ContentView.swift
//  SecureNoteApp
//
//  Created by ramil on 22.09.2020.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            NavigationView {
                NotesHome()
            }.tabItem {
                Image(systemName: "house")
                Text("Home")
            }
            NavigationView {
                NotesSettings()
            }.tabItem {
                Image(systemName: "gear")
                Text("Settings")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
