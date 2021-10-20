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
    
}
