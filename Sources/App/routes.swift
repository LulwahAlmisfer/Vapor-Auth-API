// Vapor-FirstAPI
// Copyright (c) 2023 lulwah

import Fluent
import Vapor

func routes(_ app: Application) throws {
    try app.register(collection: SongController())
    try app.register(collection: WebsiteController())
    try app.register(collection: UsersController())
}
