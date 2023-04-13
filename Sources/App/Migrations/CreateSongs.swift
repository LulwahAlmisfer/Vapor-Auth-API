//
//  CreateSongs.swift
//  
//
//  Created by lulwah on 29/01/2023.
//

import Fluent

struct CreateSongs : AsyncMigration  {
    
    func prepare(on database: Database) async throws {
        try await database.schema("songs")
            .id()
            .field("title", .string, .required)
            .field("userID", .uuid, .required, .references("users", "id"))
            .create()
    }
    
    func revert(on database: Database) async throws {
        try await database.schema("songs").delete()
    }
    
}
