//
//  SubmitMatchViewModel.swift
//  OpenLeaderboard
//
//  Created by Joel van Egmond on 2020-11-30.
//  Copyright © 2020 OpenLeaderboard. All rights reserved.
//

import Foundation

class BoardInviteResponseModel: ObservableObject, Codable {

    enum CodingKeys: CodingKey {
        case accept, invite_id
    }

    @Published var accept: Bool = false
    @Published var invite_id: Int = 0

    init() { }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        accept = try container.decode(Bool.self, forKey: .accept)
        invite_id = try container.decode(Int.self, forKey: .invite_id)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(accept, forKey: .accept)
        try container.encode(invite_id, forKey: .invite_id)
    }

}
