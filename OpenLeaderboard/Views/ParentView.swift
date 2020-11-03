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

<<<<<<< Updated upstream
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
=======
struct Profile: Codable {
    
    //init(from:) {}

    public var user_id = 0
    public var name = ""
    public var board_count = 0
    public var matches_count = 0
    public var favourite_boards: [Boards]

}

struct TabParent: View {
    
    @EnvironmentObject var userData: UserData
    
    var body: some View {
        TabView {
            ProfileView(accessToken: userData.access_token)
             .tabItem {
                Image(systemName: "person.fill")
                Text("Profile")
              }
            MainBoardsView(accessToken: userData.access_token)
              .tabItem {
                 Image(systemName: "list.bullet")
                 Text("Boards")
               }
            AddBoardView(accessToken: userData.access_token)
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
>>>>>>> Stashed changes
        }
    }
}

struct ProfileView: View {
    
    var accessToken: String
    @ObservedObject var fetchProfile: FetchProfile
    
    init(accessToken: String) {
        self.accessToken = accessToken
        self.fetchProfile = FetchProfile(accessToken: accessToken)
    }
    
    var body: some View {
        NavigationView {
            VStack{
                Text("\(fetchProfile.name)").font(.largeTitle).bold()
                Divider()
                Text("Top Boards").font(.system(size: 23)).padding(.top, 30)
                VStack (alignment: .leading) {
                    ForEach(fetchProfile.favourite_boards, id: \.self) { board in
                        HStack {
                            HStack {
                                Image(systemName: "seal.fill").foregroundColor(platinum).padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                                VStack (alignment: .leading) {
                                    Text(board.board_name)
                                    Text("#\(board.rank) of \(board.users_count)")
                                        .font(.system(size: 15))
                                        .foregroundColor(.gray)
                                }
                            }.padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
                            Spacer()
                            HStack {
                                VStack (alignment: .trailing) {
                                    Text(String(format: "%.1f", board.rating))
                                    Text("\(board.wins)W / \(board.losses)L")
                                        .font(.system(size: 15))
                                        .foregroundColor(.gray)
                                }
                            Image(systemName: "chevron.right").padding(EdgeInsets(top: 0, leading: 27, bottom: 0, trailing: 20)).foregroundColor(.gray)
                            }
                        }
                        Divider()
                    }
                }.padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                Spacer()
                
                VStack {
                    Divider()
                    HStack {
                        NavigationLink(
                            destination: ProfileBoards(),
                            label: {
                                Text("All Boards")
                            })
                            .buttonStyle(PlainButtonStyle())
                        Spacer()
                        Text("8")
                        Image(systemName: "chevron.right").padding(EdgeInsets(top: 0, leading: 27, bottom: 0, trailing: 20)).foregroundColor(.gray)
                    }.padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                    
                    Divider()
                    
                    HStack {
                        NavigationLink(
                            destination: ProfileActivity(),
                            label: {
                                Text("My Activity")
                            })
                            .buttonStyle(PlainButtonStyle())
                        Spacer()
                        Text("42")
                        Image(systemName: "chevron.right").padding(EdgeInsets(top: 0, leading: 27, bottom: 0, trailing: 20)).foregroundColor(.gray)
                    }.padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                    Divider()
                }
            }.padding(.top, -80)
        
        }
        
    }
}


struct ProfileBoards: View {
    
    var body: some View {
        Text("Boards you are invloved with will appear here")
    }
}

struct ProfileActivity: View {
    
    var body: some View {
        Text("Your activity will be logged here")
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
<<<<<<< Updated upstream
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
=======
                        HStack {
                            Image(systemName: "seal.fill").foregroundColor(platinum).padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                            VStack (alignment: .leading) {
                                Text(board.board_name)
                                Text("#\(board.rank) of \(board.users_count)")
                                    .font(.system(size: 15))
                                    .foregroundColor(.gray)
                            }
                        }.padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        Spacer()
                        HStack {
                            VStack (alignment: .trailing) {
                                Text("2100")
                                Text("\(board.wins)W / \(board.losses)L")
                                    .font(.system(size: 15))
                                    .foregroundColor(.gray)
                            }
                        Image(systemName: "chevron.right").padding(EdgeInsets(top: 0, leading: 27, bottom: 0, trailing: 0)).foregroundColor(.gray)
                        }
                    }.padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                    
                    Divider()
>>>>>>> Stashed changes
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
