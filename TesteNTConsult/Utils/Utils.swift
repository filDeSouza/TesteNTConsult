//
//  Utils.swift
//  TesteNT
//
//  Created by Filipe de Souza on 06/10/21.
//

import Foundation
import UIKit
import MapKit

enum EventosError {
    case loginInvalido
    case senhaInvalida
    case dadosVazios
    case url
    case erroDataTask
    case semResposta
    case semDados
    case erroCodigoRetorno(code: Int)
    case JSONinvalido
    case erroResposta
}

enum APIRetorno{
    case sucesso
}

class Utils {
    
    let apiService = APIService()
    
    //MARK: - Obter eventos da API
    func obterEventos(completion: @escaping([EventoModel]?) -> Void, onError: @escaping(EventosError) -> Void){
        apiService.obterEventos(completion: { (result) in
            if result != nil{
                completion(result)
            }
        }, onError: { (error) in
            switch error{
            case .JSONinvalido:
                onError(.JSONinvalido)
            case .semDados:
                onError(.semDados)
            case .semResposta:
                onError(.semResposta)
            case .erroResposta:
                onError(.erroResposta)
            default:
                print("Erro genérico")
            }
        })
    }
    
    //MARK: - Obter detalhes do evento da API
    func obterDetalhesEvento(idEvento: String, completion: @escaping(EventoModel?) -> Void, onError: @escaping(EventosError) -> Void){
        apiService.obterDetalheEvento(idEvento: idEvento, completion: { (result) in
            if result != nil{
                completion(result)
            }
        }, onError: { (error) in
            switch error{
            case .JSONinvalido:
                onError(.JSONinvalido)
            case .semDados:
                onError(.semDados)
            case .semResposta:
                onError(.semResposta)
            case .erroResposta:
                onError(.erroResposta)
            default:
                print("Erro genérico")
            }
        })
    }
    
    //MARK: - Realizar POST checkin
    func realizarCheckin(eventoID: String, nome: String, email: String, completion: @escaping(APIRetorno) -> Void, onError: @escaping(EventosError) -> Void){
        apiService.realizarCheckin(idEvento: eventoID, nome: nome, email: email) { (result) in
            if result != nil{
                completion(.sucesso)
            }
        } onError: { (error) in
            switch error{
            case .JSONinvalido:
                onError(.JSONinvalido)
            case .semDados:
                onError(.semDados)
            case .semResposta:
                onError(.semResposta)
            case .erroResposta:
                onError(.erroResposta)
            default:
                print("Erro genérico")
            }
        }

    }
    
    //MARK: - Formatação de moedas
    func formatacaoMoeda(valor: Double) -> String{
        
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        currencyFormatter.locale = Locale.current
        let valorFormatado: String = currencyFormatter.string(from: NSNumber(value: valor))!
        return valorFormatado
        
    }
    
    //MARK: - Formatação de data
    func formatacaoData(dataUnix: Int) -> String{
        let timeInterval = TimeInterval(dataUnix)

        let date = Date(timeIntervalSince1970: timeInterval/1000)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        dateFormatter.timeZone = .current
        let localDate = dateFormatter.string(from: date)
        
        return localDate
        
    }
    
    //MARK: - Obter dados da imagem
    func obterImagem(url: String, imageView: UIImageView){
        
        guard let url = URL(string: url) else {return}
        
        obterDadosImagem(from: url) { data, response, error in
            if error != nil{
                DispatchQueue.main.async {
                    imageView.image = UIImage(named: "Logomarca_Sicredi")
                }
            }else{
                guard let data = data else {return}
                guard let response = response as? HTTPURLResponse else{
                    return
                }
                
                if response.statusCode == 404 {
                    DispatchQueue.main.async {
                        imageView.image = UIImage(named: "Logomarca_Sicredi")
                    }
                }else{
                    DispatchQueue.main.async() { [weak self] in
                        imageView.image = UIImage(data: data)
                }
                
                }
        }
        
    }
    }
    
    //MARK: - Popular celula da TableView
    func popularCelulaEvento(_ evento: EventoModel,_ cell: EventoCell){

        cell.labelTitleCelula.text = evento.title
        
        guard let url = URL(string: evento.image) else {return}
        
        
        obterDadosImagem(from: url) { data, response, error in

            if error != nil{
                DispatchQueue.main.async {
                    cell.imageViewCelula.image = UIImage(named: "Logomarca_Sicredi")
                    print("erro ao carregar imagem do \(evento.title)")
                }
            }else{
                guard let data = data else {return}
                guard let response = response as? HTTPURLResponse else{
                    return
                }
                
                if response.statusCode == 404 {
                    DispatchQueue.main.async {
                        cell.imageViewCelula.image = UIImage(named: "Logomarca_Sicredi")
                        print("erro ao carregar imagem do \(evento.title)")
                    }
                }else{
                    DispatchQueue.main.async() { [weak self] in
                    cell.imageViewCelula?.image = UIImage(data: data)
                }
                
                }
            }
        }
    }
    
    //MARK: - Formatação da sombra da view
    func formatarSombraView(view: UIView){
        
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowPath = UIBezierPath(rect: view.bounds).cgPath
        view.layer.shadowRadius = 5
        view.layer.shouldRasterize = true
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowOpacity = 0.3
        
    }
    
    //MARK: - Formatação da sombra da célula
    func formatarSombraCelula(cell: EventoCell){
        
        cell.viewCelula.layer.shadowColor = UIColor.black.cgColor
        cell.viewCelula.layer.shadowPath = UIBezierPath(rect: cell.viewCelula.bounds).cgPath
        cell.viewCelula.layer.shadowRadius = 5
        cell.viewCelula.layer.shouldRasterize = true
        cell.viewCelula.layer.shadowOffset = CGSize(width: 0, height: 1)
        cell.viewCelula.layer.shadowOpacity = 0.3
        
    }
    
    //MARK: - Obter valor da imagem por meio da URLSession
    func obterDadosImagem(from url: URL, completion: @escaping(Data?, URLResponse?, Error?) -> ()){
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    //MARK: - Validação de dados vazios
    func validarDadosVazios(nome: String, email: String) -> Bool{
        
        if nome == "" || email == "" {
            return true
        }else{
            return false
        }
        
    }
    
    //MARK: - Validação de email
    func validarEmail(_ email: String) -> Bool{
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
        
    }
    
    //MARK: - Compartilhamento do WhatsApp
    func compartilhamentoWhatsapp(evento: EventoModel, endereco: String) -> Bool{
        
        let mensagem = "Olá\nGostaria de compartilhar com você este evento:\n\n\(evento.title)/n/nEle acontecerá em \(formatacaoData(dataUnix: evento.date))\n\nEndereço:\n\(endereco)\n\nO valor para a participação é de \(formatacaoMoeda(valor: evento.price)), seria muito legal se você participasse!!"
        var mensagemRetorno: Bool!
        let queryCaracteres = NSCharacterSet.urlQueryAllowed
        
        if let retornoString = mensagem.addingPercentEncoding(withAllowedCharacters: queryCaracteres) {
            if let whatsAppUrl = URL(string: "whatsapp://send?text=\(retornoString)"){
                if UIApplication.shared.canOpenURL(whatsAppUrl) {
                    UIApplication.shared.open(whatsAppUrl, options: [:], completionHandler: nil)
                    mensagemRetorno = true
                }else{
                    mensagemRetorno = false
                }
            }
        }
        return mensagemRetorno
    }
    
    //MARK: - Obter endereço pela Latitude e Longitude
    func obterEnderecoPorLatELon(latitude: Double, longitude: Double, labelEndereco: UILabel){
        
        var centro: CLLocationCoordinate2D = CLLocationCoordinate2D()
        
        let geocoder: CLGeocoder = CLGeocoder()
        centro.latitude = latitude
        centro.longitude = longitude
        let localizacao: CLLocation = CLLocation(latitude: centro.latitude, longitude: centro.longitude)
                
        geocoder.reverseGeocodeLocation(localizacao, completionHandler: { (placemarks, error) in
            
            if error != nil{
                print("reverse geodcode fail: \(error!.localizedDescription)")
            }
            
            let pm = placemarks! as [CLPlacemark]
                        
            if pm.count > 0 {
                                let pm = placemarks![0]

                                var enderecoString : String = ""

                                if pm.thoroughfare != nil {
                                    enderecoString = enderecoString + pm.thoroughfare! + ", "
                                }
                                if pm.subThoroughfare != nil {
                                    enderecoString = enderecoString + pm.subThoroughfare! + ", "
                                }
                                if pm.subLocality != nil {
                                    enderecoString = enderecoString + pm.subLocality! + ", "
                                }
                                if pm.locality != nil {
                                    enderecoString = enderecoString + pm.locality! + ", "
                                }
                                if pm.country != nil {
                                    enderecoString = enderecoString + pm.country! + ", "
                                }
                                if pm.postalCode != nil {
                                    enderecoString = enderecoString + pm.postalCode! + " "
                                }

                                labelEndereco.text = enderecoString
                
                          }
        })

    }
    
    //MARK: - Colocar marcador no mapa
    func setarMarcadorMapa(localizacao: CLLocationCoordinate2D, mapView: MKMapView) {
       let pin = MKPlacemark(coordinate: localizacao)
       let coordenadasRegiao = MKCoordinateRegion(center: pin.coordinate, latitudinalMeters: 800, longitudinalMeters: 800)
       mapView.setRegion(coordenadasRegiao, animated: true)
       mapView.addAnnotation(pin)
    }

}

//MARK: - Extensão ImageView para obter dados da imagem pela URL
extension UIImageView{
    func load(url: URL){
        DispatchQueue.global().async { [weak self] in
            
            if let data = try? Data(contentsOf: url){
                if let imagem = UIImage(data: data){
                    DispatchQueue.main.async {
                        self?.image = imagem
                    }
                }
            }
            
        }
    }
}

//MARK: - Extensão MAP para obter localização
extension MKMapView{
    func centerToLocation(
        _ localizacao: CLLocation, raioRegiao: CLLocationDistance = 500
    ){
        let coordenadasRegiao = MKCoordinateRegion(
            center: localizacao.coordinate,
            latitudinalMeters: raioRegiao,
            longitudinalMeters: raioRegiao)
        setRegion(coordenadasRegiao, animated: true)
    }
}
