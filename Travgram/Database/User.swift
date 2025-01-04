//
//  User.swift
//  Travgram
//
//  Created by Jesse Liang on 2024/12/23.
//

import Foundation
import SwiftData
import TipKit

@Model
class User {
    let id: String
    var username: String
    var profileImageURL: String?
    var fullname: String?
    var bio: String?
    let email: String
    var password: String

    init(
        id: String = UUID().uuidString,
        username: String,
        email: String,
        password: String,
        profileImageURL: String? = nil,
        fullname: String? = nil,
        bio: String? = nil
    ) {
        self.id = id
        self.username = username
        self.email = email
        self.password = password
    }
}
