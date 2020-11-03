//
//  ParentView.swift
//  OpenLeaderboard
//
//  Created by Tim Lyster on 2020-10-29.
//  Copyright © 2020 OpenLeaderboard. All rights reserved.
//

import SwiftUI

let backgroundColor = Color(red: 94.0/255.0, green: 92.0/255.0, blue: 230.0/255.0, opacity: 1.0)
let platinum = Color(red: 152.0/255.0, green: 193.0/255.0, blue: 217.0/255.0, opacity: 1.0)

struct TabParent: View {

    @ObservedObject var tabViewModel = TabViewModel()

    var body: some View {
        NavigationView {
            TabView {
                ProfileView()
                 .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                  }
                MainBoardsView()
                  .tabItem {
                     Image(systemName: "list.bullet")
                     Text("Boards")
                   }
                AddBoardView()
                  .tabItem {
                     Image(systemName: "plus")
                     Text("Add Board")
                   }
                SearchView()
                  .tabItem {
                     Image(systemName: "magnifyingglass")
                     Text("Search")
                   }
                NotificationsView()
                  .tabItem {
                     Image(systemName: "bell.fill")
                     Text("Notifications")
                   }
               
            }.accentColor(bgColor)
        }
    }
}

struct MainBoardsView: View {
    
    @State private var menuIndex: Int = 0
    var body: some View {
        NavigationView {
            VStack {
                Picker("Boards Index", selection: $menuIndex) {
                    Text("All Boards")
                    Text("My Boards")
                }.pickerStyle(SegmentedPickerStyle())
                Spacer()
                List {
                    HStack {
                        Image(systemName: "seal.fill").foregroundColor(platinum)
                        VStack (alignment: .leading) {
                            Text("Joel's Board")
                            Text("#1 of 56")
                                .font(.system(size: 15))
                                .foregroundColor(.gray)
                        }.padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 105))
                        VStack (alignment: .trailing){
                            Text("2100")
                            Text("57W / 10L")
                                .font(.system(size: 15))
                                .foregroundColor(.gray)
                        }
                        Image(systemName: "chevron.right").padding(EdgeInsets(top: 0, leading: 27, bottom: 0, trailing: 0)).foregroundColor(.gray)
                    }
                }
            }
        }
    }
}

struct AddBoardView: View {
    var body: some View {
        Text("Add Boards Screen")
    }
}


struct SearchView: View {
    var body: some View {
        Text("Search Screen")
    }
}

struct NotificationsView: View {
    var body: some View {
        Text("Notifications Screen")
    }
}

struct ParentView_Previews: PreviewProvider {
    static var previews: some View {
        TabParent(tabViewModel: TabViewModel())
    }
}
