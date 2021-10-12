//
//  EventCell.swift
//  TesteNT
//
//  Created by Filipe de Souza on 05/10/21.
//

import UIKit

class EventoCell: UITableViewCell {

    @IBOutlet weak var viewCelula: UIView!
    @IBOutlet weak var imageViewCelula: UIImageView!
    @IBOutlet weak var labelTitleCelula: UILabel!
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
