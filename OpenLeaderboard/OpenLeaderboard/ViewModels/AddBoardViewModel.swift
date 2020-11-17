//
//  AddBoardViewModel.swift
//  OpenLeaderboard
//
//  Created by Tim Lyster on 2020-10-31.
//  Copyright © 2020 OpenLeaderboard. All rights reserved.
//

import Foundation

class AddBoardViewModel: ObservableObject, Codable {
    
    enum CodingKeys: CodingKey {
        case board_name, is_public
    }
    
    @Published var board_name: String = ""
    @Published var is_public: Bool = true
    
    init() { }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        board_name = try container.decode(String.self, forKey: .board_name)
        is_public = try container.decode(Bool.self, forKey: .is_public)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(board_name, forKey: .board_name)
        try container.encode(is_public, forKey: .is_public)
    }

}
