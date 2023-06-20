//
//  MatchManager.swift
//  ios-kyungmin-project
//
//  Created by kyungmin on 2023/06/18.
//

import Foundation

class MatchManager {
    static let shared = MatchManager()

    private init() {}

    var completedMatches : [Match]=[]
}

