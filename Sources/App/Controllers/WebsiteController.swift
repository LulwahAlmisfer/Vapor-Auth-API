// Vapor-FirstAPI
// Copyright (c) 2023 lulwah

import Vapor

struct WebsiteController: RouteCollection {
    func boot(routes: Vapor.RoutesBuilder) throws {
        //  let songs = routes.grouped("songs")
        routes.get(use: indexHandler)
        let dev = routes.grouped("developer")
        dev.get(use: devHandler)
    }

    func indexHandler(_ req: Request) throws -> EventLoopFuture<View> {
        Song.query (on: req.db).all ().flatMap { songs in
            let content = indexContext(title: "ListenTo", songs: songs.isEmpty ? [Song]() : songs)

            return req.view.render("index", content)
        }
    }

    func devHandler(_ req: Request) throws -> EventLoopFuture<View> {
        req.view.render("developer")
    }
}

struct indexContext: Encodable {
    let title: String
    let songs: [Song]?
}
