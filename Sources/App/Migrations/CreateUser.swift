//
//  CreateUser.swift
//  
//
//  Created by lulwah on 13/04/2023.
//

import Fluent


struct CreateUser: AsyncMigration {
    func prepare(on database: Database)  async throws {
        try await   database.schema("users")
            .id()
            .field("username", .string ,.required)
            .field("password", .string ,.required)
            .create()
    }
    
    func revert(on database: Database) async throws {
        try await   database.schema("user").delete()
    }
}
