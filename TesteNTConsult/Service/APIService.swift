//
//  APIService.swift
//  TesteNT
//
//  Created by Filipe de Souza on 05/10/21.
//

import Foundation

enum APIError{
    case url
    case taskError
    case noResponse
    case noData
    case responseStatusCode(code: Int)
    case invalidJSON
    case erroResposta
}

enum APICodRetorno{
    case sucesso
}

class APIService{
        
    //MARK: - Obter eventos
   func performRequestEvent(completion: @escaping([EventModel]?) -> Void, onError: @escaping(APIError) -> Void){
        
        let urlString = Constants.base_url + Constants.end_point_events
        let session = URLSession(configuration: .default)
        guard let url = URL(string: urlString) else{
            onError(.url)
            return
        }
        let request = URLRequest(url: url)
        
        let task = session.dataTask(with: request, completionHandler: { data, response, error in
            if error != nil{
                onError(.taskError)
                return
            }
            guard let response = response as? HTTPURLResponse else{
                onError(.noResponse)
                return
            }
            if response.statusCode == 200 {
                guard let data = data else{return}
                do{
                    let event = try JSONDecoder().decode([EventModel].self, from: data)
                    completion(event)
                }catch{
                    onError(.invalidJSON)
                }
            }else{
                onError(.noResponse)
            }
        })
        task.resume()
    }
    
    //MARK: - Obter detalhe evento
    func performRequestDetalheEvento(idEvento: String, completion: @escaping(EventModel?) -> Void, onError: @escaping(APIError) -> Void){
         
         let urlString = Constants.base_url + Constants.end_point_events + idEvento
         
         let session = URLSession(configuration: .default)
         
         guard let url = URL(string: urlString) else{
             onError(.url)
             return
         }
         
         let request = URLRequest(url: url)
         
         let task = session.dataTask(with: request, completionHandler: { data, response, error in
             if error != nil{
                 onError(.taskError)
                 return
             }
             
             guard let response = response as? HTTPURLResponse else{
                 onError(.noResponse)
                 return
             }
             
             if response.statusCode == 200 {
                 
                 guard let data = data else{return}
                 do{
                     let event = try JSONDecoder().decode(EventModel.self, from: data)
                     completion(event)
                 }catch{
                     onError(.invalidJSON)
                 }
                 
             }else{
                 onError(.noResponse)
             }
         })
         task.resume()
     }
    
    //MARK: - Realizar checkin
    func performCheckin(idEvento: String, nome: String, email: String, completion: @escaping(APICodRetorno) -> Void, onError: @escaping(APIError) -> Void){
        
        let urlString = Constants.base_url + Constants.end_point_checkin
        let session = URLSession(configuration: .default)
        let parametros = ["eventId": idEvento, "name": nome, "email": email] as Dictionary<String, String>
        guard let url = URL(string: urlString) else{
            onError(.url)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try? JSONEncoder().encode(parametros)
        
        let dataTask = session.dataTask(with: request, completionHandler: {data, response, error in
            
            if error != nil{
                onError(.taskError)
                return
            }
            
            guard let response = response as? HTTPURLResponse else{
                onError(.noResponse)
                return
            }
            
            if response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 202{
                completion(.sucesso)
            }else{
                onError(.erroResposta)
            }
            
        })
        dataTask.resume()
    }
    
}

