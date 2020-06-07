//
//  Curcol.swift
//  Timo
//
//  Created by Prince Alvin Yusuf on 30/03/20.
//  Copyright © 2020 sambalpete. All rights reserved.
//

import FirebaseFirestore

struct Curcol {
    let id: String?
    let nickname: String?
    let feeling: String?
    let comments: Int?
    let sentDate: Date?
    
    init() {
        self.id = nil
        self.nickname = nil
        self.feeling = nil
        self.comments = 0
        self.sentDate = Date()
    }
    
    init?(document: QueryDocumentSnapshot) {
        let data = document.data()
        
        guard let nickname = data["nickname"] as? String else {return nil}
        guard let feeling = data["feeling"] as? String else {return nil}
        guard let comments = data["comments"] as? Int else {return nil}
        guard let sendDate = data["sendDate"] as? Date else {return nil}

        self.id = document.documentID
        self.nickname = nickname
        self.feeling = feeling
        self.comments = comments
        self.sentDate = sendDate
    }
}

extension Curcol: DatabaseRepresentation {
    var representation: [String : Any] {
        var rep: [String : Any] = [
            "sendDate" : sentDate!,
            "nickname" : nickname!,
            "feeling" : feeling!,
            "comments" : comments!
        ]
        
        if let id = self.id {
            rep["id"] = id
        }
        
        return rep
    }
}

extension Curcol: Comparable {
    static func == (lhs: Curcol, rhs: Curcol) -> Bool {
        return lhs.id == rhs.id
    }
    
    static func < (lhs: Curcol, rhs: Curcol) -> Bool {
        return rhs.sentDate! < lhs.sentDate!
    }
}
