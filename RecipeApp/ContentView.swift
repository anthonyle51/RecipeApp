//
//  ContentView.swift
//  RecipeApp
//
//  Created by Anthony Le on 4/18/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State var selection: Int = 2
    
    var body: some View {
        TabView(selection: $selection) {
            ProfileView()
                .tabItem {
                    Image(systemName: "person")
                    Text("Profile")
                }
                .tag(0)
            SearchView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }
                .tag(1)
            FeedView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Feed")
                }
                .tag(2)
            ChatView()
                .tabItem {
                    Image(systemName: "bubble")
                    Text("Chat")
                }
                .tag(3)
            CreatePostView()
                .tabItem {
                    Image(systemName: "plus")
                    Text("Create Post")
                }
                .tag(4)
        }
    }
}

#Preview {
    ContentView()
}
