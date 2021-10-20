//
//  EventModel.swift
//  TesteNT
//
//  Created by Filipe de Souza on 05/10/21.
//

import Foundation

struct EventoModel: Decodable{
    
    let people: [People]
    let date: Int
    let description: String
    let image: String
    let longitude: Double
    let latitude: Double
    let price: Double
    let title: String
    let id: String
    
}

struct People: Decodable{
    
}
