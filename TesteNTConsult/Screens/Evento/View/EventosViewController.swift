//
//  ViewController.swift
//  TesteNTConsult
//
//  Created by Filipe de Souza on 08/10/21.
//

import UIKit
import ProgressHUD

class EventosViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Variáveis
    let utils = Utils()
    var eventosModel: [EventoModel] = []
    
    //MARK: - Didload
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UINib(nibName: Constantes.cellNibName, bundle: nil), forCellReuseIdentifier: Constantes.celulaIdentificador)
        
        ProgressHUD.show()
        
        utils.obterEventos(completion: {(eventos) in
            DispatchQueue.main.async {
                guard let resultadoEventos = eventos else{return}
                self.eventosModel = resultadoEventos
                self.tableView.reloadData()
                ProgressHUD.dismiss()
            }
            
        }, onError: {(error) in
            
        })
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // No need for semicolon
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.tableView.register(UINib(nibName: Constantes.cellNibName, bundle: nil), forCellReuseIdentifier: Constantes.celulaIdentificador)
        
        ProgressHUD.show()
        
        utils.obterEventos(completion: {(eventos) in
            DispatchQueue.main.async {
                guard let resultadoEventos = eventos else{return}
                self.eventosModel = resultadoEventos
                self.tableView.reloadData()
                ProgressHUD.dismiss()
            }
            
        }, onError: {(error) in
            
        })
    }
    
}

//MARK: - Extension TableView
extension EventosViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventosModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celula = tableView.dequeueReusableCell(withIdentifier: Constantes.celulaIdentificador, for: indexPath) as! EventoCell
        let evento = eventosModel[indexPath.row]
        celula.selectionStyle = .none
        utils.formatarSombraCelula(cell: celula)
        utils.popularCelulaEvento(evento, celula)
        return celula
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        guard let detalheViewController = self.storyboard?.instantiateViewController(identifier: Constantes.viewControllerDetalhes) as? DetalheEventoViewController else {return}
//        detalheViewController.idEvento = eventosModel[indexPath.row].id


        let detalhesViewController = DetalhesEventoViewController(idEvento: eventosModel[indexPath.row].id)
        detalhesViewController.idEvento = eventosModel[indexPath.row].id
        self.navigationController?.pushViewController(detalhesViewController, animated: true)

    }

}

