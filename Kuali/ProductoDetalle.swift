//
//  ProductoDetalle.swift
//  Kuali
//
//  Created by Gerardo G on 11/16/18.
//  Copyright © 2018 Andrea . All rights reserved.
//

import UIKit
import Firebase

class ProductoDetalle: UIViewController {
    
    var id_producto = 0
    var producto: DataSnapshot!
    
    @IBOutlet weak var nombre: UILabel!
    @IBOutlet weak var marca: UILabel!
    @IBOutlet weak var precio: UILabel!
    @IBOutlet weak var descripcion: UILabel!
    @IBOutlet weak var imagen: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.producto = obtenerProducto()
        mostrarInfoProducto()
        // Do any additional setup after loading the view.
    }
    
    func obtenerProducto() -> DataSnapshot{
        var object = ""
        var res: DataSnapshot!
        for prod in GeneralInformation.productos{
            object = "\(prod.childSnapshot(forPath: "id").value as! CFNumber)"
            if(Int(object)! == id_producto){
                res = prod
            }
        }
        return res
    }
    
    func mostrarInfoProducto(){
        let nomProd = self.producto.childSnapshot(forPath: "nombre").value as! String
        let marcaProd = self.producto.childSnapshot(forPath: "marca").value as! String
        let precioProd = self.producto.childSnapshot(forPath: "precio").value as! CFNumber
        let descrProd = self.producto.childSnapshot(forPath: "descripcion").value as! String
        let string_url = (self.producto.childSnapshot(forPath: "url_imagenes").value as! [String])[0]
        
        nombre.text = nomProd
        marca.text = marcaProd
        precio.text = "$\(precioProd)"
        descripcion.text = descrProd
        imagen.image = UIImage.init(named: "cargando")
        
        if let url = URL(string: string_url){
            //DispatchQueue.main.async {
            let tarea = URLSession.shared.dataTask(with: url) { (data, responde, error) in
                if error == nil {
                    let respuesta = responde as! HTTPURLResponse
                    if respuesta.statusCode == 200 {
                        DispatchQueue.main.async {
                             self.imagen.image = UIImage(data: data!)!
                        }
                    }
                } else {
                    print("Error en la imagen")
                }
            }
            tarea.resume()
            //}
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
