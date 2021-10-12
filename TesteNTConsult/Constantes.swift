//
//  Constantes.swift
//  TesteNT
//
//  Created by Filipe de Souza on 05/10/21.
//

import Foundation

class Constants{
    //MARK: - Valores de url's
    static let base_url: String = "https://5f5a8f24d44d640016169133.mockapi.io/api/"
    static let end_point_events: String = "events/"
    static let end_point_checkin: String = "checkin"
    
    //MARK: - Celula
    static let cellIdentifier = "reusableCell"
    static let cellNibName = "EventoCell"
    
    //MARK: - Segues
    static let segueToDetalhe = "segueDetalhe"
    static let segueRetornaEventos = "retornaTelaEventos"
    
    //MARK: - ViewControllers
    static let viewControllerDetalhe = "viewControllerDetalhe"
    static let viewControllerCheckin = "viewControllerCheckin"
    
    //MARK: - Mensagens
    static let mensagemRetornoSucesso = "Compartilhamento efetuado com sucesso"
    static let mensagemRetornoErro = "Não foi possível compartilhar, verifique se o WhatsApp está instalado!"
    static let mensagemSistemaIndisponivel = "Sistema indisponivel no momento"
    static let mensagemCheckinRealizado = "Check-in realizado com sucesso!"
    static let mensagemEmailInvalido = "O email inserido não é válido"
    static let mensagemCamposVazios = "Todos os campos devem ser preenchidos"
    
    //MARK: - Titulos Alerta
    static let tituloAlerta = "Aviso"
    
    //MARK: - Botões alertas
    static let botaoOkAlerta = "Ok"
}
