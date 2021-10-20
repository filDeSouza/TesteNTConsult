//
//  CheckinViewController.swift
//  TesteNTConsult
//
//  Created by Filipe de Souza on 10/10/21.
//

import UIKit

enum RetornoCheckin{
    case sucesso
}

enum ErroCheckin {
    case taskError(error: Error)
    case noResponse
    case erroResposta
}

class RealizarCheckinViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var imageHeader: UIImageView!
    @IBOutlet weak var labelTitulo: UILabel!
    @IBOutlet weak var textFieldNome: UITextField!
    @IBOutlet weak var textFieldEmail: UITextField!
    
    //MARK: - Variáveis e constantes
    var evento: EventoModel?
    let utils = Utils()
    var endereco: String  = ""
    
    //MARK: - Didload
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let eventoCheckin = evento else{return}
        utils.obterImagem(url: eventoCheckin.image, imageView: imageHeader)
        labelTitulo.text = eventoCheckin.title
        // Do any additional setup after loading the view.
    }
    
    //MARK: - Realiza checkin
    @IBAction func btAcaoCheckin(_ sender: UIButton) {
        guard let eventoCheckin = evento else{return}
        guard let campoNome = textFieldNome.text else{return}
        guard let campoEmail = textFieldEmail.text else{return}
        if !utils.validarDadosVazios(nome: campoNome, email: campoEmail) {
            if utils.validarEmail(campoEmail) {
                utils.realizarCheckin(eventoID: eventoCheckin.id, nome: campoNome, email: campoEmail) { (retorno) in
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
                let alert = UIAlertController(title: Constantes.tituloAlerta, message: Constantes.mensagemEmailInvalido, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: Constantes.botaoOkAlerta, style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }else{
            let alert = UIAlertController(title: Constantes.tituloAlerta, message: Constantes.mensagemCamposVazios, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: Constantes.botaoOkAlerta, style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }

        
    }
    
    //MARK: - Alerta checkin realizado
    func finalizaCheckin(){
        let alert = UIAlertController(title: Constantes.tituloAlerta, message: Constantes.mensagemCheckinRealizado, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Constantes.botaoOkAlerta, style: .default, handler: { action in
            self.performSegue(withIdentifier: Constantes.segueRetornaEventos, sender: self)
                    self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Mensagem Erro
    func mensagemErro(){
        let alert = UIAlertController(title: Constantes.tituloAlerta, message: Constantes.mensagemSistemaIndisponivel, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Constantes.botaoOkAlerta, style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Voltar
    @IBAction func fechaPaginaCheckin(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func compartilharEvento(_ sender: UIButton) {
        
        guard let eventoCheckin = evento else{return}
        if !utils.compartilhamentoWhatsapp(evento: eventoCheckin, endereco: endereco){
            let alert = UIAlertController(title: Constantes.tituloAlerta, message: Constantes.mensagemRetornoErro, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: Constantes.botaoOkAlerta, style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else{
            let alert = UIAlertController(title: Constantes.tituloAlerta, message: Constantes.mensagemRetornoSucesso, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: Constantes.botaoOkAlerta, style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
}
