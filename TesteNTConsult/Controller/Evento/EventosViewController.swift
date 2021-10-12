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
    var eventosModel: [EventModel] = []
    
    //MARK: - Didload
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UINib(nibName: Constants.cellNibName, bundle: nil), forCellReuseIdentifier: Constants.cellIdentifier)
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath) as! EventoCell
        let evento = eventosModel[indexPath.row]
        cell.selectionStyle = .none
        utils.cellViewShadow(cell: cell)
        utils.popularCelulaEvento(evento, cell)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let detalheViewController = self.storyboard?.instantiateViewController(identifier: Constants.viewControllerDetalhe) as? DetalheEventoViewController else {return}
        detalheViewController.idEvento = eventosModel[indexPath.row].id
        self.navigationController?.pushViewController(detalheViewController, animated: true)
    }

}

