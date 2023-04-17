// Vapor-FirstAPI
// Copyright (c) 2023 lulwah

import Fluent
import Vapor

final class User: Model {
    static let schema = "users"

    @ID var id: UUID?

    @Field(key: "username") var username: String

    @Field(key: "password") var password: String

    @Children(for: \.$user) var songs: [Song]

    init() { }

    init(id: UUID? = nil, email: String, password: String) {
        self.id = id
        self.username = email
        self.password = password
    }

    struct Public: Content {
        var id: UUID?
        var username: String
    }
}

extension User: Content { }

extension User {
    func convertToPublic() -> User.Public {
        User.Public(id: id, username: username)
    }
}

extension User: ModelAuthenticatable {
    static let usernameKey = \User.$username
    static let passwordHashKey = \User.$password

    func verify(password: String) throws -> Bool {
        try Bcrypt.verify(password, created: self.password)
    }
}
