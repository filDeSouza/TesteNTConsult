//
//  APIService.swift
//  TesteNT
//
//  Created by Filipe de Souza on 05/10/21.
//

import Foundation

enum ErroAPI{
    case url
    case erroDataTask
    case semResposta
    case semDados
    case erroCodigoStatus(code: Int)
    case JSONinvalido
    case erroResposta
}

enum APICodRetorno{
    case sucesso
}

class APIService{
        
    //MARK: - Obter eventos
   func obterEventos(completion: @escaping([EventoModel]?) -> Void, onError: @escaping(ErroAPI) -> Void){
        
        let urlString = Constantes.base_url + Constantes.end_point_eventos
        let sessao = URLSession(configuration: .default)
        guard let url = URL(string: urlString) else{
            onError(.url)
            return
        }
        let request = URLRequest(url: url)
        
        let task = sessao.dataTask(with: request, completionHandler: { data, response, error in
            if error != nil{
                onError(.erroDataTask)
                return
            }
            guard let response = response as? HTTPURLResponse else{
                onError(.semResposta)
                return
            }
            if response.statusCode == 200 {
                guard let data = data else{return}
                do{
                    let event = try JSONDecoder().decode([EventoModel].self, from: data)
                    completion(event)
                }catch{
                    onError(.JSONinvalido)
                }
            }else{
                onError(.semResposta)
            }
        })
        task.resume()
    }
    
    //MARK: - Obter detalhe evento
    func obterDetalheEvento(idEvento: String, completion: @escaping(EventoModel?) -> Void, onError: @escaping(ErroAPI) -> Void){
         
         let urlString = Constantes.base_url + Constantes.end_point_eventos + idEvento
         
         let sessao = URLSession(configuration: .default)
         
         guard let url = URL(string: urlString) else{
             onError(.url)
             return
         }
         
         let requisicao = URLRequest(url: url)
         
         let task = sessao.dataTask(with: requisicao, completionHandler: { data, resposta, error in
             if error != nil{
                 onError(.erroDataTask)
                 return
             }
             
             guard let resposta = resposta as? HTTPURLResponse else{
                 onError(.semResposta)
                 return
             }
             
             if resposta.statusCode == 200 {
                 
                 guard let data = data else{return}
                 do{
                     let evento = try JSONDecoder().decode(EventoModel.self, from: data)
                     completion(evento)
                 }catch{
                     onError(.JSONinvalido)
                 }
                 
             }else{
                 onError(.semResposta)
             }
         })
         task.resume()
     }
    
    //MARK: - Realizar checkin
    func realizarCheckin(idEvento: String, nome: String, email: String, completion: @escaping(APICodRetorno) -> Void, onError: @escaping(ErroAPI) -> Void){
        
        let urlString = Constantes.base_url + Constantes.end_point_checkin
        let sessao = URLSession(configuration: .default)
        let parametros = ["eventId": idEvento, "name": nome, "email": email] as Dictionary<String, String>
        guard let url = URL(string: urlString) else{
            onError(.url)
            return
        }
        
        var requisicao = URLRequest(url: url)
        requisicao.httpMethod = "POST"
        requisicao.httpBody = try? JSONEncoder().encode(parametros)
        
        let dataTask = sessao.dataTask(with: requisicao, completionHandler: {data, resposta, error in
            
            if error != nil{
                onError(.erroDataTask)
                return
            }
            
            guard let response = resposta as? HTTPURLResponse else{
                onError(.semResposta)
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

