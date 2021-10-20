//
//  EventosViewModel.swift
//  TesteNTConsult
//
//  Created by Filipe de Souza on 20/10/21.
//

import Foundation

class EventosViewModel{
    
    private let coordinator: MainCoordinator
    public var idEvento: String = ""
    
    init(coordinator: MainCoordinator) {
        self.coordinator = coordinator
    }
    
    public func presentDetalhesEvento(idEvento: String){
        coordinator.showTelaDetalhesEvento(idEvento: idEvento)
    }
    
}
