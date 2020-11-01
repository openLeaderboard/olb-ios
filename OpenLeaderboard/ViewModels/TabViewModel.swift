//
//  TabViewModel.swift
//  OpenLeaderboard
//
//  Created by Tim Lyster on 2020-10-29.
//  Copyright © 2020 OpenLeaderboard. All rights reserved.
//

import Foundation
import UIKit

class FetchBoards: ObservableObject {
    
    @Published var boards = [Boards]()
    
    var accessToken: String
    
    init(accessToken: String) {
        self.accessToken = accessToken
        let url = URL(string: (apiURL + "/user/boards"))!
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
                    print(self.boards)
                }
                } else {
                    print("No boards data was returned!")
                }
            } catch {
                print(String(data: data!, encoding: .utf8))
                print(data, response, error)
                print("There was an error getting boards data!")
            }
        }.resume()
    }
}
