//
//  CheckinViewController.swift
//  TesteNTConsult
//
//  Created by Filipe de Souza on 20/10/21.
//

import UIKit
import ProgressHUD

class CheckinViewController: UIViewController {

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
    
    lazy var botaoCompartilhar: UIButton = {
        let view = UIButton()
        var config = UIImage.SymbolConfiguration(scale: .large)
        config = config.applying(UIImage.SymbolConfiguration(font: .systemFont(ofSize: 36.0)))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setImage(UIImage(systemName: "arrowshape.turn.up.forward.fill", withConfiguration: config), for: .normal)
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
    
    private lazy var nomeTextField: UITextField = {
        let view = UITextField()
        view.placeholder = "Digite seu nome completo"
        view.backgroundColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 0.25)
        view.layer.cornerRadius = 8
        view.textAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var emailTextField: UITextField = {
        let view = UITextField()
        view.placeholder = "Digite seu email"
        view.backgroundColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 0.25)
        view.layer.cornerRadius = 8
        view.textAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var checkinButton: UIButton = {
        let view = UIButton()
        view.setTitle("Check-in", for: .normal)
        view.backgroundColor = UIColor(named: Constantes.BrandColors.sicredi)
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: - Variáveis e constantes
    var evento: EventoModel
    let utils = Utils()
    var endereco: String  = ""
    
    init(evento: EventoModel ) {
        self.evento = evento
        super.init(nibName: nil, bundle: nil)
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(named: Constantes.BrandColors.sicredi)
        addSubviews()
        setupViews()
        // Do any additional setup after loading the view.
        //guard let eventoCheckin = evento else{return}
        utils.obterImagem(url: evento.image, imageView: imagemEvento)
        labelTituloEvento.text = evento.title
    }
    
    func addSubviews(){
        

        self.view.addSubview(imagemEvento)
        self.view.addSubview(botaoVoltar)
        self.view.addSubview(botaoCompartilhar)
        self.view.addSubview(contentView)
        self.contentView.addSubview(labelTituloEvento)
        self.contentView.addSubview(nomeTextField)
        self.contentView.addSubview(emailTextField)
        self.contentView.addSubview(checkinButton)

    }
    

    func setupViews(){
        
        self.botaoVoltar.widthAnchor.constraint(equalToConstant: 50).isActive = true
        self.botaoVoltar.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.botaoVoltar.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        self.botaoVoltar.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 15).isActive = true
        self.botaoVoltar.addTarget(self, action: #selector(voltar), for: .touchDown)
        
        
        self.botaoCompartilhar.widthAnchor.constraint(equalToConstant: 46).isActive = true
        self.botaoCompartilhar.heightAnchor.constraint(equalToConstant: 46).isActive = true
        self.botaoCompartilhar.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        self.botaoCompartilhar.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -15).isActive = true
        self.botaoCompartilhar.addTarget(self, action: #selector(realizarCompartilhamento), for: .touchDown)
        
        self.contentView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        //self.contentView.heightAnchor.constraint(equalToConstant: 800).isActive = true
        self.contentView.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
        self.contentView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        self.contentView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        self.contentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 200).isActive = true
        self.contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        self.imagemEvento.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        self.imagemEvento.heightAnchor.constraint(equalToConstant: 220).isActive = true
        self.imagemEvento.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        self.imagemEvento.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        
        self.labelTituloEvento.heightAnchor.constraint(equalToConstant: 30).isActive = true
        self.labelTituloEvento.widthAnchor.constraint(equalToConstant: 300).isActive = true
        self.labelTituloEvento.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40).isActive = true
        self.labelTituloEvento.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        
        self.nomeTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        self.nomeTextField.widthAnchor.constraint(equalToConstant: 300).isActive = true
        self.nomeTextField.topAnchor.constraint(equalTo: labelTituloEvento.topAnchor, constant: 60).isActive = true
        self.nomeTextField.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        
        self.emailTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        self.emailTextField.widthAnchor.constraint(equalToConstant: 300).isActive = true
        self.emailTextField.topAnchor.constraint(equalTo: nomeTextField.topAnchor, constant: 40).isActive = true
        self.emailTextField.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        
        self.checkinButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        self.checkinButton.widthAnchor.constraint(equalToConstant: 300).isActive = true
        self.checkinButton.topAnchor.constraint(equalTo: emailTextField.topAnchor, constant: 70).isActive = true
        self.checkinButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        self.checkinButton.addTarget(self, action: #selector(realizarCheckin), for: .touchDown)
    }
    
    @objc private func voltar() {

        navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func realizarCompartilhamento() {
        //guard let eventoCheckin = evento else{return}
        if !utils.compartilhamentoWhatsapp(evento: evento, endereco: endereco){
            let alert = UIAlertController(title: Constantes.tituloAlerta, message: Constantes.mensagemRetornoErro, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: Constantes.botaoOkAlerta, style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else{
            let alert = UIAlertController(title: Constantes.tituloAlerta, message: Constantes.mensagemRetornoSucesso, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: Constantes.botaoOkAlerta, style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc private func realizarCheckin() {

        ProgressHUD.show()
        //guard let eventoCheckin = evento else{return}
        guard let campoNome = nomeTextField.text else{return}
        guard let campoEmail = emailTextField.text else{return}
        if !utils.validarDadosVazios(nome: campoNome, email: campoEmail) {
            if utils.validarEmail(campoEmail) {
                utils.realizarCheckin(eventoID: evento.id, nome: campoNome, email: campoEmail) { (retorno) in
                    DispatchQueue.main.async {

                            self.finalizaCheckin()

                    }
                } onError: { (erro) in
                    switch erro{
                        case .erroDataTask:
                            self.mensagemErro()
                        case .semResposta:
                            self.mensagemErro()
                        case .erroResposta:
                            self.mensagemErro()
                        default:
                            self.mensagemErro()
                    }
                }

            }else{
                let alerta = UIAlertController(title: Constantes.tituloAlerta, message: Constantes.mensagemEmailInvalido, preferredStyle: .alert)
                alerta.addAction(UIAlertAction(title: Constantes.botaoOkAlerta, style: .cancel, handler: nil))
                self.present(alerta, animated: true, completion: nil)
            }
        }else{
            let alerta = UIAlertController(title: Constantes.tituloAlerta, message: Constantes.mensagemCamposVazios, preferredStyle: .alert)
            alerta.addAction(UIAlertAction(title: Constantes.botaoOkAlerta, style: .cancel, handler: nil))
            self.present(alerta, animated: true, completion: nil)
        }
    }

    //MARK: - Alerta checkin realizado
    func finalizaCheckin(){
        ProgressHUD.dismiss()
        let alerta = UIAlertController(title: Constantes.tituloAlerta, message: Constantes.mensagemCheckinRealizado, preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: Constantes.botaoOkAlerta, style: .default, handler: { action in
            self.navigationController?.popToRootViewController(animated: true)
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alerta, animated: true, completion: nil)
    }
    
    //MARK: - Mensagem Erro
    func mensagemErro(){
        let alerta = UIAlertController(title: Constantes.tituloAlerta, message: Constantes.mensagemSistemaIndisponivel, preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: Constantes.botaoOkAlerta, style: .cancel, handler: nil))
        self.present(alerta, animated: true, completion: nil)
    }

}
