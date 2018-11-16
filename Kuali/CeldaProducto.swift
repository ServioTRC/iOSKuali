//
//  CeldaProducto.swift
//  Kuali
//
//  Created by Andrea  on 11/13/18.
//  Copyright © 2018 Andrea . All rights reserved.
//

import Foundation
import UIKit

class CeldaProducto : UICollectionViewCell{
    
    var id_producto = 0
    @IBOutlet weak var imagen: UIImageView!
    @IBOutlet weak var nombre: UILabel!
    @IBOutlet weak var precio: UILabel!
    @IBOutlet weak var likes: UILabel!
    
}
