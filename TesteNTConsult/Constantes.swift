//
//  Constantes.swift
//  TesteNT
//
//  Created by Filipe de Souza on 05/10/21.
//

import Foundation

class Constantes{
    //MARK: - Valores de url's
    static let base_url: String = "https://5f5a8f24d44d640016169133.mockapi.io/api/"
    static let end_point_eventos: String = "events/"
    static let end_point_checkin: String = "checkin"
    
    //MARK: - Celula
    static let celulaIdentificador = "reusableCell"
    static let cellNibName = "EventoCell"
    
    //MARK: - Segues
    static let segueToDetalhe = "segueDetalhe"
    static let segueRetornaEventos = "retornaTelaEventos"
    
    //MARK: - ViewControllers
    static let viewControllerEventos = "viewControllerEventos"
    static let viewControllerCheckin = "viewControllerCheckin"
    static let viewControllerDetalhes = "viewControllerDetalhes"
    
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
    
    struct BrandColors{
        static let sicredi = "sicrediColor"

    }
}
