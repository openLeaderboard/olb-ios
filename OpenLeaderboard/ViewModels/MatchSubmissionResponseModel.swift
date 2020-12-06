//
//  MatchSubmissionResponseModel.swift
//  OpenLeaderboard
//
//  Created by Tim Lyster on 2020-12-05.
//  Copyright © 2020 OpenLeaderboard. All rights reserved.
//

import Foundation

class MatchSubmissionResponseModel: ObservableObject, Codable {

    enum CodingKeys: CodingKey {
        case accept, match_id
    }

    @Published var accept: Bool = false
    @Published var match_id: Int = 0

    init() { }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        accept = try container.decode(Bool.self, forKey: .accept)
        match_id = try container.decode(Int.self, forKey: .match_id)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(accept, forKey: .accept)
        try container.encode(match_id, forKey: .match_id)
    }

}
