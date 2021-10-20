//
//  Coordinator.swift
//  TesteNTConsult
//
//  Created by Filipe de Souza on 20/10/21.
//

import Foundation
import UIKit

protocol Coordinator {
    var navigationController: UINavigationController {get set}
    func start()
}
