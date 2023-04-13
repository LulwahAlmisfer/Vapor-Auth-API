import Fluent
import Vapor

func routes(_ app: Application) throws {
//    app.get { req async in
//        "It works!2222"
//    }

    app.get("hello") { req async -> String in
        "Hello, world!"
    }

    try app.register(collection: SongController())
    try app.register(collection: WebsiteController())
    
   try app.register(collection: UsersController())
    
}
