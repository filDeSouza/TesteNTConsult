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
    case taskError
    case noResponse
    case noData
    case responseStatusCode(code: Int)
    case invalidJSON
    case erroResposta
}

enum APIRetorno{
    case sucesso
}

class Utils {
    
    let apiService = APIService()
    
    //MARK: - Obter eventos da API
    func obterEventos(completion: @escaping([EventModel]?) -> Void, onError: @escaping(EventosError) -> Void){
        apiService.performRequestEvent(completion: { (result) in
            if result != nil{
                completion(result)
            }
        }, onError: { (error) in
            switch error{
            case .invalidJSON:
                onError(.invalidJSON)
            case .noData:
                onError(.noData)
            case .noResponse:
                onError(.noResponse)
            case .erroResposta:
                onError(.erroResposta)
            default:
                print("Erro genérico")
            }
        })
    }
    
    //MARK: - Obter detalhes do evento da API
    func obterDetalhesEvento(idEvento: String, completion: @escaping(EventModel?) -> Void, onError: @escaping(EventosError) -> Void){
        apiService.performRequestDetalheEvento(idEvento: idEvento, completion: { (result) in
            if result != nil{
                completion(result)
            }
        }, onError: { (error) in
            switch error{
            case .invalidJSON:
                onError(.invalidJSON)
            case .noData:
                onError(.noData)
            case .noResponse:
                onError(.noResponse)
            case .erroResposta:
                onError(.erroResposta)
            default:
                print("Erro genérico")
            }
        })
    }
    
    //MARK: - Realizar POST checkin
    func realizarCheckin(eventoID: String, nome: String, email: String, completion: @escaping(APIRetorno) -> Void, onError: @escaping(EventosError) -> Void){
        apiService.performCheckin(idEvento: eventoID, nome: nome, email: email) { (result) in
            if result != nil{
                completion(.sucesso)
            }
        } onError: { (error) in
            switch error{
            case .invalidJSON:
                onError(.invalidJSON)
            case .noData:
                onError(.noData)
            case .noResponse:
                onError(.noResponse)
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
    func getImage(url: String, imageView: UIImageView){
        
        guard let url = URL(string: url) else {return}
        
        getData(from: url) { data, response, error in
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
    func popularCelulaEvento(_ evento: EventModel,_ cell: EventoCell){

        cell.labelTitleCelula.text = evento.title
        
        guard let url = URL(string: evento.image) else {return}
        
        
        getData(from: url) { data, response, error in

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
    
    //MARK: - Formatação da sombra da célula
    func cellViewShadow(cell: EventoCell){
        
        cell.viewCelula.layer.shadowColor = UIColor.black.cgColor
        cell.viewCelula.layer.shadowPath = UIBezierPath(rect: cell.viewCelula.bounds).cgPath
        cell.viewCelula.layer.shadowRadius = 5
        cell.viewCelula.layer.shadowOffset = CGSize(width: 0, height: 1)
        cell.viewCelula.layer.shadowOpacity = 0.3
        
    }
    
    //MARK: - Obter valor da imagem por meio da URLSession
    func getData(from url: URL, completion: @escaping(Data?, URLResponse?, Error?) -> ()){
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
    func isEmailValido(_ email: String) -> Bool{
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
        
    }
    
    func compartilhamentoWhatsapp(evento: EventModel, endereco: String) -> Bool{
        
        let mensagem = "Olá\nGostaria de compartilhar com você este evento:\n\n\(evento.title)/n/nEle acontecerá em \(formatacaoData(dataUnix: evento.date))\n\nEndereço:\n\(endereco)\n\nO valor para a participação é de \(formatacaoMoeda(valor: evento.price)), seria muito legal se você participasse!!"
        var mensagemRetorno: Bool!
        let queryCharSet = NSCharacterSet.urlQueryAllowed
        
        if let escapedString = mensagem.addingPercentEncoding(withAllowedCharacters: queryCharSet) {
            if let whatsAppUrl = URL(string: "whatsapp://send?text=\(escapedString)"){
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
    
    func getAdressFromLatLon(latitude: Double, longitude: Double, labelEndereco: UILabel){
        
        var center: CLLocationCoordinate2D = CLLocationCoordinate2D()
        
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = latitude
        center.longitude = longitude
        let location: CLLocation = CLLocation(latitude: center.latitude, longitude: center.longitude)
                
        ceo.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
            
            if error != nil{
                print("reverse geodcode fail: \(error!.localizedDescription)")
            }
            
            let pm = placemarks! as [CLPlacemark]
                        
            if pm.count > 0 {
                                let pm = placemarks![0]

                                var addressString : String = ""

                                if pm.thoroughfare != nil {
                                    addressString = addressString + pm.thoroughfare! + ", "
                                }
                                if pm.subThoroughfare != nil {
                                    addressString = addressString + pm.subThoroughfare! + ", "
                                }
                                if pm.subLocality != nil {
                                    addressString = addressString + pm.subLocality! + ", "
                                }
                                if pm.locality != nil {
                                    addressString = addressString + pm.locality! + ", "
                                }
                                if pm.country != nil {
                                    addressString = addressString + pm.country! + ", "
                                }
                                if pm.postalCode != nil {
                                    addressString = addressString + pm.postalCode! + " "
                                }

                                labelEndereco.text = addressString
                
                          }
        })

    }
    
    func setPinUsingMKPlacemark(location: CLLocationCoordinate2D, mapView: MKMapView) {
       let pin = MKPlacemark(coordinate: location)
       let coordinateRegion = MKCoordinateRegion(center: pin.coordinate, latitudinalMeters: 800, longitudinalMeters: 800)
       mapView.setRegion(coordinateRegion, animated: true)
       mapView.addAnnotation(pin)
    }

}

//MARK: - Extensão ImageView para obter dados da imagem pela URL
extension UIImageView{
    func load(url: URL){
        DispatchQueue.global().async { [weak self] in
            
            if let data = try? Data(contentsOf: url){
                if let image = UIImage(data: data){
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
            
        }
    }
}

//MARK: - Extensão MAP para obter localização
extension MKMapView{
    func centerToLocation(
        _ location: CLLocation, regionRadius: CLLocationDistance = 500
    ){
        let coordinateRegion = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius)
        setRegion(coordinateRegion, animated: true)
    }
}
