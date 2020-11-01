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
        case board_name, isPublic
    }
    
    @Published var board_name: String = ""
    @Published var isPublic: String = ""
    
    init() { }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        board_name = try container.decode(String.self, forKey: .board_name)
        isPublic = try container.decode(String.self, forKey: .isPublic)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(board_name, forKey: .board_name)
        try container.encode(isPublic, forKey: .isPublic)
    }

}

