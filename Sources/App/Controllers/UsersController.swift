//
//  UsersController.swift
//
//
//  Created by lulwah on 13/04/2023.
//

import Foundation

import Vapor


struct UsersController: RouteCollection {

    func boot(routes: RoutesBuilder) throws {
        let usersRoutes = routes.grouped("api", "users")
        usersRoutes.post( use: creatHandler)


        let basicAuthMiddleware = User.authenticator()
        let basicAuthGroup = usersRoutes.grouped(basicAuthMiddleware)
        basicAuthGroup.post("login", use: loginHandler)


    }
    // sign up
    func creatHandler(_ req: Request) throws -> EventLoopFuture<User.Public> {
        let user = try req.content.decode(User.self)
        user.password = try Bcrypt.hash(user.password)
        return user.save(on: req.db).map {
            user.convertToPublic()
        }
    }


    // log in
    func loginHandler(_ req: Request) throws -> EventLoopFuture<Token> {

        let user = try req.auth.require(User.self)
        let token = try Token.generate(for: user)
        return token.save(on: req.db).map {token}
    }




}

