//
//  File.swift
//  
//
//  Created by Jackson on 7/10/2021.
//

import Foundation
import Fluent
import Vapor
import FluentPostgresDriver
import PythonKit

struct DataStu : Content {
    let id : Int
    let name : String
}

func runPythonCode(){
    let sys = Python.import("sys")
    sys.path.append("/Users/zhangxinyu/Desktop/Swift-backend-server/Sources/App/Pythons")
    let example = Python.import("final")
    let data = AlgorithmFormatJSON(Genres: [
        GenreInfo(id: 1, name: "abc", describe_img: "/d"),
        GenreInfo(id: 2, name: "abc", describe_img: "/d"),
    ],
    Actors: [],
    Directors: [])
    do {
        let jsonData = try JSONEncoder().encode(data)
        let jsonString = String(data: jsonData, encoding: .utf8)!
        print(jsonString) // [{"sentence":"Hello world","lang":"en"},{"sentence":"Hallo Welt","lang":"de"}]
        example.hello(jsonString)
    } catch { print(error) }
}

final class PlaygroundController {
    
    //this will change to load data form our database
    func getActor(req: Request) throws -> EventLoopFuture<PersonInfoResponse>{
        // //getting a page number to get the data
        guard let maxItem = Environment.process.PAGE_PER_ITEM else{
            throw Abort(.internalServerError,reason: "INTERNAL ERROR")
        }
        
        guard let postgresSql = (req.db as? PostgresDatabase)?.sql() else {
            throw Abort(.internalServerError,reason:"DB INTERNAL ERROR")
        }
        
        let page = abs((try? req.query.get(Int.self, at: "page") as Int) ?? 1 )//default 1
        let offset = Int(maxItem) ?? 20
        let pageOffset = (page - 1) * offset
        
        let sql = """
        SELECT id,department as known_for_department,name,profile_path
        FROM person_infos
        WHERE department = 'Acting' LIMIT \(maxItem) OFFSET \(pageOffset)
        """
        
        return postgresSql.raw(SQLQueryString(sql)).all(decoding: PersonData.self).map{results -> PersonInfoResponse in
            return PersonInfoResponse(response: results)
        }

    }

    //http://127.0.0.1:8080/api/playground/getDirector?page=1s
    func getDirector(req : Request) throws -> EventLoopFuture<PersonInfoResponse>{
        guard let maxItem = Environment.process.PAGE_PER_ITEM else{
            throw Abort(.internalServerError,reason: "INTERNAL ERROR")
        }
        guard let postgresSql = (req.db as? PostgresDatabase)?.sql() else {
            throw Abort(.internalServerError,reason:"DB INTERNAL ERROR")
        }

        let page = abs((try? req.query.get(Int.self, at: "page") as Int) ?? 1 )//default 1
        let offset = Int(maxItem) ?? 20
        let pageOffset = (page - 1) * offset

        let sql = """
         SELECT person_infos.id,person_infos.name,person_infos.profile_path,crews.department as known_for_department
         FROM (SELECT person_id , department FROM person_crews WHERE department = 'Directing'
         GROUP BY (person_id,department)) AS crews INNER JOIN person_infos ON person_infos.id =  crews.person_id ORDER BY person_id ASC LIMIT \(maxItem) OFFSET \(pageOffset)
        """
        // print(sql)
        return postgresSql.raw(SQLQueryString(sql)).all(decoding: PersonData.self).map{results -> PersonInfoResponse in
                return PersonInfoResponse(response: results)
        }
        
    }
    
    //this controller will only get one genre datac
    func getGenreById(req : Request) throws ->  EventLoopFuture<GenreInfoResponse> {
        //join 2 table -> this will
        // let api = APIGenreResponse(id:1)
        let log = Logger.init(label: "API:")
        log.debug("Getting movie data by genre id")
        guard let postgresSql = (req.db as? PostgresDatabase)?.sql() else {
            throw Abort(.internalServerError,reason:"DB INTERNAL ERROR")
        }
        
        guard let genreId = (try? req.query.get(Int.self, at: "id") as Int) else {
            throw Abort(.badRequest,reason:"ID NOT PROVIDED")
        }
        
        var amount = abs((try? req.query.get(Int.self, at: "size") as Int) ?? 5 )//default 1
        if amount > 20{
            amount = 20
        }
        
        let sql = """
         SELECT genre_infos.id,genre_infos.name,movie_infos.poster_path as describe_img FROM genres_movies
         INNER JOIN movie_infos ON movie_infos."id" = genres_movies.movie_info_id
         INNER JOIN genre_infos ON genre_infos."id" = genres_movies.genre_info_id
         WHERE genre_infos.id = \(genreId) ORDER BY RANDOM() LIMIT \(amount)
        """
        
        return postgresSql.raw(SQLQueryString(sql)).all(decoding: GenreInfo.self).map{results -> GenreInfoResponse in
            return GenreInfoResponse(response: results)
        }

    }
    
    func getGenreAll(req : Request) throws -> EventLoopFuture<GenreInfoResponse>{
        //this route will only send 1 result ,account to provided data
        guard let postgresSql = (req.db as? PostgresDatabase)?.sql() else {
            throw Abort(.internalServerError,reason:"DB INTERNAL ERROR")
        }

           
        runPythonCode()
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        //logging debug message
        let log = Logger.init(label: "API:")
        log.debug("Getting movie data by genre id")
        
        //getting all genre id
        let genreSql = "SELECT id, name FROM genre_infos ORDER BY id"

        return postgresSql.raw(SQLQueryString(genreSql)).all(decoding: GenreData.self).flatMap{genreDatas -> EventLoopFuture<GenreInfoResponse> in
            
            var queryEventLoops :[EventLoopFuture<GenreInfo?>] = []
            for genre in genreDatas{
                let sql = """
                 SELECT genre_infos.id,genre_infos.name,movie_infos.poster_path as describe_img FROM genres_movies
                 INNER JOIN movie_infos ON movie_infos."id" = genres_movies.movie_info_id
                 INNER JOIN genre_infos ON genre_infos."id" = genres_movies.genre_info_id
                 WHERE genre_infos.id = \(genre.id) ORDER BY RANDOM() LIMIT 1
                """
                
                let data = postgresSql.raw(SQLQueryString(sql)).first(decoding: GenreInfo.self)
                queryEventLoops.append(data)
            }
            
            
            return queryEventLoops.flatten(on: req.eventLoop).map{queryDatas -> GenreInfoResponse in
                var responseDatas : [GenreInfo] = []
                queryDatas.forEach{ info in
                    if let data = info {
                        responseDatas.append(data)
                    }
                }
                return GenreInfoResponse(response: responseDatas)
            }
        }
    }
    
    func getPreviewMovie(req : Request) throws -> String{
        return "test"
    }
    
    func postPreviewResult(req : Request) throws -> AlgorithmFormatJSON{
        // front will send a item Collection
        //return just one movie for user preview
        guard let collection = try? req.content.decode([PreviewDataInfo].self) else {
            print("avc")
            throw Abort(.badRequest,reason:"JSON parse failed!")
        }
        var AlgorithmData : AlgorithmFormatJSON = AlgorithmFormatJSON(Genres: [], Actors: [], Directors: [])
        for dataInfo in collection{
            print(dataInfo.itemType)
            switch dataInfo.itemType {
            case .Genre:
                AlgorithmData.Genres.append(dataInfo.genreData!)
                break
            case .Actor:
                AlgorithmData.Actors.append(dataInfo.personData!)
                break
            case .Director:
                AlgorithmData.Directors.append(dataInfo.personData!)
                break
                
            }
        }
        
        print(AlgorithmData.Genres.count)
        print(AlgorithmData.Actors.count)
        print(AlgorithmData.Directors.count)
        
        return AlgorithmData
    }
}

struct AlgorithmFormatJSON : Content{
    var Genres : [GenreInfo]
    var Actors : [PersonDataInfo]
    var Directors : [PersonDataInfo]
}

struct DataTemp : Encodable {

    var id : Int
    var name : String
}

struct PreviewMovieInfo : Content {
    let id: Int
    let title: String
    let backdropPath: String?
    let posterPath: String?
    let overview: String
    let voteAverage: Double
    let voteCount: Int
    let runtime: Int?
    let releaseDate: String?
    let originalLanguage: String
    let genres: [GenreInfo]?
}
