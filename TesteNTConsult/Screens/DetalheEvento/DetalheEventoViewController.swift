//
//  DetalheEventoViewController.swift
//  TesteNTConsult
//
//  Created by Filipe de Souza on 08/10/21.
//

import UIKit
import MapKit
import ProgressHUD

class DetalheEventoViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var labelTituloEvento: UILabel!
    @IBOutlet weak var imagemEvento: UIImageView!
    @IBOutlet weak var labelData: UILabel!
    @IBOutlet weak var labelDescricao: UILabel!
    @IBOutlet weak var labelPreco: UILabel!
    @IBOutlet weak var mapaLocalizacao: MKMapView!
    @IBOutlet weak var labelEndereco: UILabel!
    
    //MARK: - Variáveis e constantes
    var idEvento: String?
    let utils = Utils()
    var evento: EventoModel?
    
    //MARK: - Didload
    override func viewDidLoad() {
        super.viewDidLoad()

        ProgressHUD.show()
        let contentWidth = scrollView.bounds.width
        scrollView.isScrollEnabled = true
        scrollView.contentSize = CGSize(width: contentWidth, height: 1500)
        
        guard let idEventoDetalhe = idEvento else {return}
        
        let utils = Utils()
        utils.obterDetalhesEvento(idEvento: idEventoDetalhe, completion: {(evento) in
            DispatchQueue.main.async {
                self.evento = evento
                if let resultadoDetalheEvento = self.evento{
                    self.labelTituloEvento.text = resultadoDetalheEvento.title
                    self.labelData.text = utils.formatacaoData(dataUnix: resultadoDetalheEvento.date)
                    self.labelDescricao.text = resultadoDetalheEvento.description
                    let localizacao = CLLocation(latitude: resultadoDetalheEvento.latitude, longitude: resultadoDetalheEvento.longitude)
                    let location2D = CLLocationCoordinate2D(latitude: resultadoDetalheEvento.latitude, longitude: resultadoDetalheEvento.longitude)
                    utils.setarMarcadorMapa(localizacao: location2D, mapView: self.mapaLocalizacao)
                    utils.obterEnderecoPorLatELon(latitude: resultadoDetalheEvento.latitude, longitude: resultadoDetalheEvento.longitude, labelEndereco: self.labelEndereco)
                    self.mapaLocalizacao.centerToLocation(localizacao)
                    self.labelPreco.text = utils.formatacaoMoeda(valor: resultadoDetalheEvento.price)
                    utils.obterImagem(url: resultadoDetalheEvento.image, imageView: self.imagemEvento)
                    ProgressHUD.dismiss()
                }
                
            }
            
        }, onError: {(error) in
            
        })
    }
    
    //MARK: - Voltar
    @IBAction func eventoDismiss(_ sender: UIButton) {
        
        navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
        
    }
    
    //MARK: - Checkin
    @IBAction func btEfetuarCheckin(_ sender: UIButton) {
        guard let checkinViewController = self.storyboard?.instantiateViewController(identifier: Constantes.viewControllerCheckin) as? CheckinViewController else {return}
        guard let textoEndereco = labelEndereco.text else {return}
        checkinViewController.endereco = textoEndereco
        checkinViewController.evento = evento
        self.navigationController?.pushViewController(checkinViewController, animated: true)
    }
    
}
