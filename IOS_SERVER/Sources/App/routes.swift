import Fluent
import Vapor


func routes(_ app: Application) throws {
    
    app.routes.defaultMaxBodySize = "100mb"
    
    try app.register(collection: ListMovieController()) //片單內容
    try app.register(collection: ListController())      //片單
    try app.register(collection: CommentController())   //文章留言
    try app.register(collection: ArticleController())   //討論區文章
    try app.register(collection: MovieAPIController())  //電影資訊
    try app.register(collection: UserController())      //登入註冊
    try app.register(collection: UserPhotoController()) //使用者大頭貼
    try app.register(collection: LikeMovieController()) //喜好的電影
    try app.register(collection: LikeArticleController()) //喜好的文章
    try app.register(collection: APIController())     //API stuff
    
    
    

//    //----------------------------測試----------------------------//
//    //ROUTE GROUPS
//    let users = app.grouped("user")
//
//    // /users (show)
//    users.get { req in
//        User.query(on: req.db).all()
//    }
//
//    // /users/id (find)
//    users.get(":userID") { req -> EventLoopFuture<User> in
//        User.find(req.parameters.get("userID"), on: req.db)
//            .unwrap(or: Abort(.notFound))   //找不到userID就回傳not found
//    }
//
//    // /users PUT (update)
//    users.put { req -> EventLoopFuture<HTTPStatus> in
//        let user = try req.content.decode(User.self)    // content = body of http request
//
//        return User.find(user.id, on: req.db)
//            .unwrap(or: Abort(.notFound))   //找不到userID就回傳not found
//            .flatMap{
//                $0.UserName=user.UserName
//                $0.Email=user.Email
//                $0.Password=user.Password
//                return $0.update(on: req.db).transform(to: .ok)
//            }
//    }
//
//    // /users POST (create)
//    users.post { req -> EventLoopFuture<User> in
//        let user = try req.content.decode(User.self)    // content = body of http request
//        return user.create(on: req.db).map { user }
//    }
//
//    // /users DELETE (delete)
//    users.delete(":userID") { req -> EventLoopFuture<HTTPStatus> in
//        User.find(req.parameters.get("userID"), on: req.db)
//            .unwrap(or: Abort(.notFound))   //找不到userID就回傳not found
//            .flatMap{
//                $0.delete(on:req.db)
//            }.transform(to: .ok)
//    }
    

}
