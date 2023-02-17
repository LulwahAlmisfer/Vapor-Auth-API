import Fluent
import FluentPostgresDriver
import Vapor
import Leaf

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    if let databaseURL = Environment.get("DATABASE_URL") {
       try app.databases.use(.postgres(url: databaseURL), as: .psql)
        
//        var postgresConfig = PostgresConfiguration(url: databaseURL )
//            var tlsC = TLSConfiguration.makeClientConfiguration()
//            tlsC.certificateVerification = .none
//            postgresConfig?.tlsConfiguration = tlsC
//            try app.databases.use(.postgres(configuration: postgresConfig!), as: .psql)
//
        
    } else {
        // Handle missing DATABASE_URL here...
        //
        // Alternatively, you could also set a different config
        // depending on wether app.environment is set to to
        // `.development` or `.production`
        app.databases.use(.postgres(
            hostname: Environment.get("DATABASE_HOST") ?? "localhost",
            port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? PostgresConfiguration.ianaPortNumber,
            username: Environment.get("DATABASE_USERNAME") ?? "vapor_username",
            password: Environment.get("DATABASE_PASSWORD") ?? "vapor_password",
            database: Environment.get("DATABASE_NAME") ?? "vapor_database"
        ), as: .psql)
    }
  

   

    app.migrations.add(CreateSongs())
    try app.autoMigrate().wait()
    // register routes
     try routes(app)
    app.views.use(.leaf)
    
}
