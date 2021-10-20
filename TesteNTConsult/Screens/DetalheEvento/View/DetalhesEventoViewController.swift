//
//  DetalhesEventoViewController.swift
//  TesteNTConsult
//
//  Created by Filipe de Souza on 18/10/21.
//

import UIKit
import MapKit
import ProgressHUD

class DetalhesEventoViewController: UIViewController {

    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = UIColor(named: Constantes.BrandColors.sicredi)
        scrollView.layoutIfNeeded()
        scrollView.isScrollEnabled = true
        //scrollView.contentSize = CGSize(width: scrollView.contentSize.width, height: 800)

        return scrollView
    }()
    
    lazy var contentView:  UIView = {
        let contentView = UIView()
        contentView.layer.cornerRadius = 12
        contentView.backgroundColor = UIColor.white
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    
    lazy var imagemEvento: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var botaoVoltar: UIButton = {
        let view = UIButton(type: .close)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var botaoCheckin: UIButton = {
        let view = UIButton()
        var config = UIImage.SymbolConfiguration(scale: .large)
        config = config.applying(UIImage.SymbolConfiguration(font: .systemFont(ofSize: 36.0)))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setImage(UIImage(systemName: "checkmark.circle", withConfiguration: config), for: .normal)
        return view
    }()
    
    lazy var labelTituloEvento: UILabel = {
        let view = UILabel(frame: .zero)
        view.textAlignment = .center
        view.lineBreakMode = .byWordWrapping
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let stackViewData = UIStackView()
    lazy var labelTituloData: UILabel = {
        let view = UILabel(frame: .zero)
        view.text = "Data"
        view.textAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var labelData: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var labelDescricao: UILabel = {
        let view = UILabel(frame: .zero)
        view.textAlignment = .center
        view.lineBreakMode = .byWordWrapping
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var labelTituloLocalizacao: UILabel = {
        let view = UILabel(frame: .zero)
        view.textAlignment = .center
        view.lineBreakMode = .byWordWrapping
        view.text = "Localização"
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var labelEndereco: UILabel = {
        let view = UILabel(frame: .zero)
        view.textAlignment = .center
        view.lineBreakMode = .byWordWrapping
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var mapaLocalizacao: MKMapView = {
        let view = MKMapView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var labelTituloPreco: UILabel = {
        let view = UILabel(frame: .zero)
        view.textAlignment = .center
        view.lineBreakMode = .byWordWrapping
        view.text = "Preço"
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var labelPreco: UILabel = {
        let view = UILabel(frame: .zero)
        view.textAlignment = .center
        view.lineBreakMode = .byWordWrapping
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var labelRodape: UILabel = {
        let view = UILabel(frame: .zero)
        view.textAlignment = .center
        view.lineBreakMode = .byWordWrapping
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    //MARK: - Variáveis e constantes
    var idEvento: String
    let utils = Utils()
    var evento: EventoModel?
    
    init(idEvento: String ) {
        self.idEvento = idEvento
        super.init(nibName: nil, bundle: nil)
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ProgressHUD.show()
        addSubviews()
        setupViews()
        
        let contentWidth = scrollView.bounds.width
        scrollView.isScrollEnabled = true
        scrollView.contentSize = CGSize(width: contentWidth, height: 1500)
        
        //guard let idEventoDetalhe = idEvento else {return}
        
        utils.obterDetalhesEvento(idEvento: idEvento, completion: {(evento) in
            DispatchQueue.main.async {
                self.evento = evento
                if let resultadoDetalheEvento = self.evento{
                    self.labelTituloEvento.text = resultadoDetalheEvento.title
                    self.labelData.text = self.utils.formatacaoData(dataUnix: resultadoDetalheEvento.date)
                    self.labelDescricao.text = resultadoDetalheEvento.description
                    let localizacao = CLLocation(latitude: resultadoDetalheEvento.latitude, longitude: resultadoDetalheEvento.longitude)
                    let location2D = CLLocationCoordinate2D(latitude: resultadoDetalheEvento.latitude, longitude: resultadoDetalheEvento.longitude)
                    self.utils.setarMarcadorMapa(localizacao: location2D, mapView: self.mapaLocalizacao)
                    self.utils.obterEnderecoPorLatELon(latitude: resultadoDetalheEvento.latitude, longitude: resultadoDetalheEvento.longitude, labelEndereco: self.labelEndereco)
                    self.mapaLocalizacao.centerToLocation(localizacao)
                    self.labelPreco.text = self.utils.formatacaoMoeda(valor: resultadoDetalheEvento.price)
                    self.utils.obterImagem(url: resultadoDetalheEvento.image, imageView: self.imagemEvento)
                    ProgressHUD.dismiss()
                }
                
            }
            
        }, onError: {(error) in
            
        })
    }
    
    func addSubviews(){
        
        view.addSubview(self.scrollView)
        view.addSubview(botaoVoltar)
        view.addSubview(botaoCheckin)
        self.scrollView.addSubview(imagemEvento)
        self.scrollView.addSubview(contentView)
        self.contentView.addSubview(labelTituloEvento)
        self.contentView.addSubview(labelTituloData)
        self.contentView.addSubview(labelData)
        self.contentView.addSubview(labelDescricao)
        self.contentView.addSubview(labelTituloLocalizacao)
        self.contentView.addSubview(labelEndereco)
        self.contentView.addSubview(mapaLocalizacao)
        self.contentView.addSubview(labelTituloPreco)
        self.contentView.addSubview(labelPreco)
        self.contentView.addSubview(labelRodape)
    }
    

    func setupViews(){
        
        self.botaoVoltar.widthAnchor.constraint(equalToConstant: 50).isActive = true
        self.botaoVoltar.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.botaoVoltar.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        self.botaoVoltar.leftAnchor.constraint(equalTo: self.scrollView.leftAnchor, constant: 15).isActive = true
        self.botaoVoltar.addTarget(self, action: #selector(voltar), for: .touchDown)
        
        
        self.botaoCheckin.widthAnchor.constraint(equalToConstant: 55).isActive = true
        self.botaoCheckin.heightAnchor.constraint(equalToConstant: 55).isActive = true
        self.botaoCheckin.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        self.botaoCheckin.rightAnchor.constraint(equalTo: self.scrollView.rightAnchor, constant: -15).isActive = true
        self.botaoCheckin.addTarget(self, action: #selector(realizarCheckin), for: .touchDown)
        
        self.scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true;
        self.scrollView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true;
        self.scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true;
        self.scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true;
        
        self.contentView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor).isActive = true
        //self.contentView.heightAnchor.constraint(equalToConstant: 800).isActive = true
        self.contentView.widthAnchor.constraint(equalToConstant: self.scrollView.frame.width).isActive = true
        self.contentView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        self.contentView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        self.contentView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 200).isActive = true
        self.contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        self.imagemEvento.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        self.imagemEvento.heightAnchor.constraint(equalToConstant: 220).isActive = true
        self.imagemEvento.topAnchor.constraint(equalTo: self.scrollView.topAnchor).isActive = true
        self.imagemEvento.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        
        self.labelTituloEvento.heightAnchor.constraint(equalToConstant: 30).isActive = true
        self.labelTituloEvento.widthAnchor.constraint(equalToConstant: 300).isActive = true
        self.labelTituloEvento.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40).isActive = true
        self.labelTituloEvento.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        
        
        self.labelTituloData.heightAnchor.constraint(equalToConstant: 30).isActive = true
        self.labelTituloData.widthAnchor.constraint(equalToConstant: 150).isActive = true
        self.labelTituloData.topAnchor.constraint(equalTo: self.labelTituloEvento.bottomAnchor, constant: 20).isActive = true
        self.labelTituloData.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        
        
        self.labelData.heightAnchor.constraint(equalToConstant: 30).isActive = true
        self.labelData.widthAnchor.constraint(equalToConstant: 150).isActive = true
        self.labelData.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        self.labelData.topAnchor.constraint(equalTo: self.labelTituloData.bottomAnchor, constant: 10).isActive = true
        
        self.labelDescricao.heightAnchor.constraint(equalToConstant: 450).isActive = true
        self.labelDescricao.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, constant: -20).isActive = true
        self.labelDescricao.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        self.labelDescricao.topAnchor.constraint(equalTo: self.labelData.bottomAnchor, constant: 20).isActive = true
        
        self.labelTituloLocalizacao.heightAnchor.constraint(equalToConstant: 30).isActive = true
        self.labelTituloLocalizacao.widthAnchor.constraint(equalToConstant: 150).isActive = true
        self.labelTituloLocalizacao.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        self.labelTituloLocalizacao.topAnchor.constraint(equalTo: self.labelDescricao.bottomAnchor, constant: 20).isActive = true
        
        self.labelEndereco.heightAnchor.constraint(equalToConstant: 30).isActive = true
        self.labelEndereco.widthAnchor.constraint(equalToConstant: 300).isActive = true
        self.labelEndereco.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        self.labelEndereco.topAnchor.constraint(equalTo: self.labelTituloLocalizacao.bottomAnchor, constant: 10).isActive = true
        
        self.mapaLocalizacao.heightAnchor.constraint(equalToConstant: 400).isActive = true
        self.mapaLocalizacao.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, constant: -20).isActive = true
        self.mapaLocalizacao.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        self.mapaLocalizacao.topAnchor.constraint(equalTo: self.labelEndereco.bottomAnchor, constant: 10).isActive = true

        self.labelTituloPreco.heightAnchor.constraint(equalToConstant: 30).isActive = true
        self.labelTituloPreco.widthAnchor.constraint(equalToConstant: 150).isActive = true
        self.labelTituloPreco.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        self.labelTituloPreco.topAnchor.constraint(equalTo: self.mapaLocalizacao.bottomAnchor, constant: 20).isActive = true
        
        self.labelPreco.heightAnchor.constraint(equalToConstant: 30).isActive = true
        self.labelPreco.widthAnchor.constraint(equalToConstant: 150).isActive = true
        self.labelPreco.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        self.labelPreco.topAnchor.constraint(equalTo: self.labelTituloPreco.bottomAnchor, constant: 10).isActive = true
        
        self.labelRodape.heightAnchor.constraint(equalToConstant: 100).isActive = true
        self.labelRodape.widthAnchor.constraint(equalToConstant: 150).isActive = true
        self.labelRodape.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        self.labelRodape.topAnchor.constraint(equalTo: self.labelPreco.bottomAnchor, constant: 20).isActive = true
    }
    
    @objc private func voltar() {

        navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func realizarCheckin() {

        guard let eventoCheckin = evento else {return}
        let checkinViewController = CheckinViewController(evento: eventoCheckin)

        //checkinViewController.evento = eventoCheckin
        self.navigationController?.pushViewController(checkinViewController, animated: true)
    }

}
