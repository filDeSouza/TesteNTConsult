//
//  CheckinViewModel.swift
//  TesteNTConsult
//
//  Created by Filipe de Souza on 20/10/21.
//

import Foundation

class CheckinViewModel{
    
    let coordinator: MainCoordinator
    var model: EventoModel
    
    init(coordinator: MainCoordinator, model: EventoModel){
        self.coordinator = coordinator
        self.model = model
    }
    
    public func presentTelaDetalhesEvento(){
        coordinator.showTelaEventos()
    }
    
}
