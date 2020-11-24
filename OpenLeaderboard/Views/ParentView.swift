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
let bronze = Color(red: 221.0/255.0, green: 167.0/255.0, blue: 123.0/255.0, opacity: 1.0)
let silver = Color(red: 198.0/255.0, green: 185.0/255.0, blue: 169.0/255.0, opacity: 1.0)
let gold = Color(red: 255.0/255.0, green: 191.0/255.0, blue: 0.0/255.0, opacity: 1.0)
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

struct Profile: Codable {
    public var user_id = 0
    public var name = ""
    public var board_count = 0
    public var matches_count = 0
    public var favourite_boards: [Boards]
}

struct Activities: Codable {
    let matches: [Activity]
}

struct Activity: Codable, Hashable {
    public var board_name = ""
    public var opponent_name = ""
    public var rating_change = 0.0
    public var result = ""
}

struct BoardActivities: Codable {
    let matches: [BoardActivityModel]
}

struct BoardActivityModel: Codable, Hashable {
    
    public var submitter_name = ""
    public var receiver_name = ""
    public var submitter_result = 0.0
    public var receiver_result = ""
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
            SubmitMatchView(accessToken: userData.access_token)
                .tabItem {
                    Image(systemName: "plus")
                    Text("Submit Match")
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
    @State private var navigateTo: String? = nil
    @ObservedObject var fetchBoards: FetchBoards
    
    init(accessToken: String) {
        self.accessToken = accessToken
        self.fetchBoards = FetchBoards(accessToken: accessToken)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    Picker(selection: $menuIndex, label: Text("Board Type")) {
                        Text("All Boards").tag(0)
                        Text("My Boards").tag(1)
                    }.pickerStyle(SegmentedPickerStyle())
                    if (menuIndex == 0) {
                        VStack (alignment: .leading) {
                            ForEach(fetchBoards.boards, id: \.self) { board in
                                HStack {
                                    NavigationLink(destination: BoardDetails(accessToken: self.accessToken, currentBoard: board)) {
                                        HStack {
                                            Image(systemName: "seal.fill").foregroundColor(getIconColor(iconInt: board.rank_icon)).padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 10))
                                            VStack (alignment: .leading) {
                                                Text(board.board_name)
                                                    .foregroundColor(Color(UIColor.label))
                                                Text("#\(board.rank) of \(board.users_count)")
                                                    .font(.system(size: 15))
                                                    .foregroundColor(.gray)
                                            }
                                        }.padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
                                        Spacer()
                                        HStack {
                                            VStack (alignment: .trailing) {
                                                Text(String(format: "%.1f", board.rating))
                                                    .foregroundColor(Color(UIColor.label))
                                                Text("\(board.wins)W / \(board.losses)L")
                                                    .font(.system(size: 15))
                                                    .foregroundColor(.gray)
                                            }
                                            Image(systemName: "chevron.right").padding(EdgeInsets(top: 0, leading: 27, bottom: 0, trailing: 20)).foregroundColor(.gray)
                                        }
                                    }
                                    .padding(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 20))
                                }
                                Divider()
                            }
                            NavigationLink(destination: AddBoardView(accessToken: self.accessToken)) {
                            VStack {
                                Spacer()
                                    HStack {
                                    Spacer()
                                        Button(action: {
                                            self.navigateTo = "create"
                                        }, label: {
                                            Text("+")
                                            .font(.system(.largeTitle))
                                            .frame(width: 55, height: 48)
                                            .foregroundColor(Color.white)
                                            .padding(.bottom, 7)
                                        })
                                        .background(bgColor)
                                        .cornerRadius(38.5)
                                        .padding()
                                        .shadow(color: Color.black.opacity(0.3),
                                                radius: 3,
                                                x: 3,
                                                y: 3)
                                    }
                                }
                            }.navigationBarTitle(Text("All Boards"), displayMode: .inline)
                        }
                    }
                    else {
                        VStack (alignment: .leading) {
                            ForEach(fetchBoards.myBoards, id: \.self) { board in
                                HStack {
                                    NavigationLink(destination: BoardDetails(accessToken: self.accessToken, currentBoard: board)) {
                                        HStack {
                                            Image(systemName: "seal.fill").foregroundColor(getIconColor(iconInt: board.rank_icon)).padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 10))
                                            VStack (alignment: .leading) {
                                                Text(board.board_name)
                                                    .foregroundColor(Color(UIColor.label))
                                                Text("#\(board.rank) of \(board.users_count)")
                                                    .font(.system(size: 15))
                                                    .foregroundColor(.gray)
                                            }
                                        }.padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
                                        Spacer()
                                        HStack {
                                            VStack (alignment: .trailing) {
                                                Text(String(format: "%.1f", board.rating))
                                                    .foregroundColor(Color(UIColor.label))
                                                Text("\(board.wins)W / \(board.losses)L")
                                                    .font(.system(size: 15))
                                                    .foregroundColor(.gray)
                                            }
                                            Image(systemName: "chevron.right").padding(EdgeInsets(top: 0, leading: 27, bottom: 0, trailing: 20)).foregroundColor(.gray)
                                        }
                                    }
                                    .padding(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 20))
                                }
                                Divider()
                            }
                            VStack {
                                Spacer()
                                NavigationLink(destination: AddBoardView(accessToken: self.accessToken)) {
                                    HStack {
                                    Spacer()
                                        Button(action: {
                                            self.navigateTo = "create"
                                        }, label: {
                                            Text("+")
                                            .font(.system(.largeTitle))
                                            .frame(width: 55, height: 48)
                                            .foregroundColor(Color.white)
                                            .padding(.bottom, 7)
                                        })
                                        .background(bgColor)
                                        .cornerRadius(38.5)
                                        .padding()
                                        .shadow(color: Color.black.opacity(0.3),
                                                radius: 3,
                                                x: 3,
                                                y: 3)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func getIconColor(iconInt: Int) -> Color {
        switch iconInt {
        case 1:
            return platinum
        case 2:
            return gold
        case 3:
            return silver
        default:
            return bronze
        }
    }
    
}

struct AddBoardView: View {
    
    var accessToken: String
    @ObservedObject var addBoardViewModel = AddBoardViewModel()
    
    init(accessToken: String) {
        self.accessToken = accessToken
    }
    
    var body: some View {
        VStack (alignment: .leading) {
            Text("Board Information")
                .fontWeight(.bold)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0))
            
            TextField("Board Name...", text: self.$addBoardViewModel.board_name)
                .padding()
                .foregroundColor(Color.blue)
                .background(Color.white)
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
                        self.addBoardViewModel.is_public.toggle()
                    }
            }.padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
            .foregroundColor(self.addBoardViewModel.is_public ? bgColor : .gray)
            HStack {
                Image(systemName: "eye.slash.fill")
                Text("Private")
                    .frame(alignment: .leading)
                    .onTapGesture {
                        self.addBoardViewModel.is_public.toggle()
                    }
            }.padding(EdgeInsets(top: 0, leading: 0, bottom: 75, trailing: 0))
            .foregroundColor(self.addBoardViewModel.is_public ? .gray : bgColor)
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
        
        struct RegistrationToken: Decodable {
            let success: Bool
            let message: String
            let board_id: String
        }
        
        guard let encoded = try? JSONEncoder().encode(addBoardViewModel)
        else {
            print("Failed to encode creation of board rqeuest")
            return
        }
        
        let url = URL(string: (apiURL + "/board/create"))!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(self.accessToken, forHTTPHeaderField: "authorization")
        request.httpMethod = "POST"
        request.httpBody = encoded
        
        URLSession.shared.dataTask(with: request) {
            data, response, error in
            guard let data = data else {
                print("No data in response: \(error?.localizedDescription ?? "Unknown error").")
                return
            }
            
            if let createBoardResponse = try? JSONDecoder().decode(RegistrationToken.self, from: data) {
                print("Board created successfully!")
            } else {
                print("Invalid response from server")
            }
        }.resume()
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
                                Image(systemName: "seal.fill").foregroundColor(getIconColor(iconInt: board.rank_icon)).padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
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
                            }.padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 20))
                        }
                        Divider()
                    }
                }.padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                Spacer()
                
                VStack {
                    Divider()
                    NavigationLink(destination: ProfileBoards(accessToken: accessToken)) {
                        HStack {
                            Text("My Boards").foregroundColor(Color(UIColor.label))
                            Spacer()
                            Text("8").foregroundColor(Color(UIColor.label))
                            Image(systemName: "chevron.right").padding(EdgeInsets(top: 0, leading: 27, bottom: 0, trailing: 20)).foregroundColor(.gray)
                        }.padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                    }
                    Divider()
                    NavigationLink(destination: ProfileBoards(accessToken: accessToken)) {
                        HStack {
                            Text("My Activity").foregroundColor(Color(UIColor.label))
                            Spacer()
                            Text("42").foregroundColor(Color(UIColor.label))
                            Image(systemName: "chevron.right").padding(EdgeInsets(top: 0, leading: 27, bottom: 0, trailing: 20)).foregroundColor(.gray)
                        }.padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                    }
                    Divider()
                }
            }.padding(.top, -80)
            
        }
    }
    
    func getIconColor(iconInt: Int) -> Color {
        switch iconInt {
        case 1:
            return platinum
        case 2:
            return gold
        case 3:
            return silver
        default:
            return bronze
        }
    }
}

struct ProfileBoards: View {
    
    var accessToken: String
    @ObservedObject var fetchBoards: FetchBoards
    
    init(accessToken: String) {
        self.accessToken = accessToken
        self.fetchBoards = FetchBoards(accessToken: accessToken)
    }
    
    var body: some View {
        VStack{
            VStack (alignment: .leading) {
                ForEach(fetchBoards.boards, id: \.self) { board in
                    HStack {
                        HStack {
                            Image(systemName: "seal.fill").foregroundColor(getIconColor(iconInt: board.rank_icon)).padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0));
                            VStack (alignment: .leading) {
                                Text(board.board_name)
                                Text("#\(board.rank) of \(board.users_count)")
                                    .font(.system(size: 15))
                                    .foregroundColor(.gray)
                            }
                        }.padding(EdgeInsets(top: 10, leading: 20, bottom: 0, trailing: 0))
                        Spacer()
                        HStack {
                            VStack (alignment: .trailing) {
                                Text("\(board.rating,specifier: "%.1f")")
                                Text("\(board.wins)W / \(board.losses)L")
                                    .font(.system(size: 15))
                                    .foregroundColor(.gray)
                            }
                        }
                    }.padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 20))
                    Divider()
                }
            }
            Spacer()
            Spacer()
        }.navigationBarTitle(Text("My Boards"), displayMode: .inline)
    }
    
    func getIconColor(iconInt: Int) -> Color {
        switch iconInt {
        case 1:
            return platinum
        case 2:
            return gold
        case 3:
            return silver
        default:
            return bronze
        }
    }
}

struct ProfileActivity: View {
    
    var accessToken: String
    @ObservedObject var fetchactivity: FetchActivity
    
    init(accessToken: String) {
        self.accessToken = accessToken
        self.fetchactivity = FetchActivity(accessToken: accessToken)
    }
    
    var body: some View {
        VStack{
            //ScrollView{}.navigationBarTitle("My Activity", displayMode: .inline)
            VStack (alignment: .leading) {
                ForEach(fetchactivity.activities, id: \.self) { activity in
                    HStack {
                        HStack {
                            VStack (alignment: .leading) {
                                Text(activity.board_name)
                                Text("Played \(activity.opponent_name)")
                                    .font(.system(size: 15))
                                    .foregroundColor(.gray)
                            }
                        }.padding(EdgeInsets(top: 10, leading: 20, bottom: 0, trailing: 0))
                        Spacer()
                        HStack {
                            VStack (alignment: .trailing) {
                                Text(activity.result)
                                if activity.rating_change > 0 {
                                    Text("+\(activity.rating_change, specifier: "%.1f")")
                                        .font(.system(size: 15))
                                        .foregroundColor(.gray)
                                }else{
                                    Text("\(activity.rating_change, specifier: "%.1f")")
                                        .font(.system(size: 15))
                                        .foregroundColor(.gray)
                                }
                                    
                            }
                        }.padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 20))
                    }.frame(height: 55)
                    Divider()
                }
            }
            Spacer()
        }.navigationBarTitle(Text("My Activity"), displayMode: .inline)
    }
}

struct BoardActivity: View {
    
    var accessToken: String
    var boardId: Int
    @ObservedObject var fetchBoardsActivity: FetchBoardsActivity
    
    init(accessToken: String, boardId: Int) {
        self.accessToken = accessToken
        self.boardId = boardId
        self.fetchBoardsActivity = FetchBoardsActivity(accessToken: self.accessToken, boardID: self.boardId)
    }
    
    var body: some View {
        VStack{
            VStack (alignment: .leading) {
                ForEach(fetchBoardsActivity.boardActivities, id: \.self) { activity in
                    HStack {
                        HStack {
                            VStack (alignment: .leading) {
                                Text(activity.submitter_name)
                                Text("Played \(activity.receiver_name)")
                                    .font(.system(size: 15))
                                    .foregroundColor(.gray)
                            }
                        }.padding(EdgeInsets(top: 10, leading: 20, bottom: 0, trailing: 0))
                        Spacer()
                        HStack {
                            VStack (alignment: .trailing) {
                                Text(activity.receiver_result)
                                if activity.submitter_result > 0 {
                                    Text("+\(activity.submitter_result, specifier: "%.1f")")
                                        .font(.system(size: 15))
                                        .foregroundColor(.gray)
                                }else{
                                    Text("\(activity.submitter_result, specifier: "%.1f")")
                                        .font(.system(size: 15))
                                        .foregroundColor(.gray)
                                }
                                    
                            }
                        }.padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 20))
                    }.frame(height: 55)
                    Divider()
                }
            }
            Spacer()
        }.navigationBarTitle(Text("Board Activity"), displayMode: .inline)
    }
}

struct BoardDetails: View {
    
    var accessToken: String
    var board: Boards
    
    init(accessToken: String, currentBoard: Boards) {
        self.accessToken = accessToken
        self.board = currentBoard
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Text("\(self.board.board_name)").font(.largeTitle).bold()
                Divider()
                Text("Top Players")
                    .font(.system(size: 23))
                    .padding(EdgeInsets(top: 30, leading: 20, bottom: 0, trailing: 20))
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                Spacer()
                VStack {
                    Divider()
                    NavigationLink(destination: ProfileBoards(accessToken: accessToken)) {
                        HStack {
                            Text("Members").foregroundColor(Color(UIColor.label))
                            Spacer()
                            Text("8").foregroundColor(Color(UIColor.label))
                            Image(systemName: "chevron.right").padding(EdgeInsets(top: 0, leading: 27, bottom: 0, trailing: 20)).foregroundColor(.gray)
                        }.padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                    }
                    Divider()
                    NavigationLink(destination: BoardActivity(accessToken: accessToken, boardId: self.board.board_id)) {
                        HStack {
                            Text("Activity").foregroundColor(Color(UIColor.label))
                            Spacer()
                            Text("42").foregroundColor(Color(UIColor.label))
                            Image(systemName: "chevron.right").padding(EdgeInsets(top: 0, leading: 27, bottom: 0, trailing: 20)).foregroundColor(.gray)
                        }.padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                    }
                    Divider()
                }
            }.padding(.top, -80)
        }
    }
}

struct SubmitMatchView: View {
    
    var accessToken: String
    @State private var menuIndex: Int = 0
    @State private var navigateTo: String? = nil
    @ObservedObject var fetchBoards: FetchBoards
    
    init(accessToken: String) {
        self.accessToken = accessToken
        self.fetchBoards = FetchBoards(accessToken: accessToken)
    }
    
    var body: some View {
        NavigationView {
            VStack (alignment: .leading) {
                ForEach(fetchBoards.boards, id: \.self) { board in
                    HStack {
                        HStack {
                            Image(systemName: "seal.fill").foregroundColor(getIconColor(iconInt: board.rank_icon)).padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 10))
                            VStack (alignment: .leading) {
                                Text(board.board_name)
                                    .foregroundColor(Color(UIColor.label))
                                Text("#\(board.rank) of \(board.users_count)")
                                    .font(.system(size: 15))
                                    .foregroundColor(.gray)
                            }
                        }.padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
                        Spacer()
                        HStack {
                            VStack (alignment: .trailing) {
                                Text(String(format: "%.1f", board.rating))
                                    .foregroundColor(Color(UIColor.label))
                                Text("\(board.wins)W / \(board.losses)L")
                                    .font(.system(size: 15))
                                    .foregroundColor(.gray)
                            }
                        }
                    .padding(EdgeInsets(top: 10, leading: 0, bottom: 5, trailing: 20))
                    }
                }
            }
            Spacer()
        }.navigationBarTitle(Text("Submit Match"), displayMode: .inline)
    }
    
    func getIconColor(iconInt: Int) -> Color {
        switch iconInt {
        case 1:
            return platinum
        case 2:
            return gold
        case 3:
            return silver
        default:
            return bronze
        }
    }
    
}

struct SearchView: View {
    var body: some View {
        Text("Search Screen")
    }
}

struct BoardMembersView: View {
    var body: some View {
        Text("Board Members")
    }
}

struct BoardActivityView: View {
    var body: some View {
        Text("Board Activity")
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
