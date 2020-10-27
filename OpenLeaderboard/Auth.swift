//
//  Registration.swift
//  OpenLeaderboard
//
//  Created by Parker Siroishka on 2020-10-27.
//  Copyright © 2020 OpenLeaderboard. All rights reserved.
//

import Foundation

class Auth: ObservableObject, Codable{
    
    enum CodingKeys: CodingKey {
        case reg_email, reg_displayName, reg_pword, reg_confirmPword
    }
    
    // registration variables
    @Published var reg_email: String = ""
    @Published var reg_displayName: String = ""
    @Published var reg_pword: String = ""
    @Published var reg_confirmPword: String = ""
    
    
    // Check registration form is filled out correctly
    var hasValidRegistration: Bool {
        if reg_email.isEmpty || reg_displayName.isEmpty || reg_pword.isEmpty || reg_confirmPword.isEmpty || reg_pword != reg_confirmPword {
            return false
        }
        
        return true
    }
    
    init() { }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        reg_email = try container.decode(String.self, forKey: .reg_email)
        reg_displayName = try container.decode(String.self, forKey: .reg_displayName)
        reg_pword = try container.decode(String.self, forKey: .reg_pword)
        
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(reg_email, forKey: .reg_email)
        try container.encode(reg_displayName, forKey: .reg_displayName)
        try container.encode(reg_pword, forKey: .reg_pword)
        
//        try container.encode(login_email, forKey: .login_email)
//        try container.encode(login_pword, forKey: .login_pword)
    }
}
