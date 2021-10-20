//
//  DetalhesEventoViewModel.swift
//  TesteNTConsult
//
//  Created by Filipe de Souza on 20/10/21.
//

import Foundation


protocol DetalhesEventoViewModelDelegate: class {
    func reject()
}

class DetalhesEventoViewModel {
    
    private let coordinator: MainCoordinator
    private var idEvento: String
    let utils = Utils()
    var evento: EventoModel?
    
    weak var delegate: DetalhesEventoViewModelDelegate?
    
    init(idEvento: String, coordinator: MainCoordinator){
        self.coordinator = coordinator
        self.idEvento = idEvento
    }
    
    public func presentTelaCheckin(evento: EventoModel){
        coordinator.showTelaCheckin(evento: evento)
    }
    
    public func presentTelaEventos(){
        coordinator.showTelaEventos()
    }
    
    public func id() -> String{
        return idEvento
    }
    
    public func obterEvento(idEvento: String, completion: @escaping(EventoModel?) -> Void, onError: @escaping(EventosError) -> Void){
        utils.obterDetalhesEvento(idEvento: idEvento, completion: {(evento) in
            DispatchQueue.main.async {
                if let resultadoDetalheEvento = evento{
                    self.evento = resultadoDetalheEvento
                    completion(resultadoDetalheEvento)
                }
                
            }
            
        }, onError: { (error) in
            switch error{
            case .JSONinvalido:
                onError(.JSONinvalido)
            case .semDados:
                onError(.semDados)
            case .semResposta:
                onError(.semResposta)
            case .erroResposta:
                onError(.erroResposta)
            default:
                print("Erro genérico")
            }
        })
    }

    
}
