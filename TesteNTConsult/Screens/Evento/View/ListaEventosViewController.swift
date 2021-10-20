//
//  ListaEventosViewController.swift
//  TesteNTConsult
//
//  Created by Filipe de Souza on 20/10/21.
//

import UIKit
import ProgressHUD


class ListaEventosViewController: UIViewController {
    
    //MARK: - Elementos de tela
    lazy var headerView:  UIView = {
        let headerView = UIView()
        headerView.backgroundColor = UIColor(named: Constantes.BrandColors.sicredi)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        return headerView
    }()
    
    lazy var labelTitulo: UILabel = {
        let view = UILabel(frame: .zero)
        view.textAlignment = .center
        view.lineBreakMode = .byWordWrapping
        view.numberOfLines = 0
        view.text = "Teste NTConsult"
        view.textColor = .white
        view.font = UIFont(name: "Marker Felt Wide", size: 40.0)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var imagemLogo: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "sicredi")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = UIColor.white
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        return tableView
    }()
    
    //MARK: - Variáveis
    let utils = Utils()
    var eventosModel: [EventoModel] = []
    let viewModel: EventosViewModel
    
    //MARK: - Init
    init(viewModel: EventosViewModel ) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - DidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        ProgressHUD.show()
        addSubviews()
        setupViews()
        
        navigationController?.navigationBar.isHidden = true
        tableView.register(UINib(nibName: Constantes.cellNibName, bundle: nil), forCellReuseIdentifier: Constantes.celulaIdentificador)
        
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
    
    //MARK: - Função para adicionar as subViews
    func addSubviews(){
        
        view.addSubview(self.headerView)
        self.headerView.addSubview(self.labelTitulo)
        self.headerView.addSubview(self.imagemLogo)
        view.addSubview(self.tableView)
    }
    
    //MARK: - Configuração das subViews
    func setupViews(){
        
        self.headerView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        self.headerView.heightAnchor.constraint(equalToConstant: 260).isActive = true
        self.headerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        self.headerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        self.labelTitulo.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        self.labelTitulo.heightAnchor.constraint(equalToConstant: 60).isActive = true
        self.labelTitulo.topAnchor.constraint(equalTo: self.headerView.topAnchor, constant: 60).isActive = true
        self.labelTitulo.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        self.imagemLogo.heightAnchor.constraint(equalToConstant: 140).isActive = true
        self.imagemLogo.widthAnchor.constraint(equalToConstant: 140).isActive = true
        self.imagemLogo.topAnchor.constraint(equalTo: labelTitulo.bottomAnchor, constant: 10).isActive = true
        self.imagemLogo.centerXAnchor.constraint(equalTo: headerView.centerXAnchor).isActive = true
        
        self.tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        self.tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        self.tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 260).isActive = true
        self.tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

}

//MARK: - Extension TableView
extension ListaEventosViewController: UITableViewDelegate, UITableViewDataSource{
    
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
        
        viewModel.presentDetalhesEvento(idEvento: eventosModel[indexPath.row].id)

    }

}
