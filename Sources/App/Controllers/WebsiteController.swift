//
//  WebsiteController.swift
//  
//
//  Created by lulwah on 17/02/2023.
//

import Vapor
struct WebsiteController: RouteCollection {
    func boot(routes: Vapor.RoutesBuilder) throws {
      //  let songs = routes.grouped("songs")
        routes.get( use: indexHandler)
    }
    
    func indexHandler(_ req: Request) throws -> EventLoopFuture<View> {
        Song.query (on: req.db).all ().flatMap { songs in
            let content = indexContext(title: "ListenTo", songs: songs.isEmpty ? nil : songs)
            
            return req.view.render("index" , content)
        }
    }
}
struct indexContext : Encodable {
    let title : String
    let songs: [Song]?
}
