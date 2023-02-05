//
//  SongController.swift
//  
//
//  Created by lulwah on 29/01/2023.
//

import Fluent
import Vapor

struct SongController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let songs = routes.grouped("songs")
        songs.get(use: index)
        songs.post(use: create)
        songs.put(use: update)
        songs.group(":songID") { song in
                 song.delete(use: delete)
             }
    }
    
    
    // GET Request /songs route
    func index(req: Request) async throws -> [Song] {
        try await Song.query(on: req.db).all()
    }
    
    // POST Request /songs route
    func create(req: Request) async throws -> HTTPStatus {
        let song = try req.content.decode(Song.self)
        
        try await song.save(on: req.db)
        return .ok
    }
    
    // PUT Request /songs routes
    func update(req: Request) async throws -> HTTPStatus {
        let song = try req.content.decode(Song.self)
        
        guard let songFromDB = try await Song.find(song.id, on: req.db) else {
            throw Abort(.notFound)
        }
        
        songFromDB.title = song.title
        try await songFromDB.update(on: req.db)
        return .ok
    }
    
    // DELETE Request /songs/id route
    func delete(req: Request) async throws -> HTTPStatus {
        guard let song = try await Song.find(req.parameters.get("songID"), on: req.db) else {
            throw Abort(.notFound)
        }
        
        try await song.delete(on: req.db)
        return .ok
    }
}
