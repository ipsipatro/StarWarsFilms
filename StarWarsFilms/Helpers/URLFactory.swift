//
//  URLFactory.swift
//  StarWarsFilms
//
//  Created by Ipsi Patro on 06/05/2023.
//

import Foundation

protocol URLProvideable {
    func getFilmsURL() -> String
}

final class URLFactory: URLProvideable {
    let basePath = "https://swapi.dev/api/" // When we have different environments to test you need to write code to get the right base path as per environment
    
    func getFilmsURL() -> String {
        return "\(basePath)films/"
    }
}

