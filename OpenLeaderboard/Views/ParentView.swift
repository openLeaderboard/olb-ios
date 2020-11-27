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
let thumbsUp = Color(red: 61.0/255.0, green: 126.0/255.0, blue: 164.0/255.0, opacity: 1.0)
let thumbsDown = Color(red: 83.0/255.0, green: 58.0/255.0, blue: 123.0/255.0, opacity: 1.0)
let tie = Color(red: 152.0/255.0, green: 193.0/255.0, blue: 217.0/255.0, opacity: 1.0)

struct Initial: Codable {
    let boards: [Boards]
}

struct Boards: Codable, Hashable {
    public var board_id = 0
    public var board_name = ""
    public var rank_icon = 0
    public var rank = 0
    public var users_count = 0
    public var rating = 0.0
    public var wins = 0
    public var losses = 0
}

struct AllUsers: Codable {
    let search_result: [Users]
}

struct Users: Codable, Hashable {
    public var id = 0
    public var name = ""
    public var board_count = 0
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
    public var submitter_result = ""
    public var receiver_result = ""
}

struct BoardMembers: Codable {
    let members: [BoardMembersModel]
}

struct BoardMembersModel: Codable, Hashable {
    public var name = ""
    public var user_id = 0
    public var rank_icon = 0
    public var rank = 0
    public var rating = 0.0
    public var wins = 0
    public var losses = 0
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
                        ScrollView {
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
                                }.navigationBarTitle(Text("Boards"), displayMode: .inline)
                            }
                        }
                    }
                    else {
                        ScrollView {
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
            }.onAppear {
                self.fetchBoards.fetchBoards(accessToken: self.accessToken)
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
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
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
            Button(action: {
                if addBoard() {
                    self.mode.wrappedValue.dismiss() // pop navigation view back
                }
            }){
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
        .navigationBarTitle(Text("Create Board"), displayMode: .inline)
    }
    
    func addBoard() -> Bool {
        
        struct CreateBoardResponse: Decodable {
            let success: Bool
            let message: String
            let board_id: Int
        }
        var success = false
        let sem = DispatchSemaphore.init(value: 0)
        
        guard let encoded = try? JSONEncoder().encode(addBoardViewModel)
        else {
            print("Failed to encode creation of board rqeuest")
            return false
        }
        
        let url = URL(string: (apiURL + "/board/create"))!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(self.accessToken, forHTTPHeaderField: "authorization")
        request.httpMethod = "POST"
        request.httpBody = encoded
        
        URLSession.shared.dataTask(with: request) {
            data, response, error in
            defer { sem.signal() } // bad jank
            guard let data = data else {
                print("No data in response: \(error?.localizedDescription ?? "Unknown error").")
                return
            }
            
            if let createBoardResponse = try? JSONDecoder().decode(CreateBoardResponse.self, from: data) {
                print("Board created successfully!")
                if (createBoardResponse.success) {
                    success = true
                }
            } else {
                print("Invalid response from server")
                
            }
        }.resume()
        
        sem.wait() // bad
        
        return success
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
                            Text("Boards").foregroundColor(Color(UIColor.label))
                            Spacer()
                            Text("\(fetchProfile.board_count)").foregroundColor(Color(UIColor.label))
                            Image(systemName: "chevron.right").padding(EdgeInsets(top: 0, leading: 27, bottom: 0, trailing: 20)).foregroundColor(.gray)
                        }.padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                    }
                    Divider()
                    NavigationLink(destination: ProfileActivity(accessToken: accessToken)) {
                        HStack {
                            Text("Activity").foregroundColor(Color(UIColor.label))
                            Spacer()
                            Text("\(fetchProfile.matches_count)").foregroundColor(Color(UIColor.label))
                            Image(systemName: "chevron.right").padding(EdgeInsets(top: 0, leading: 27, bottom: 0, trailing: 20)).foregroundColor(.gray)
                        }.padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                    }
                    Divider()
                }
            }.padding(.top, -80)
            
        }.onAppear {
            self.fetchProfile.fetchProfile(accessToken: self.accessToken)
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
        self.fetchBoards.fetchBoards(accessToken: self.accessToken)
    }
    
    var body: some View {
        VStack{
            ScrollView {
                VStack (alignment: .leading) {
                    ForEach(fetchBoards.boards, id: \.self) { board in
                        HStack {
                            HStack {
                                Image(systemName: "seal.fill").foregroundColor(getIconColor(iconInt: board.rank_icon)).padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
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
            }
        }.navigationBarTitle(Text("Boards"), displayMode: .inline)
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
    @ObservedObject var fetchActivity: FetchProfileActivity
    
    init(accessToken: String) {
        self.accessToken = accessToken
        self.fetchActivity = FetchProfileActivity(accessToken: accessToken)
        self.fetchActivity.fetchActivity(accessToken: self.accessToken)
    }
    
    var body: some View {
        VStack {
            ScrollView {
                VStack (alignment: .leading) {
                    ForEach(fetchActivity.activities, id: \.self) { activity in
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
            }
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
            ScrollView {
                VStack (alignment: .leading) {
                    ForEach(fetchBoardsActivity.boardActivities, id: \.self) { activity in
                        HStack {
                            HStack {
                                VStack (alignment: .leading) {
                                    Text(activity.submitter_name)
                                    Text(activity.submitter_result)
                                        .font(.system(size: 15))
                                        .foregroundColor(.gray)
                                }
                            }.padding(EdgeInsets(top: 10, leading: 20, bottom: 0, trailing: 0))
                            Spacer()
                            HStack {
                                VStack (alignment: .trailing) {
                                    Text(activity.receiver_name)
                                    Text(activity.receiver_result)
                                        .font(.system(size: 15))
                                        .foregroundColor(.gray)
                                }
                            }.padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 20))
                        }.frame(height: 55)
                        Divider()
                    }
                }
                Spacer()
            }
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
        VStack {
            Text("Top Players")
                .font(.system(size: 23))
                .padding(EdgeInsets(top: 30, leading: 20, bottom: 0, trailing: 20))
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            Spacer()
            VStack {
                Divider()
                NavigationLink(destination: BoardMembersView(accessToken: accessToken, boardId: self.board.board_id)) {
                    HStack {
                        Text("Members").foregroundColor(Color(UIColor.label))
                        Spacer()
                        Text("\(board.users_count)").foregroundColor(Color(UIColor.label))
                        Image(systemName: "chevron.right").padding(EdgeInsets(top: 0, leading: 27, bottom: 0, trailing: 20)).foregroundColor(.gray)
                    }.padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                }
                Divider()
                NavigationLink(destination: BoardActivity(accessToken: accessToken, boardId: self.board.board_id)) {
                    HStack {
                        Text("Activity").foregroundColor(Color(UIColor.label))
                        Spacer()
                        Image(systemName: "chevron.right").padding(EdgeInsets(top: 0, leading: 27, bottom: 0, trailing: 20)).foregroundColor(.gray)
                    }.padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                }
                Divider()
            }
        }.navigationBarTitle(Text("\(board.board_name)"), displayMode: .inline)
    }
}

struct BoardMembersView: View {
    
    @State var selectedTag: String?
    
    var accessToken: String
    var boardId: Int
    @ObservedObject var fetchMembers: FetchBoardMembers
    
    init(accessToken: String, boardId: Int) {
        self.accessToken = accessToken
        self.boardId = boardId
        self.fetchMembers = FetchBoardMembers(accessToken: accessToken,  boardID: self.boardId)
    }
    
    var body: some View {
        VStack {
            ScrollView {
                VStack (alignment: .leading) {
                    ForEach(fetchMembers.boardMembers, id: \.self) { member in
                        HStack {
                            HStack {
                                Image(systemName: "seal.fill").foregroundColor(getIconColor(iconInt: member.rank_icon)).padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                                VStack (alignment: .leading) {
                                    Text(member.name)
                                    Text("#\(member.rank)")
                                        .font(.system(size: 15))
                                        .foregroundColor(.gray)
                                }
                            }.padding(EdgeInsets(top: 10, leading: 20, bottom: 0, trailing: 0))
                            Spacer()
                            HStack {
                                VStack (alignment: .trailing) {
                                    Text("\(member.rating, specifier: "%.1f")")
                                    Text("\(member.wins)W / \(member.losses)L")
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
            }
        }.navigationBarTitle(Text("Board Members"), displayMode: .inline)
        .navigationBarItems(trailing: Button(action: {}) {
            VStack {
                
                Spacer()
                NavigationLink(destination: AddMemberView(accessToken: accessToken)) {
                    Image(systemName: "person.fill.badge.plus")
                            .resizable()
                            .frame(width: 32.0, height: 32.0)
                }
            }
        })
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

struct SubmitMatchView: View {
    
    var accessToken: String
    @State var boardExpansion: Bool = false
    @State var opponentExpansion: Bool = false
    @State var resultExpansion: Bool = false
    @State var selectedBoard: Boards = Boards()
    @State var selectedOpponent: BoardMembersModel = BoardMembersModel()
    @State var selectedResult: String = ""
    @State var fetchBoardMembers: FetchBoardMembers = FetchBoardMembers(accessToken: "",  boardID: 0)
    @ObservedObject var fetchBoards: FetchBoards
    
    init(accessToken: String) {
        self.accessToken = accessToken
        self.fetchBoards = FetchBoards(accessToken: accessToken)
    }
    
    var body: some View {
        NavigationView {
            List {
                HStack {
                    Text("Board")
                    Spacer()
                    VStack (alignment: .trailing) {
                        Text((self.selectedBoard.board_name != "" ? "\(self.selectedBoard.board_name)" : "No board selected")).foregroundColor(.gray)
                    }
                }.onTapGesture {
                    self.boardExpansion = !self.boardExpansion
                    self.opponentExpansion = false
                    self.resultExpansion = false
                }; if self.boardExpansion {
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
                                }.padding(EdgeInsets(top: 10, leading: 0, bottom: 5, trailing: 20))
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                self.boardExpansion = !self.boardExpansion
                                self.selectedBoard = board
                                self.fetchBoardMembers = FetchBoardMembers(accessToken: self.accessToken, boardID: board.board_id)
                            }
                        }
                    }
                }
                HStack {
                    Text("Opponent")
                    Spacer()
                    VStack (alignment: .trailing) {
                        Text((self.selectedOpponent.name != "" ? "\(self.selectedOpponent.name)" : "No opponent selected")).foregroundColor(.gray)
                    }
                }.onTapGesture {
                    self.opponentExpansion = !self.opponentExpansion
                    self.boardExpansion = false
                    self.resultExpansion = false
                }; if (self.opponentExpansion && self.selectedBoard.board_name != "") {
                    VStack (alignment: .leading) {
                        ForEach(self.fetchBoardMembers.boardMembers, id: \.self) { opponent in
                            HStack {
                                HStack {
                                    Image(systemName: "seal.fill").foregroundColor(getIconColor(iconInt: opponent.rank_icon)).padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                                    VStack (alignment: .leading) {
                                        Text(opponent.name)
                                        Text("#\(opponent.rank)")
                                            .font(.system(size: 15))
                                            .foregroundColor(.gray)
                                    }
                                }.padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
                                Spacer()
                                HStack {
                                    VStack (alignment: .trailing) {
                                        Text("\(opponent.rating, specifier: "%.0f")")
                                        Text("\(opponent.wins)W / \(opponent.losses)L")
                                            .font(.system(size: 15))
                                            .foregroundColor(.gray)
                                    }
                                }.padding(EdgeInsets(top: 10, leading: 0, bottom: 5, trailing: 20))
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                self.opponentExpansion = !self.opponentExpansion
                                self.selectedOpponent = opponent
                            }
                            }
                        }
                    }
                HStack {
                    Text("Result")
                    Spacer()
                    VStack (alignment: .trailing) {
                        Text((self.selectedResult != "" ? "\(self.selectedResult)" : "No result selected")).foregroundColor(.gray)
                    }
                }.onTapGesture {
                    self.resultExpansion = !self.resultExpansion
                    self.boardExpansion = false
                    self.opponentExpansion = false
                }; if (self.resultExpansion && self.selectedOpponent.name != "") {
                        VStack (alignment: .center) {
                            HStack {
                                VStack {
                                    Image(systemName: "hand.thumbsup.fill").foregroundColor((self.selectedResult == "Win" || self.selectedResult == "" ? thumbsUp : .gray))
                                        .font(.system(size: 100))
                                    Text("Win")
                                }.onTapGesture {
                                    self.selectedResult = "Win"
                                }
                                .padding(EdgeInsets(top: 20, leading: 20, bottom: 0, trailing: 0))
                                Spacer()
                                VStack {
                                    Image(systemName: "hand.thumbsdown.fill").foregroundColor((self.selectedResult == "Loss" || self.selectedResult == "" ? thumbsDown : .gray))
                                        .font(.system(size: 100))
                                    Text("Loss")
                                }.onTapGesture {
                                    self.selectedResult = "Loss"
                                }.padding(EdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 20))
                            }
                            VStack {
                                Image(systemName: "hands.clap.fill").foregroundColor((self.selectedResult == "Tie" || self.selectedResult == "" ? tie : .gray))
                                    .font(.system(size: 100))
                                Text("Tie")
                            }.onTapGesture {
                                self.selectedResult = "Tie"
                            }.padding(EdgeInsets(top: 20, leading: 0, bottom: 20, trailing: 0))
                            Button(action: submitMatch) {
                                HStack(alignment: .center) {
                                    Spacer()
                                    Text("Submit Match").foregroundColor(btnColor).bold()
                                    Spacer()
                                }
                            }.padding()
                            .background(bgColor)
                            .cornerRadius(20.0)
                            .buttonStyle(PlainButtonStyle())
                        }.padding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0))
                    }
                }.navigationBarTitle(Text("Submit Match"), displayMode: .inline)
            }
        .listStyle(GroupedListStyle()).onAppear{
            self.fetchBoards.fetchBoards(accessToken: self.accessToken)
        }
    }
    
    func submitMatch() {
        print("submit match")
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

struct AddMemberView: View {
   
    
    var accessToken: String
    @ObservedObject var fetchUsers: FetchUsers
    
    init(accessToken: String) {
        self.accessToken = accessToken
        self.fetchUsers = FetchUsers(accessToken: accessToken)
    }
    
        
    var body: some View {
        VStack{
            VStack (alignment: .leading) {
                ForEach(fetchUsers.userResults, id: \.self) { user in
                    HStack {
                        HStack {
                            VStack (alignment: .leading) {
                                Text("\(user.name)")
                                if(user.board_count == 1){
                                    Text("\(user.board_count) Board")
                                        .font(.system(size: 15))
                                        .foregroundColor(.gray)
                                }else {
                                    Text("\(user.board_count) Boards")
                                        .font(.system(size: 15))
                                        .foregroundColor(.gray)
                                }
                                
                                    
                            }
                        }.padding(EdgeInsets(top: 10, leading: 20, bottom: 0, trailing: 0))
                        Spacer()
                        HStack {
                            Button(action: {
                                //self.navigateTo = "create"
                            }, label: {
                                Text("+")
                                .font(.system(.largeTitle))
                                    .frame(width: 32, height: 24.5)
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
                    }.padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 20))
                    Divider()
                }
            }
            Spacer()
            Spacer()
        }.navigationBarTitle(Text("Add Member"), displayMode: .inline)
    }
}



struct SearchView: View {
    var body: some View {
        Text("Search Screen")
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
