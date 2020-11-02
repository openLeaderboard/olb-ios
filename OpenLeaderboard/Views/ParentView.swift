//
//  ParentView.swift
//  OpenLeaderboard
//
//  Created by Tim Lyster on 2020-10-29.
//  Copyright © 2020 OpenLeaderboard. All rights reserved.
//

import SwiftUI

let backgroundColor = Color(red: 94.0/255.0, green: 92.0/255.0, blue: 230.0/255.0, opacity: 1.0)
let lightGray = Color(red: 247.0/255.0, green: 247.0/255.0, blue: 257.0/255.0, opacity: 1.0)
let platinum = Color(red: 152.0/255.0, green: 193.0/255.0, blue: 217.0/255.0, opacity: 1.0)

struct Initial: Codable {
    let boards: [Boards]
}

struct Boards: Codable, Hashable {
    public var board_id: Int
    public var board_name: String
    public var rank_icon: Int
    public var rank: Int
    public var users_count: Int
    public var rating: Double
    public var wins: Int
    public var losses: Int
}

struct TabParent: View {
    
    @EnvironmentObject var userData: UserData
    
    var body: some View {
        TabView {
            ProfileView()
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
        }
        .accentColor(bgColor)
        .navigationBarTitle("Boards", displayMode: .inline)
        .navigationBarHidden(false)
    }
}

struct MainBoardsView: View {
    
    var accessToken: String
    @State private var menuIndex: Int = 0
    @ObservedObject var fetchBoards: FetchBoards
    
    init(accessToken: String) {
        self.accessToken = accessToken
        self.fetchBoards = FetchBoards(accessToken: accessToken)
    }
    
    var body: some View {
        VStack {
            Picker("Boards Index", selection: $menuIndex) {
                Text("All Boards")
                Text("My Boards")
            }.pickerStyle(SegmentedPickerStyle())
            
            VStack (alignment: .leading) {
                ForEach(fetchBoards.boards, id: \.self) { board in
                    HStack {
                        HStack {
                            Image(systemName: "seal.fill").foregroundColor(platinum).padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                            VStack (alignment: .leading) {
                                Text(board.board_name)
                                Text("#\(board.rank) of \(board.users_count)")
                                    .font(.system(size: 15))
                                    .foregroundColor(.gray)
                            }
                        }.padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        HStack {
                            VStack (alignment: .trailing) {
                                Text("2100")
                                Text("\(board.wins)W / \(board.losses)L")
                                    .font(.system(size: 15))
                                    .foregroundColor(.gray)
                            }
                        Image(systemName: "chevron.right").padding(EdgeInsets(top: 0, leading: 27, bottom: 0, trailing: 0)).foregroundColor(.gray)
                        }
                    }.padding(EdgeInsets(top: 10, leading: -40, bottom: 10, trailing: 0))
                }
            }
            Spacer()
        }
    }
}

struct AddBoardView: View {
    
    var accessToken: String
    @State var board_name: String = ""
    @State var isPublic: Bool = true;
    
    init(accessToken: String) {
        self.accessToken = accessToken
    }
    
    var body: some View {
        VStack (alignment: .leading) {
            Text("Board Information")
                .fontWeight(.bold)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0))
            TextField("Board Name...", text: $board_name)
                .padding()
                .background(lightGray)
                .shadow(radius: 8)
                .cornerRadius(20.0)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0))
            Text("Privacy Settings")
                .fontWeight(.bold)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 15, trailing: 0))
            HStack {
                Image(systemName: "eye.fill")
                Text("Public")
                    .frame(alignment: .leading)
                    .onTapGesture {
                        isPublic.toggle()
                    }
            }.padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
            .foregroundColor(isPublic ? bgColor : .gray)
            HStack {
                Image(systemName: "eye.slash.fill")
                Text("Private")
                    .frame(alignment: .leading)
                    .onTapGesture {
                        isPublic.toggle()
                    }
            }.padding(EdgeInsets(top: 0, leading: 0, bottom: 75, trailing: 0))
            .foregroundColor(isPublic ? .gray : bgColor)
            Button(action: addBoard){
                HStack(alignment: .center) {
                    Spacer()
                    Text("Create Board").foregroundColor(.white).bold()
                    Spacer()
                }
            }
            .padding().background(bgColor)
            .cornerRadius(20.0)
            .buttonStyle(PlainButtonStyle())
        }.padding(30)
    }
    
    func addBoard() {
        print("clicked")
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
        TabParent().environmentObject(UserData())
    }
}

//ForEach(fetchBoards.boards, id: \.self) { board in
//    HStack {
//        Image(systemName: "seal.fill").foregroundColor(platinum)
//        VStack (alignment: .leading) {
//            Text(board.board_name)
//            Text("#\(board.rank) of \(board.users_count)")
//                .font(.system(size: 15))
//                .foregroundColor(.gray)
//        }.padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 105))
//        VStack (alignment: .trailing) {
//            Text("2100")
//            Text("\(board.wins)W / \(board.losses)L")
//                .font(.system(size: 15))
//                .foregroundColor(.gray)
//        }
//        Image(systemName: "chevron.right").padding(EdgeInsets(top: 0, leading: 27, bottom: 0, trailing: 0)).foregroundColor(.gray)
//    }
//
//}
