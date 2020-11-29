//
//  TabViewModel.swift
//  OpenLeaderboard
//
//  Created by Tim Lyster on 2020-10-29.
//  Copyright © 2020 OpenLeaderboard. All rights reserved.
//

import Foundation
import UIKit


class FetchUsersToAdd: ObservableObject {
    
    @Published var userResults = [Users]()
    
    var accessToken: String
    var boardID: Int
    
    init(accessToken: String, boardID: Int) {
        self.accessToken = accessToken
        self.boardID = boardID
    }
    
    public func fetchUsersToAdd() {
        let url = URL(string: (apiURL + "/user/search/notinboard/\(self.boardID)"))!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(self.accessToken, forHTTPHeaderField: "authorization")
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) {
            data, response, error in
            do {
                if let usersData = data {
                    let decodedData = try JSONDecoder().decode(AllUsers.self, from: usersData)
                    let decodedUsers = decodedData.search_result
                DispatchQueue.main.async {
                    self.userResults = decodedUsers
                    print(self.userResults)
                }
                } else {
                    print("No users data was returned!")
                }
            } catch {
                print("There was an error getting users data: \(error)")
            }
        }.resume()
    }
    
    public func removeUser(user: Users) {
        guard let index = userResults.firstIndex(of: user) else {return}
        userResults.remove(at: index)
    }
}


class FetchUsers: ObservableObject {
    
    @Published var userResults = [Users]()
    
    var accessToken: String
    
    init(accessToken: String) {
        self.accessToken = accessToken
    }
    
    public func fetchUsers(accessToken: String) {
        self.accessToken = accessToken
        let url = URL(string: (apiURL + "/user/search"))!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(self.accessToken, forHTTPHeaderField: "authorization")
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) {
            data, response, error in
            do {
                if let usersData = data {
                    let decodedData = try JSONDecoder().decode(AllUsers.self, from: usersData)
                    let decodedUsers = decodedData.search_result
                    DispatchQueue.main.async {
                        self.userResults = decodedUsers
                    }
                } else {
                    print("No users data was returned!")
                }
            } catch {
                print("There was an error getting users data: \(error)")
            }
        }.resume()
    }
    
    public func searchUsers(searchTerm: String) {
        if searchTerm == "" {
            fetchUsers(accessToken: self.accessToken)
            return
        }
        
        let url = URL(string: (apiURL + "/user/search/" + searchTerm))!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(self.accessToken, forHTTPHeaderField: "authorization")
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) {
            data, response, error in
            do {
                if let usersData = data {
                    let decodedData = try JSONDecoder().decode(AllUsers.self, from: usersData)
                    let decodedUsers = decodedData.search_result
                    DispatchQueue.main.async {
                        self.userResults = decodedUsers
                    }
                } else {
                    print("No users data was returned!")
                }
            } catch {
                print("There was an error getting users data: \(error)")
            }
        }.resume()
    }
}


class FetchBoards: ObservableObject {
    
    @Published var boards = [Boards]()
    @Published var myBoards = [Boards]()
    
    var accessToken: String
    
    init(accessToken: String) {
        self.boards = []
        self.myBoards = []
        self.accessToken = accessToken
    }
    
    public func fetchBoards(accessToken: String) {
        self.accessToken = accessToken
        let url = URL(string: (apiURL + "/user/boards"))!
        let myUrl = URL(string: (apiURL + "/user/boards/mine"))!
        var request = URLRequest(url: url)
        var myBoardsRequest = URLRequest(url: myUrl)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        myBoardsRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(self.accessToken, forHTTPHeaderField: "authorization")
        myBoardsRequest.setValue(self.accessToken, forHTTPHeaderField: "authorization")
        request.httpMethod = "GET"
        myBoardsRequest.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) {
            data, response, error in
            do {
                if let boardsData = data {
                    let decodedData = try JSONDecoder().decode(Initial.self, from: boardsData)
                    let decodedBoards = decodedData.boards
                DispatchQueue.main.async {
                    self.boards = decodedBoards
                }
                } else {
                    print("No boards data was returned!")
                }
            } catch {
                print("There was an error getting boards data!")
            }
        }.resume()
        
        URLSession.shared.dataTask(with: myBoardsRequest) {
            data, response, error in
            do {
                if let myBoardsData = data {
                    let decodedData = try JSONDecoder().decode(Initial.self, from: myBoardsData)
                    let decodedBoards = decodedData.boards
                DispatchQueue.main.async {
                    self.myBoards = decodedBoards
                }
                } else {
                    print("No boards data was returned!")
                }
            } catch {
                print("There was an error getting boards data!")
            }
        }.resume()
    }
}


class FetchSpecificProfileBoards: ObservableObject {
    
    @Published var boards = [Boards]()
    
    var accessToken: String
    var userID: Int
    
    init(accessToken: String, userID: Int) {
        self.boards = []
        self.userID = userID
        self.accessToken = accessToken
    }
    
    public func fetchSpecificProfileBoards(accessToken: String, userID: Int) {
        self.accessToken = accessToken
        self.userID = userID
        let url = URL(string: (apiURL + "/user/\(userID)/boards"))!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(self.accessToken, forHTTPHeaderField: "authorization")
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) {
            data, response, error in
            do {
                if let boardsData = data {
                    let decodedData = try JSONDecoder().decode(Initial.self, from: boardsData)
                    let decodedBoards = decodedData.boards
                DispatchQueue.main.async {
                    self.boards = decodedBoards
                }
                } else {
                    print("No boards data was returned!")
                }
            } catch {
                print("There was an error getting boards data!")
            }
        }.resume()
        
    }
}

class FetchAllBoards: ObservableObject {
    
    @Published var allBoards = [SearchBoards]()
    
    var accessToken: String
    
    init(accessToken: String) {
        self.allBoards = []
        self.accessToken = accessToken
    }
    
    public func fetchAllBoards(accessToken: String) {
        self.accessToken = accessToken
        let url = URL(string: (apiURL + "/board/search"))!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(self.accessToken, forHTTPHeaderField: "authorization")
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) {
            data, response, error in
            do {
                if let boardsData = data {
                    let decodedData = try JSONDecoder().decode(AllBoards.self, from: boardsData)
                    let decodedBoards = decodedData.search_result
                DispatchQueue.main.async {
                    self.allBoards = decodedBoards
                }
                } else {
                    print("No boards data was returned!")
                }
            } catch {
                print("There was an error getting all boards data!")
            }
        }.resume()
        
    }
    
    public func searchBoards(searchTerm: String) {
        if searchTerm == "" {
            fetchAllBoards(accessToken: self.accessToken)
            return
        }
        
        let url = URL(string: (apiURL + "/board/search/" + searchTerm))!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(self.accessToken, forHTTPHeaderField: "authorization")
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) {
            data, response, error in
            do {
                if let boardsData = data {
                    let decodedData = try JSONDecoder().decode(AllBoards.self, from: boardsData)
                    let decodedBoards = decodedData.search_result
                DispatchQueue.main.async {
                    self.allBoards = decodedBoards
                }
                } else {
                    print("No boards data was returned!")
                }
            } catch {
                print("There was an error getting all boards data!")
            }
        }.resume()
    }
}


class FetchProfile: ObservableObject {

    @Published var user_id: Int = 0
    @Published var board_count: Int = 0
    @Published var matches_count: Int = 0
    @Published var name: String = ""
    @Published var favourite_boards = [Boards]()

    var accessToken: String

    init(accessToken: String) {
        favourite_boards = []
        self.accessToken = accessToken
    }
    
    public func fetchProfile(accessToken: String) {
        self.accessToken = accessToken
        let url = URL(string: (apiURL + "/user/profile"))!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(self.accessToken, forHTTPHeaderField: "authorization")
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request) {
            data, response, error in
            do {
                if let profileData = data {
                    let decodedData = try JSONDecoder().decode(Profile.self, from: profileData)
                    
                DispatchQueue.main.async {
                    self.user_id = decodedData.user_id
                    self.name = decodedData.name
                    self.board_count = decodedData.board_count
                    self.matches_count = decodedData.matches_count
                    self.favourite_boards = decodedData.favourite_boards
                }
                } else {
                    print("No profile data was returned!")
                }
            } catch {
                print("There was an error getting profile data!")
            }
        }.resume()
    }
}

class FetchSpecificProfile: ObservableObject {

    @Published var user_id: Int = 0
    @Published var board_count: Int = 0
    @Published var matches_count: Int = 0
    @Published var name: String = ""
    @Published var favourite_boards = [Boards]()
    

    var accessToken: String
    var userID: Int

    init(accessToken: String, userID: Int) {
        favourite_boards = []
        self.userID = userID
        self.accessToken = accessToken
    }
    
    public func fetchSpecificProfile() {
        let url = URL(string: (apiURL + "/user/\(self.userID)"))!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(self.accessToken, forHTTPHeaderField: "authorization")
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request) {
            data, response, error in
            do {
                if let profileData = data {
                    let decodedData = try JSONDecoder().decode(Profile.self, from: profileData)
                    
                DispatchQueue.main.async {
                    self.user_id = decodedData.user_id
                    self.name = decodedData.name
                    self.board_count = decodedData.board_count
                    self.matches_count = decodedData.matches_count
                    self.favourite_boards = decodedData.favourite_boards
                }
                } else {
                    print("No profile data was returned!")
                }
            } catch {
                print("There was an error getting profile data!")
            }
        }.resume()
    }
}

class FetchSpecificProfileActivity: ObservableObject {

    @Published var activities = [Activity]()
    
    var accessToken: String
    var userID: Int

    init(accessToken: String, userID: Int) {
        self.accessToken = accessToken
        self.activities = []
        self.userID = userID
    }
    
    public func fetchSpecificProfileActivity(accessToken: String, userID: Int) {
        self.accessToken = accessToken
        self.userID = userID
        let url = URL(string: (apiURL + "/user/\(self.userID)/activity"))!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(self.accessToken, forHTTPHeaderField: "authorization")
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request) {
            data, response, error in
            do {
                if let activityData = data {
                    let decodedData = try JSONDecoder().decode(Activities.self, from: activityData)
                    let decodedActivities = decodedData.matches
                    
                DispatchQueue.main.async {
                    self.activities = decodedActivities
                }
                } else {
                    print("No activity data was returned!")
                }
            } catch {
                print("There was an error getting activity data!")
            }
        }.resume()
    }
}

class FetchProfileActivity: ObservableObject {

    @Published var activities = [Activity]()
    
    var accessToken: String

    init(accessToken: String) {
        self.accessToken = accessToken
        self.activities = []
    }
    
    public func fetchActivity(accessToken: String) {
        self.accessToken = accessToken
        let url = URL(string: (apiURL + "/user/activity"))!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(self.accessToken, forHTTPHeaderField: "authorization")
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request) {
            data, response, error in
            do {
                if let activityData = data {
                    let decodedData = try JSONDecoder().decode(Activities.self, from: activityData)
                    let decodedActivities = decodedData.matches
                    
                DispatchQueue.main.async {
                    self.activities = decodedActivities
                }
                } else {
                    print("No activity data was returned!")
                }
            } catch {
                print("There was an error getting activity data!")
            }
        }.resume()
    }
}

class FetchBoardsActivity: ObservableObject {

    @Published var boardActivities = [BoardActivityModel]()
    
    var accessToken: String
    var boardID: Int
    
    init(accessToken: String, boardID: Int) {
        self.accessToken = accessToken
        self.boardID = boardID
    }
    
    public func fetchBoardsActivity() {
        let url = URL(string: (apiURL + "/board/\(self.boardID)/activity"))!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(self.accessToken, forHTTPHeaderField: "authorization")
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request) {
            data, response, error in
            do {
                if let boardActivityData = data {
                    let decodedData = try JSONDecoder().decode(BoardActivities.self, from: boardActivityData)
                    let decodedActivities = decodedData.matches
                    
                DispatchQueue.main.async {
                    self.boardActivities = decodedActivities
                }
                } else {
                    print("No activity data was returned!")
                }
            } catch {
                print("There was an error getting activity data!")
            }
        }.resume()
    }
}

class FetchBoardMembers: ObservableObject {

    @Published var boardMembers = [BoardMembersModel]()
    
    var accessToken: String
    var boardID: Int
    
    init(accessToken: String, boardID: Int) {
        self.accessToken = accessToken
        self.boardID = boardID
    }
    
    public func fetchBoardMembers() {
        let url = URL(string: (apiURL + "/board/\(self.boardID)/members"))!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(self.accessToken, forHTTPHeaderField: "authorization")
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request) {
            data, response, error in
            do {
                if let boardMemberData = data {
                    let decodedData = try JSONDecoder().decode(BoardMembers.self, from: boardMemberData)
                    let decodedActivities = decodedData.members
                    
                DispatchQueue.main.async {
                    self.boardMembers = decodedActivities
                }
                } else {
                    print("No activity data was returned!")
                }
            } catch {
                print("There was an error getting activity data!")
            }
        }.resume()
    }
}


class FetchBoardDetails: ObservableObject {

    @Published var board_id: Int = 0
    @Published var board_name: String = ""
    @Published var is_public: Bool = false
    @Published var is_admin: Bool = false
    @Published var is_member: Bool = false
    @Published var matches_count: Int = 0
    @Published var member_count: Int = 0
    @Published var top_members = [BoardMembersModel]()

    var accessToken: String
    var boardId: Int

    init(accessToken: String, boardId: Int) {
        top_members = []
        self.accessToken = accessToken
        self.boardId = boardId
    }
    
    public func fetchBoardDetails(accessToken: String, boardId: Int) {
        self.accessToken = accessToken
        self.boardId = boardId
        let url = URL(string: (apiURL + "/board/\(self.boardId)"))!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(self.accessToken, forHTTPHeaderField: "authorization")
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request) {
            data, response, error in
            do {
                if let boardDetailsData = data {
                    let decodedData = try JSONDecoder().decode(BoardDetailsModel.self, from: boardDetailsData)
                    
                    DispatchQueue.main.async {
                        self.board_id = decodedData.board_id
                        self.board_name = decodedData.board_name
                        self.is_public = decodedData.is_public
                        self.is_admin = decodedData.is_admin
                        self.is_member = decodedData.is_member
                        self.matches_count = decodedData.matches_count
                        self.member_count = decodedData.member_count
                        self.top_members  = decodedData.top_members
                    }
                } else {
                    print("No board details data was returned!")
                }
            } catch {
                print("There was an error getting board details data!")
            }
        }.resume()
    }
}

