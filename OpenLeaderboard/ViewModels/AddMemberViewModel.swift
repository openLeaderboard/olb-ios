//
//  AddMemberViewModel.swift
//  OpenLeaderboard
//
//  Created by Parker Siroishka on 2020-11-27.
//  Copyright © 2020 OpenLeaderboard. All rights reserved.
//

import Foundation

class AddMemberViewModel: ObservableObject, Codable {

    enum CodingKeys: CodingKey {
        case board_id, user_id
    }

    @Published var board_id: Int = 0
    @Published var user_id: Int = 0

    init() { }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        board_id = try container.decode(Int.self, forKey: .board_id)
        user_id = try container.decode(Int.self, forKey: .user_id)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(board_id, forKey: .board_id)
        try container.encode(user_id, forKey: .user_id)
    }

}
