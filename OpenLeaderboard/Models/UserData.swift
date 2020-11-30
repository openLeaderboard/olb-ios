//
//  UserData.swift
//  OpenLeaderboard
//
//  Created by Tim Lyster on 2020-10-29.
//  Copyright © 2020 OpenLeaderboard. All rights reserved.
//

import Foundation

class UserData: ObservableObject {
    @Published var loggedIn = false
    @Published var access_token = ""
    @Published var userId = 0
}
