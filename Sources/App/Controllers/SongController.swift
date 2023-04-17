// Vapor-FirstAPI
// Copyright (c) 2023 lulwah

import Fluent
import Vapor

struct SongController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let songs = routes.grouped("songs")

        let tokenAuthMiddleware = Token.authenticator()
        let guardAuthMiddleware = User.guardMiddleware()
        let tokenAuthGroup = songs.grouped(tokenAuthMiddleware, guardAuthMiddleware)

        tokenAuthGroup.get(use: index)
        tokenAuthGroup.post(use: create)
        tokenAuthGroup.put(use: update)
        tokenAuthGroup.group(":songID") { songAuth in
            songAuth.delete(use: delete)
        }
    }

    // GET Request /songs route
    func index(req: Request) async throws -> [Song] {
        let user = try req.auth.require(User.self)
        let userID = try user.requireID()

        return try await Song.query(on: req.db).filter(\.$user.$id == userID).all()
    }

    // POST Request /songs route
    func create(req: Request) async throws -> HTTPStatus {
        let user = try req.auth.require(User.self)
        let data = try req.content.decode(CreateSongData.self)
        let song = try Song(title: data.title, userID: user.requireID())
        try await song.save(on: req.db)
        return .noContent
    }

    // PUT Request /songs routes
    func update(req: Request) async throws -> HTTPStatus {
        try req.auth.require(User.self)
        let song = try req.content.decode(Song.self)

        guard let songFromDB = try await Song.find(song.id, on: req.db) else {
            throw Abort(.notFound)
        }

        songFromDB.title = song.title
        try await songFromDB.update(on: req.db)
        return .noContent
    }

    // DELETE Request /songs/id route
    func delete(req: Request) async throws -> HTTPStatus {
        try req.auth.require(User.self)

        guard let song = try await Song.find(req.parameters.get("songID"), on: req.db) else {
            throw Abort(.notFound)
        }

        try await song.delete(on: req.db)
        return .noContent
    }
}

struct CreateSongData: Content {
    let title: String
}
