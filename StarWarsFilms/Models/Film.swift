//
//  Film.swift
//  StarWarsFilms
//
//  Created by Ipsi Patro on 06/05/2023.
//

import Foundation
import RealmSwift

struct FilmResponse: Codable {
    let results: [Film]?
}

class Film: Object, Codable {
    @objc dynamic var title: String? = ""
    @objc dynamic var director: String? = ""
    @objc dynamic var producer: String? = ""
    @objc dynamic var releaseDate: String? = ""
    let characters = List<String>()
    
    enum CodingKeys: String, CodingKey {
        case title
        case director
        case producer
        case releaseDate = "release_date"
        case characters
    }
    
    var directorName: String {
        guard let director = director else { return ""}
        return Constants.director + ": " + director
    }
    
    var producerName: String {
        guard let producer = producer else { return ""}
        return Constants.producer + ": " + producer
    }
    
    var releaseDateString: String {
        guard let releaseDate = releaseDate else { return ""}
        return Constants.releaseDate + ": " + releaseDate
    }
    
    override static func primaryKey() -> String? {
        return "title"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        title = try container.decode(String.self, forKey: .title)
        director = try container.decode(String.self, forKey: .director)
        producer = try container.decode(String.self, forKey: .producer)
        releaseDate = try container.decode(String.self, forKey: .releaseDate)
        let characterList = try container.decode(List<String>.self, forKey: .characters)
        characters.append(objectsIn: characterList)
        super.init()
    }
    
    required override init() {
        super.init()
    }
}

