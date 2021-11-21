//
//  File.swift
//  
//
//  Created by Kao Li Chi on 2021/10/27.
//


import Foundation
import Fluent
import Vapor

struct LikeMovieController: RouteCollection{
    
    func boot(routes: RoutesBuilder) throws {
        
        let likeMovie = routes.grouped("likeMovie")
        likeMovie.group("my"){ li in
            li.get(":userID",use: GetMyLike)
        }
        likeMovie.post("new",use: postLike)
        likeMovie.group("delete"){ li in
            li.delete(":likeMovieID",use: deleteLike)
        }
    }
    
    
    //----------------------------我的喜愛電影--------------------------------//

    func GetMyLike(req: Request) throws -> EventLoopFuture<[LikeMovie]> {

        guard let userID = req.parameters.get("userID") as UUID? else{
            throw Abort(.badRequest)
        }
        
        return  LikeMovie.query(on: req.db)
            .with(\.$user)
            .filter(LikeMovie.self, \LikeMovie.$user.$id == userID )
            .sort(\.$updatedOn, .descending)
            .all()

    }
    

    //----------------------------post喜愛電影-------------------------------//
    func postLike(req: Request) throws -> EventLoopFuture<LikeMovie> {
        let todo = try req.content.decode(NewLikeMovie.self)

        return User.query(on: req.db)
            .filter(\.$id == todo.userID)
            .first()
            .unwrap(or: Abort(.notFound))
            .flatMap{ usr in
                let likeMovie = LikeMovie(user: usr, movie: todo.movie, title: todo.title, posterPath: todo.posterPath)
                return likeMovie.create(on: req.db).map{ likeMovie }
            }
    }
    
    
    
   //-----------------------------delete喜愛電影-------------------------------//
   
   func deleteLike(req: Request) throws -> EventLoopFuture<HTTPStatus> {
       
       return LikeMovie.find(req.parameters.get("likeMovieID"), on: req.db)
           .unwrap(or: Abort(.notFound))
           .flatMap{ $0.delete(on: req.db) }
           .transform(to: .ok)
   }
    
    
   
}
