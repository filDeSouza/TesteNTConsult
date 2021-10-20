//
//  MainCoordinator.swift
//  TesteNTConsult
//
//  Created by Filipe de Souza on 20/10/21.
//

import Foundation
import UIKit

class MainCoordinator: Coordinator{
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = EventosViewModel(coordinator: self)
        let vc = ListaEventosViewController(viewModel: viewModel)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showTelaEventos(){
        self.navigationController.popToRootViewController(animated: true)
    }
    
    func showTelaDetalhesEvento(idEvento: String){
        let viewModel = DetalhesEventoViewModel(idEvento: idEvento, coordinator: self)
        let vc = DetalhesEventoViewController(viewModel: viewModel)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showTelaCheckin(evento: EventoModel){
        let viewModel = CheckinViewModel(coordinator: self, model: evento)
        let vc = CheckinViewController(evento: evento, viewModel: viewModel)
        navigationController.pushViewController(vc, animated: true)
    }
    
}
