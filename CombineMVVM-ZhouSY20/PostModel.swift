//
//  PostModel.swift
//  CombineMVVM-ZhouSY20
//
//  Created by cmStudent on 2022/08/19.
//

import Foundation

struct PostModel: Identifiable, Codable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}
