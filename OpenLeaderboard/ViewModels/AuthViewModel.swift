//
//  Registration.swift
//  OpenLeaderboard
//
//  Created by Parker Siroishka on 2020-10-27.
//  Copyright © 2020 OpenLeaderboard. All rights reserved.
//

import Foundation

class AuthViewModel: ObservableObject, Codable {
    
    enum CodingKeys: CodingKey {
        case email, name, password
    }
    
    // registration variables
    @Published var email: String = ""
    @Published var name: String = ""
    @Published var password: String = ""
    
    // Check registration form is filled out correctly
    var hasValidRegistration: Bool {
        if email.isEmpty || name.isEmpty || password.isEmpty{
            return false
        }
        return true
    }
    
    init() { }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        email = try container.decode(String.self, forKey: .email)
        name = try container.decode(String.self, forKey: .name)
        password = try container.decode(String.self, forKey: .password)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(email, forKey: .email)
        try container.encode(name, forKey: .name)
        try container.encode(password, forKey: .password)
    }

}
