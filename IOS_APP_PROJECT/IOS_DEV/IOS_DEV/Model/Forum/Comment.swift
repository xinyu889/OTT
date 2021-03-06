//
//  Comment.swift
//  IOS_DEV
//
//  Created by Kao Li Chi on 2021/6/3.
//

import Foundation

struct Comment: Decodable, Identifiable{
    var id: UUID?
    var Text: String
    var user: CommentOwner?
    var article: article?
    var LikeCount: String
    var updatedOn: String?   //db is 'DATE', but here is 'STRING'
    
    static private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter
    }()
    
    var dateText: String {
        guard let updatedOn = self.updatedOn, let date = Utils.Formatter.date(from: updatedOn) else {
            return "n/a"
        }
        return Comment.dateFormatter.string(from: date)
    }
    

}

struct CommentOwner: Decodable, Identifiable{
    var id: UUID
    var UserName: String
    var Email: String
    var Password: String
}

struct article: Decodable, Identifiable{
    var id: UUID
}
