// Vapor-FirstAPI
// Copyright (c) 2023 lulwah

import Fluent
import Vapor

final class Song: Model, Content {
    static let schema = "songs"

    @ID(key: .id) var id: UUID?

    @Field(key: "title") var title: String

    @Parent(key: "userID") var user: User

    init() { }

    init(id: UUID? = nil, title: String, userID: User.IDValue) {
        self.id = id
        self.title = title
        $user.id = userID
    }
}
