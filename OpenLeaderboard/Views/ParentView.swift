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

struct SearchBoards: Codable, Hashable {
    public var id = 0
    public var name = ""
    public var member_count = 0
}

struct AllBoards: Codable {
    let search_result: [SearchBoards]
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

struct BoardDetailsModel: Codable {
    public var board_id: Int = 0
    public var board_name: String = ""
    public var is_public: Bool = false
    public var is_admin: Bool = false
    public var is_member: Bool = false
    public var matches_count: Int = 0
    public var member_count: Int = 0
    public var top_members = [BoardMembersModel]()
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

struct OutgoingInviteModel: Codable, Hashable {
    public var to_name = ""
    public var invite_id = 0
}

struct IncomingInviteModel: Codable, Hashable {
    public var from_name = ""
    public var invite_id = 0
}

struct IncomingInviteDetailsModel: Codable, Hashable {
    public var board_id: Int = 0
    public var board_name : String = ""
    public var is_public : Bool = true
    public var member_count : Int = 0
    public var from_id : Int = 0
    public var from_name : String = ""
    public var to_id : Int = 0
    public var to_name : String = ""
    public var invite_id : Int = 0
}

struct OutgoingInvites: Codable {
    let invites: [OutgoingInviteModel]
}

struct IncomingInvites: Codable {
    let invites: [IncomingInviteModel]
}

struct OutgoingMatchModel: Codable, Hashable {
    public var to_name = ""
    public var match_id = 0
}

struct IncomingMatchModel: Codable, Hashable {
    public var from_name = ""
    public var match_id = 0
}

struct IncomingMatches: Codable {
    let matches: [IncomingMatchModel]
}

struct OutgoingMatches: Codable {
    let matches: [OutgoingMatchModel]
}

// MARK: Tab View


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
            SearchView(accessToken: userData.access_token)
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }
            NotificationsView(accessToken: userData.access_token)
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

// MARK: Main Boards View
struct MainBoardsView: View {
    
    var accessToken: String
    @State private var menuIndex: Int = 0
    @State private var navigateTo: String? = nil
    @State var enableCreateBoard = false
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
                                        NavigationLink(destination: BoardDetails(accessToken: self.accessToken, boardId: board.board_id)) {
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
                                NavigationLink(destination: AddBoardView(accessToken: self.accessToken), isActive: self.$enableCreateBoard) {
                                    EmptyView()
                                }
                                .navigationBarTitle(Text("Boards"), displayMode: .inline)
                                .navigationBarItems(trailing: Button(action: {self.enableCreateBoard = true}) {
                                    VStack {
                                        Spacer()
                                        Image(systemName: "note.text.badge.plus")
                                            .resizable()
                                            .frame(width: 30.0, height: 27.0)
                                    }
                                })
                            }
                        }
                    }
                    else {
                        ScrollView {
                            VStack (alignment: .leading) {
                                ForEach(fetchBoards.myBoards, id: \.self) { board in
                                    HStack {
                                        NavigationLink(destination: BoardDetails(accessToken: self.accessToken, boardId: board.board_id)) {
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
                                    NavigationLink(destination: AddBoardView(accessToken: self.accessToken), isActive: self.$enableCreateBoard) {
                                        EmptyView()
                                    }
                                    .navigationBarTitle(Text("Boards"), displayMode: .inline)
                                    .navigationBarItems(trailing: Button(action: {self.enableCreateBoard = true}) {
                                        VStack {
                                            Spacer()
                                            Image(systemName: "note.text.badge.plus")
                                                .resizable()
                                                .frame(width: 30.0, height: 27.0)
                                        }
                                    })
                                }
                            }
                        }
                    }
                }
            }.onAppear {
                self.fetchBoards.fetchBoards(accessToken: self.accessToken)
                self.enableCreateBoard = false
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

// MARK: Add Boards View
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


// MARK: Profile View
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

// MARK: SpecificProfileView
struct SpecificProfileView: View {
    
    var accessToken: String
    var userID: Int
    @ObservedObject var fetchSpecificProfile: FetchSpecificProfile
    
    init(accessToken: String, userID: Int) {
        self.accessToken = accessToken
        self.userID = userID
        self.fetchSpecificProfile = FetchSpecificProfile(accessToken: accessToken, userID: userID)
    }
    
    
    var body: some View {
        
        VStack{
            Text("\(fetchSpecificProfile.name)").font(.largeTitle).bold()
            Divider()
            Text("Top Boards").font(.system(size: 23)).padding(.top, 30)
            VStack (alignment: .leading) {
                ForEach(fetchSpecificProfile.favourite_boards, id: \.self) { board in
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
                NavigationLink(destination: SpecificProfileBoards(accessToken: accessToken, userID: userID)) {
                    HStack {
                        Text("Boards").foregroundColor(Color(UIColor.label))
                        Spacer()
                        Text("\(fetchSpecificProfile.board_count)").foregroundColor(Color(UIColor.label))
                        Image(systemName: "chevron.right").padding(EdgeInsets(top: 0, leading: 27, bottom: 0, trailing: 20)).foregroundColor(.gray)
                    }.padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                }
                Divider()
                NavigationLink(destination: SpecificProfileActivity(accessToken: accessToken, userID: self.userID)) {
                    HStack {
                        Text("Activity").foregroundColor(Color(UIColor.label))
                        Spacer()
                        Text("\(fetchSpecificProfile.matches_count)").foregroundColor(Color(UIColor.label))
                        Image(systemName: "chevron.right").padding(EdgeInsets(top: 0, leading: 27, bottom: 0, trailing: 20)).foregroundColor(.gray)
                    }.padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                }
                Divider()
            }
        }.padding(.top, 20)
        .onAppear {
            self.fetchSpecificProfile.fetchSpecificProfile()
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

// MARK: Profile Boards View
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

// MARK: Specific Profile Boards View
struct SpecificProfileBoards: View {
    
    var accessToken: String
    var userID: Int
    @ObservedObject var fetchSpecificProfileBoards: FetchSpecificProfileBoards
    
    init(accessToken: String, userID: Int) {
        self.accessToken = accessToken
        self.userID = userID
        self.fetchSpecificProfileBoards = FetchSpecificProfileBoards(accessToken: accessToken, userID: userID)
        self.fetchSpecificProfileBoards.fetchSpecificProfileBoards(accessToken: self.accessToken, userID: self.userID)
    }
    
    var body: some View {
        VStack{
            ScrollView {
                VStack (alignment: .leading) {
                    ForEach(fetchSpecificProfileBoards.boards, id: \.self) { board in
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

// MARK: Profile Activity View
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

// MARK: Specific Profile Activity View
struct SpecificProfileActivity: View {
    
    var accessToken: String
    var userID: Int
    @ObservedObject var fetchSpecificProfileActivity: FetchSpecificProfileActivity
    
    init(accessToken: String, userID: Int) {
        self.accessToken = accessToken
        self.userID = userID
        self.fetchSpecificProfileActivity = FetchSpecificProfileActivity(accessToken: accessToken, userID: userID)
        self.fetchSpecificProfileActivity.fetchSpecificProfileActivity(accessToken: self.accessToken, userID: self.userID)
    }
    
    var body: some View {
        VStack {
            ScrollView {
                VStack (alignment: .leading) {
                    ForEach(fetchSpecificProfileActivity.activities, id: \.self) { activity in
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
        }.navigationBarTitle(Text("Activity"), displayMode: .inline)
    }
}

// MARK: Boards Activity View
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
        }.navigationBarTitle(Text("Board Activity"), displayMode: .inline).onAppear{
            self.fetchBoardsActivity.fetchBoardsActivity()
        }
    }
}

// MARK: Board Details
struct BoardDetails: View {
    
    var accessToken: String
    var boardId: Int
    @ObservedObject var fetchBoardDetails: FetchBoardDetails
    @ObservedObject var joinBoardViewModel = JoinBoardViewModel()
    @ObservedObject var leaveBoardViewModel = RemoveFromBoardViewModel()
    
    @State private var popupMessage = ""
    @State private var showingPopup = false
    
    init(accessToken: String, boardId: Int) {
        self.accessToken = accessToken
        self.boardId = boardId
        self.fetchBoardDetails = FetchBoardDetails(accessToken: accessToken, boardId: boardId)
        self.joinBoardViewModel.board_id = boardId
        self.leaveBoardViewModel.board_id = boardId
        self.leaveBoardViewModel.remove = false
    }
    
    var body: some View {
        VStack {
            Text("Top Players").font(.system(size: 23)).padding(.top, 30)
            VStack (alignment: .leading) {
                ForEach(fetchBoardDetails.top_members, id: \.self) { member in
                    HStack {
                        HStack {
                            Image(systemName: "seal.fill").foregroundColor(getIconColor(iconInt: member.rank_icon)).padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                            VStack (alignment: .leading) {
                                Text(member.name)
                                Text("#\(member.rank)")
                                    .font(.system(size: 15))
                                    .foregroundColor(.gray)
                            }
                        }.padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
                        Spacer()
                        HStack {
                            VStack (alignment: .trailing) {
                                Text(String(format: "%.1f", member.rating))
                                Text("\(member.wins)W / \(member.losses)L")
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
                NavigationLink(destination: BoardMembersView(accessToken: accessToken, boardId: self.boardId, isAdmin: self.fetchBoardDetails.is_admin)) {
                    HStack {
                        Text("Members").foregroundColor(Color(UIColor.label))
                        Spacer()
                        Text("\(fetchBoardDetails.member_count)").foregroundColor(Color(UIColor.label))
                        Image(systemName: "chevron.right").padding(EdgeInsets(top: 0, leading: 27, bottom: 0, trailing: 20)).foregroundColor(.gray)
                    }.padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                }
                Divider()
                NavigationLink(destination: BoardActivity(accessToken: accessToken, boardId: self.boardId)) {
                    HStack {
                        Text("Activity").foregroundColor(Color(UIColor.label))
                        Spacer()
                        Text("\(fetchBoardDetails.matches_count)").foregroundColor(Color(UIColor.label))
                        Image(systemName: "chevron.right").padding(EdgeInsets(top: 0, leading: 27, bottom: 0, trailing: 20)).foregroundColor(.gray)
                    }.padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                }
                Divider()
                    .alert(isPresented:$showingPopup) {
                        Alert(title: Text(self.popupMessage), message: Text(""), dismissButton: .default(Text("OK")) {
                            self.popupMessage = ""
                            self.showingPopup = false
                        })
                    }
            }
        }.navigationBarTitle(Text("\(fetchBoardDetails.board_name)"), displayMode: .inline)
        .onAppear {
            fetchBoardDetails.fetchBoardDetails(accessToken: self.accessToken, boardId: self.boardId)
        }
        .onDisappear {
            self.popupMessage = ""
            self.showingPopup = false
        }
        .navigationBarItems(trailing: Button(action: {
            if !fetchBoardDetails.is_member && fetchBoardDetails.is_public {
                // synchronous join then reload
                if joinBoard() {
                    self.popupMessage = "Joined \(self.fetchBoardDetails.board_name)!"
                    self.showingPopup = true
                }
                fetchBoardDetails.fetchBoardDetails(accessToken: self.accessToken, boardId: self.boardId)
            }
            else if fetchBoardDetails.is_member && !fetchBoardDetails.is_admin {
                // synchronous leave then reload
                if leaveBoard() {
                    self.popupMessage = "Left \(self.fetchBoardDetails.board_name)!"
                    self.showingPopup = true
                }
                fetchBoardDetails.fetchBoardDetails(accessToken: self.accessToken, boardId: self.boardId)
            }
        }) {
            VStack {
                // Spacer()
                if !fetchBoardDetails.is_member && fetchBoardDetails.is_public {
                    Image(systemName: "plus.square.fill")
                        .resizable()
                        .frame(width: 32.0, height: 32.0)
                }
                else if fetchBoardDetails.is_member && !fetchBoardDetails.is_admin {
                    Image(systemName: "minus.square.fill")
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
    
    func joinBoard() -> Bool {
        
        struct JoinBoardResponse: Decodable {
            let success: Bool
            let message: String
        }
        var success = false
        let sem = DispatchSemaphore.init(value: 0)
        
        guard let encoded = try? JSONEncoder().encode(joinBoardViewModel)
        else {
            print("Failed to encode creation of join board request")
            return false
        }
        
        let url = URL(string: (apiURL + "/board/join"))!
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
            
            if let joinBoardResponse = try? JSONDecoder().decode(JoinBoardResponse.self, from: data) {
                print("Board joined successfully!")
                if (joinBoardResponse.success) {
                    success = true
                }
            } else {
                print("Invalid response from server")
                
            }
        }.resume()
        
        sem.wait() // bad
        
        return success
    }
    
    func leaveBoard() -> Bool {
        
        struct LeaveBoardResponse: Decodable {
            let success: Bool
            let message: String
        }
        var success = false
        let sem = DispatchSemaphore.init(value: 0)
        
        guard let encoded = try? JSONEncoder().encode(leaveBoardViewModel)
        else {
            print("Failed to encode creation of leave board request")
            return false
        }
        
        let url = URL(string: (apiURL + "/board/remove"))!
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
            
            if let leaveBoardResponse = try? JSONDecoder().decode(LeaveBoardResponse.self, from: data) {
                print("Board left successfully!")
                if (leaveBoardResponse.success) {
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

// MARK: Board Members View
struct BoardMembersView: View {
    
    @State var selectedTag: String?
    @State var enableAddMember = false
    
    var isAdmin: Bool
    var accessToken: String
    var boardId: Int
    var is_admin = false
    @ObservedObject var fetchMembers: FetchBoardMembers
    @ObservedObject var fetchProfile: FetchProfile
    
    init(accessToken: String, boardId: Int, isAdmin: Bool) {
        self.accessToken = accessToken
        self.boardId = boardId
        self.isAdmin = isAdmin
        self.fetchMembers = FetchBoardMembers(accessToken: accessToken,  boardID: self.boardId)
        self.fetchProfile = FetchProfile(accessToken: accessToken)
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
                NavigationLink(destination: AddMemberView(accessToken: accessToken, boardID: self.boardId), isActive: self.$enableAddMember) {
                    EmptyView()
                }
            }
        }.navigationBarTitle(Text("Board Members"), displayMode: .inline)
        .onAppear {
            self.fetchMembers.fetchBoardMembers(boardId: self.boardId)
        }
        .navigationBarItems(trailing: Button(action: {self.enableAddMember = true}) {
            if self.isAdmin {
                VStack {
                    Spacer()
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

// MARK: Submit Match View
struct SubmitMatchView: View {
    
    @EnvironmentObject var userData: UserData
    
    var accessToken: String
    @State var boardExpansion: Bool = false
    @State var opponentExpansion: Bool = false
    @State var resultExpansion: Bool = false
    @State var selectedBoard: Boards = Boards()
    @State var selectedOpponent: BoardMembersModel = BoardMembersModel()
    @State var selectedResult: String = ""
    @State private var popupMessage = ""
    @State private var showingPopup = false
    @ObservedObject var fetchBoardMembers: FetchBoardMembers
    @ObservedObject var fetchBoards: FetchBoards
    @ObservedObject var submitMatchViewModel = SubmitMatchViewModel()
    
    init(accessToken: String) {
        self.accessToken = accessToken
        self.fetchBoards = FetchBoards(accessToken: accessToken)
        self.fetchBoardMembers = FetchBoardMembers(accessToken: accessToken,  boardID: 0)
    }
    
    var body: some View {
        NavigationView {
            VStack {
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
                                    self.fetchBoardMembers.fetchBoardMembers(boardId: board.board_id)
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
                                if opponent.user_id != userData.userId {
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
                                Image(systemName: "hands.clap.fill").foregroundColor((self.selectedResult == "Draw" || self.selectedResult == "" ? tie : .gray))
                                    .font(.system(size: 100))
                                Text("Draw")
                            }.onTapGesture {
                                self.selectedResult = "Draw"
                            }.padding(EdgeInsets(top: 20, leading: 0, bottom: 20, trailing: 0))
                            Button(action: trySubmitMatch) {
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
                Spacer()
                    .alert(isPresented:$showingPopup) {
                        Alert(title: Text(self.popupMessage), message: Text(""), dismissButton: .default(Text("OK")) {
                            self.popupMessage = ""
                            self.showingPopup = false
                        })
                    }
            }
        }
        .listStyle(GroupedListStyle())
        .onAppear{
            self.fetchBoards.fetchBoards(accessToken: self.accessToken)
        }
        .onDisappear {
            popupMessage = ""
            showingPopup = false
        }
    }
    
    func trySubmitMatch() {
        if selectedResult == "" {
            self.popupMessage = "You must select a result!"
            self.showingPopup = true
            return
        }
        
        // synchronous submit then reset
        
        // put state variables in observableobject
        submitMatchViewModel.board_id = selectedBoard.board_id
        submitMatchViewModel.user_id = selectedOpponent.user_id
        submitMatchViewModel.result = selectedResult
        
        if !submitMatch() {
            // pop error with error message
            return
        }
        
        boardExpansion = false
        opponentExpansion = false
        resultExpansion = false
        selectedBoard = Boards()
        selectedOpponent = BoardMembersModel()
        selectedResult = ""
        self.popupMessage = "Match submitted!"
        self.showingPopup = true
    }
    
    func submitMatch() -> Bool {
        
        struct SubmitMatchResponse: Decodable {
            let success: Bool
            let message: String
        }
        var success = false
        let sem = DispatchSemaphore.init(value: 0)
        
        guard let encoded = try? JSONEncoder().encode(submitMatchViewModel)
        else {
            print("Failed to encode creation of submit match request")
            return false
        }
        
        let url = URL(string: (apiURL + "/submit/"))!
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
            
            if let submitMatchResponse = try? JSONDecoder().decode(SubmitMatchResponse.self, from: data) {
                print("Match submitted successfully!")
                if (submitMatchResponse.success) {
                    success = true
                }
            } else {
                print("Invalid response from server")
                
            }
        }.resume()
        
        sem.wait() // bad
        
        return success
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


// MARK: Add Members View
struct AddMemberView: View {
    
    
    @State private var confirmationMessage = ""
    @State private var showingConfirmation = false
    @State var userToAdd = Users()
    @State var searchTerm = ""
    
    var boardID: Int
    var accessToken: String
    @ObservedObject var fetchUsersToAdd: FetchUsersToAdd
    @ObservedObject var addMemberViewModel = AddMemberViewModel()
    
    init(accessToken: String, boardID: Int) {
        self.accessToken = accessToken
        self.boardID = boardID
        self.fetchUsersToAdd = FetchUsersToAdd(accessToken: accessToken, boardID: boardID)
    }
    
    
    var body: some View {
        VStack{
            TextField("Search...", text: self.$searchTerm, onCommit: {
                fetchUsersToAdd.searchUsersToAdd(searchTerm: searchTerm)
            })
            .padding()
            .foregroundColor(Color.black)
            .background(Color.init(UIColor.systemGray6))
            .cornerRadius(20.0)
            .padding(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0))
            ScrollView {
                VStack (alignment: .leading) {
                    ForEach(fetchUsersToAdd.userResults, id: \.self) { user in
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
                                    showingConfirmation = true
                                    userToAdd = user
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
                            .alert(isPresented:$showingConfirmation) {
                                Alert(title: Text("Invite \(userToAdd.name) to board?"), message: Text(""), primaryButton: .default(Text("Invite")) {
                                    inviteMember(user: userToAdd)
                                    fetchUsersToAdd.removeUser(user: userToAdd)
                                }, secondaryButton: .cancel())
                            }
                    }
                }
            }
            Spacer()
            Spacer()
        }.navigationBarTitle(Text("Add Member"), displayMode: .inline).onAppear{
            fetchUsersToAdd.searchUsersToAdd(searchTerm: searchTerm)
        }.onDisappear{
            confirmationMessage = ""
            showingConfirmation = false
        }
        
    }
    
    func inviteMember(user: Users) {
        self.addMemberViewModel.user_id = user.id
        self.addMemberViewModel.board_id = boardID
        
        struct RegistrationToken: Decodable {
            let success: Bool
            let message: String
        }
        
        guard let encoded = try? JSONEncoder().encode(addMemberViewModel)
        else {
            print("Failed to encode creation of member request")
            return
        }
        
        let url = URL(string: (apiURL + "/board/invite"))!
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
            
            if let createMemberResponse = try? JSONDecoder().decode(RegistrationToken.self, from: data) {
                print("Member added successfully!")
            } else {
                print("Invalid response from server")
            }
        }.resume()
        
        
    }
}



// MARK: Search View
struct SearchView: View {
    
    var accessToken: String
    @State private var searchTerm: String = ""
    @State private var menuIndex: Int = 0
    @State private var navigateTo: String? = nil
    @ObservedObject var fetchAllBoards: FetchAllBoards
    @ObservedObject var fetchUsers: FetchUsers
    
    init(accessToken: String) {
        self.accessToken = accessToken
        self.fetchAllBoards = FetchAllBoards(accessToken: accessToken)
        self.fetchUsers = FetchUsers(accessToken: accessToken)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Search...", text: self.$searchTerm, onCommit: {
                    fetchUsers.searchUsers(searchTerm: searchTerm)
                    fetchAllBoards.searchBoards(searchTerm: searchTerm)
                })
                .padding()
                .foregroundColor(Color.black)
                .background(Color.init(UIColor.systemGray6))
                .cornerRadius(20.0)
                Picker(selection: $menuIndex, label: Text("Search Type")) {
                    Text("Boards").tag(0)
                    Text("Users").tag(1)
                }.pickerStyle(SegmentedPickerStyle())
                if (menuIndex == 0) {
                    ScrollView {
                        VStack (alignment: .leading) {
                            ForEach(fetchAllBoards.allBoards, id: \.self) { board in
                                HStack {
                                    NavigationLink(destination: BoardDetails(accessToken: self.accessToken, boardId: board.id)) {
                                        HStack {
                                            VStack (alignment: .leading) {
                                                Text("\(board.name)")
                                                    .foregroundColor(Color(UIColor.label))
                                                if(board.member_count == 1){
                                                    Text("\(board.member_count) Member")
                                                        .font(.system(size: 15))
                                                        .foregroundColor(.gray)
                                                }else {
                                                    Text("\(board.member_count) Members")
                                                        .font(.system(size: 15))
                                                        .foregroundColor(.gray)
                                                }
                                                
                                                
                                            }
                                        }.padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
                                        Spacer()
                                        HStack {
                                            Image(systemName: "chevron.right").padding(EdgeInsets(top: 0, leading: 27, bottom: 0, trailing: 20)).foregroundColor(.gray)
                                        }
                                    }.navigationBarTitle(Text("Search"), displayMode: .inline)
                                    .padding(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 20))
                                }
                                Divider()
                            }
                        }
                    }
                }
                else {
                    ScrollView {
                        VStack (alignment: .leading) {
                            ForEach(fetchUsers.userResults, id: \.self) { user in
                                HStack {
                                    NavigationLink(destination: SpecificProfileView(accessToken: self.accessToken, userID: user.id)) {
                                        HStack {
                                            VStack (alignment: .leading) {
                                                Text("\(user.name)")
                                                    .foregroundColor(Color(UIColor.label))
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
                                        }.padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
                                        Spacer()
                                        HStack {
                                            Image(systemName: "chevron.right").padding(EdgeInsets(top: 0, leading: 27, bottom: 0, trailing: 20)).foregroundColor(.gray)
                                        }
                                    }.padding(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 20))
                                }
                                Divider()
                                
                            }
                            
                        }
                    }
                }
            }
        }.onAppear {
            self.fetchAllBoards.searchBoards(searchTerm: self.searchTerm)
            self.fetchUsers.searchUsers(searchTerm: self.searchTerm)
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


struct BoardActivityView: View {
    var body: some View {
        Text("Board Activity")
    }
}

// MARK: Notifications View
struct NotificationsView: View {
    var accessToken: String
    @State var showRecievedInviteView = false
    @State private var searchTerm: String = ""
    @State private var menuIndex: Int = 0
    @State private var menuIndex2: Int = 0
    @State private var menuIndex3: Int = 0
    @State private var navigateTo: String? = nil
    
    @State var inviteToRemove = IncomingInviteModel()
    
    @ObservedObject var fetchOutgoingInvites: FetchOutgoingInvites
    @ObservedObject var fetchOutgoingMatches: FetchOutgoingMatches
    @ObservedObject var fetchIncomingInvites: FetchIncomingInvites
    @ObservedObject var fetchIncomingMatches: FetchIncomingMatches
    
    init(accessToken: String) {
        self.accessToken = accessToken
        self.fetchOutgoingInvites = FetchOutgoingInvites(accessToken: accessToken)
        self.fetchIncomingInvites = FetchIncomingInvites(accessToken: accessToken)
        self.fetchOutgoingMatches = FetchOutgoingMatches(accessToken: accessToken)
        self.fetchIncomingMatches = FetchIncomingMatches(accessToken: accessToken)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Picker(selection: $menuIndex, label: Text("Search Type")) {
                    Image(systemName: "tray.and.arrow.down.fill").tag(0)
                    Image(systemName: "tray.and.arrow.up.fill").tag(1)
                }.pickerStyle(SegmentedPickerStyle())
                .navigationBarTitle(Text("Notifications"), displayMode: .inline)
                if (menuIndex == 0) {
                    ScrollView {
                        VStack {
                            Picker(selection: $menuIndex2, label: Text("Search Type")) {
                                Text("Recieved Invites").tag(0)
                                Text("Recieved Matches").tag(1)
                            }.pickerStyle(SegmentedPickerStyle())
                            if (menuIndex2 == 0) {
                                ScrollView {
                                    VStack (alignment: .leading) {
                                        ForEach(fetchIncomingInvites.incomingInvites, id: \.self) { invite in
                                            HStack {
                                                NavigationLink(destination: RecievedInviteView(accessToken: accessToken, inviteID: invite.invite_id, inviteToRemove: invite)) {
                                                    
                                                    HStack {
                                                        VStack (alignment: .leading) {
                                                            Text("\(invite.from_name)").bold() + Text(" invited you to a board")
                                                                .foregroundColor(Color(UIColor.label))
                                                            
                                                            
                                                        }
                                                    }.padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
                                                    Spacer()
                                                    HStack {
                                                        Image(systemName: "chevron.right").padding(EdgeInsets(top: 0, leading: 27, bottom: 0, trailing: 20)).foregroundColor(.gray)
                                                        
                                                    }
                                                    
                                                }.simultaneousGesture(TapGesture().onEnded{
                                                    inviteToRemove = invite
                                                })
                                                Divider()
                                                
                                            }
                                        }
                                    }
                                }
                            }
                            else {
                                ScrollView {
                                    VStack (alignment: .leading) {
                                        ForEach(fetchIncomingMatches.incomingMatches, id: \.self) { match in
                                            HStack {
                                                //NavigationLink(destination: EmptyView()) {
                                                HStack {
                                                    VStack (alignment: .leading) {
                                                        Text("\(match.from_name)").bold() + Text(" submitted a match")
                                                            .foregroundColor(Color(UIColor.label))
                                                        
                                                        
                                                    }
                                                }.padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
                                                Spacer()
                                                HStack {
                                                    Image(systemName: "chevron.right").padding(EdgeInsets(top: 0, leading: 27, bottom: 0, trailing: 20)).foregroundColor(.gray)
                                                }
                                                //}
                                            }
                                            Divider()
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                else {
                    ScrollView {
                        VStack {
                            Picker(selection: $menuIndex3, label: Text("Search Type")) {
                                Text("Sent Invites").tag(0)
                                Text("Sent Matches").tag(1)
                            }.pickerStyle(SegmentedPickerStyle())
                            if (menuIndex3 == 0) {
                                ScrollView {
                                    VStack (alignment: .leading) {
                                        ForEach(fetchOutgoingInvites.outgoingInvites, id: \.self) { invite in
                                            HStack {
                                                //NavigationLink(destination: BoardDetails(accessToken: self.accessToken, boardId: board.id)) {
                                                HStack {
                                                    VStack (alignment: .leading) {
                                                        Text("You invited ") + Text("\(invite.to_name)").bold() + Text(" to a board")
                                                            .foregroundColor(Color(UIColor.label))
                                                        
                                                        
                                                    }
                                                }.padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
                                                Spacer()
                                                HStack {
                                                    Image(systemName: "chevron.right").padding(EdgeInsets(top: 0, leading: 27, bottom: 0, trailing: 20)).foregroundColor(.gray)
                                                }
                                                //}
                                            }
                                            Divider()
                                        }
                                    }
                                }
                            }
                            else {
                                ScrollView {
                                    VStack (alignment: .leading) {
                                        ForEach(fetchOutgoingMatches.outgoingMatches, id: \.self) { match in
                                            HStack {
                                                //NavigationLink(destination: BoardDetails(accessToken: self.accessToken, boardId: board.id)) {
                                                HStack {
                                                    VStack (alignment: .leading) {
                                                        Text("Submitted match against ") + Text("\(match.to_name)").bold()
                                                            .foregroundColor(Color(UIColor.label))
                                                        
                                                        
                                                    }
                                                }.padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
                                                Spacer()
                                                HStack {
                                                    Image(systemName: "chevron.right").padding(EdgeInsets(top: 0, leading: 27, bottom: 0, trailing: 20)).foregroundColor(.gray)
                                                }
                                                //}
                                            }
                                            Divider()
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }.onAppear {
                self.fetchOutgoingInvites.fetchOutInvites()
                self.fetchOutgoingMatches.fetchOutMatches()
                self.fetchIncomingInvites.fetchIncomingInvites()
                self.fetchIncomingMatches.fetchIncomingMatches()
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

struct RecievedInviteView: View {
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    var accessToken: String
    var inviteID: Int
    @ObservedObject var fetchIncomingInviteDetails: FetchIncomingInviteDetails
    @ObservedObject var boardInviteResponseModel = BoardInviteResponseModel()
    @ObservedObject var fetchIncomingInvites: FetchIncomingInvites
    
    init(accessToken: String, inviteID: Int, inviteToRemove: IncomingInviteModel) {
        self.accessToken = accessToken
        self.inviteID = inviteID
        self.fetchIncomingInviteDetails = FetchIncomingInviteDetails(accessToken: accessToken, inviteID: inviteID)
        self.fetchIncomingInvites = FetchIncomingInvites(accessToken: accessToken)
    }
    
    var body: some View {
        VStack(spacing: 10){
            Spacer()
            Text("\(fetchIncomingInviteDetails.from_name) invited you to")
            Text("\(fetchIncomingInviteDetails.board_name)").font(.largeTitle).bold()
            Spacer()
            HStack{
                Button(action: {
                    self.acceptInvite(accepted: false)
                    self.mode.wrappedValue.dismiss()
                }) {
                    HStack(alignment: .center) {
                        Spacer()
                        Text("Decline Invite").foregroundColor(btnColor).bold()
                        Spacer()
                    }
                    .padding()
                    .background(Color.red)
                    .cornerRadius(20.0)
                    .buttonStyle(PlainButtonStyle())
                }
                Spacer()
                Button(action: {
                    acceptInvite(accepted: true)
                    self.mode.wrappedValue.dismiss()
                    
                }) {
                    HStack(alignment: .center) {
                        Spacer()
                        Text("Accept Invite").foregroundColor(btnColor).bold()
                        Spacer()
                    }
                }.padding()
                .background(bgColor)
                .cornerRadius(20.0)
                .buttonStyle(PlainButtonStyle())
            }.padding()
            Spacer()
        }.onAppear {
            self.fetchIncomingInviteDetails.fetchIncomingInviteDetails(accessToken: self.accessToken, inviteID: self.inviteID)
        }
    }
    func acceptInvite(accepted: Bool) -> Bool {
        print(accepted, self.inviteID)
        
        self.boardInviteResponseModel.accept = accepted
        self.boardInviteResponseModel.invite_id = self.inviteID
        
        struct AcceptInviteResponse: Decodable {
            let success: Bool
            let message: String
        }
        var success = false
        let sem = DispatchSemaphore.init(value: 0)
        
        guard let encoded = try? JSONEncoder().encode(boardInviteResponseModel)
        else {
            print("Failed to encode creation of invite response request")
            return false
        }
        
        let url = URL(string: (apiURL + "/notification/invite"))!
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
            
            if let acceptInviteResponse = try? JSONDecoder().decode(AcceptInviteResponse.self, from: data) {
                print("Invite Responded to successfully!")
                if (acceptInviteResponse.success) {
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


struct ParentView_Previews: PreviewProvider {
    static var previews: some View {
        TabParent().environmentObject(UserData())
    }
}
