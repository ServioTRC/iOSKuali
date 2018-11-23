//
//  ProductoDetalle.swift
//  Kuali
//
//  Created by Gerardo G on 11/16/18.
//  Copyright © 2018 Andrea . All rights reserved.
//

import UIKit
import Firebase

class ProductoDetalle: UIViewController, UIGestureRecognizerDelegate {
    
    var id_producto = 0
    var producto: DataSnapshot!
    var productoLikes: DatabaseReference!
    var database: DatabaseReference!
    var numLikes = 0
    var tienda_url = String()
    
    @IBOutlet weak var nombre: UILabel!
    @IBOutlet weak var marca: UILabel!
    @IBOutlet weak var precio: UILabel!
    @IBOutlet weak var descripcion: UILabel!
    @IBOutlet weak var imagen: UIImageView!
    @IBOutlet weak var imgHeart: UIImageView!
    
    
    @IBAction func irATienda(_ sender: Any) {
        guard let url = URL(string: self.tienda_url) else {
            print("Error en url tienda")
            return
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.producto = obtenerProducto()
        mostrarInfoProducto()
        let UITapRecognizer = UITapGestureRecognizer(target: self, action: #selector(ProductoDetalle.tappedImage))
        UITapRecognizer.delegate = self
        self.imgHeart.addGestureRecognizer(UITapRecognizer)
        self.imgHeart.isUserInteractionEnabled = true
        database = Database.database().reference()
        numLikes = self.producto.childSnapshot(forPath: "numLikes").value as! Int
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
        print("prod : \(id_producto )");
        let nomProd = self.producto.childSnapshot(forPath: "nombre").value as! String
        let marcaProd = self.producto.childSnapshot(forPath: "marca").value as! String
        let precioProd = self.producto.childSnapshot(forPath: "precio").value as! CFNumber
        let descrProd = self.producto.childSnapshot(forPath: "descripcion").value as! String
        let string_url = (self.producto.childSnapshot(forPath: "url_imagenes").value as! [String])[0]
        self.tienda_url = (self.producto.childSnapshot(forPath: "url_tiendas").childSnapshot(forPath: "0").childSnapshot(forPath: "1").value as! String)
        print("tienda: \(tienda_url)")
        
        nombre.text = nomProd
        marca.text = marcaProd
        precio.text = "$\(String(format: "%.2f", Double(truncating: precioProd)))"
        //precio.text = "$\(precioProd))"
        descripcion.text = descrProd
        imagen.image = UIImage.init(named: "cargando")
        if(GeneralInformation.favoritos.contains(id_producto)){
            imgHeart.image = UIImage(named: "favoriteheart")
        }
        if let url = URL(string: string_url){
            //DispatchQueue.main.async {
            let tarea = URLSession.shared.dataTask(with: url) { (data, responde, error) in
                if error == nil {
                    let respuesta = responde as! HTTPURLResponse
                    if respuesta.statusCode == 200 {
                        DispatchQueue.main.async {
                            self.imagen.image = UIImage(data: data!)
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
    
    @objc func tappedImage() {
        productoLikes = database.child("Productos").child("\(id_producto)")
        if(GeneralInformation.favoritos.contains(id_producto)){
            for i in 0..<GeneralInformation.favoritos.count{
                if(GeneralInformation.favoritos[i] == id_producto){
                    GeneralInformation.favoritos.remove(at: i)
                    break;
                }
            }
        } else {
            GeneralInformation.favoritos.append(id_producto)
            print("agregado")
        }
        productoLikes.observeSingleEvent(of: .value) { (snapshot) in
            self.numLikes = snapshot.childSnapshot(forPath: "numLikes").value as! Int
            print("snap : \(snapshot.childSnapshot(forPath: "numLikes").value as! Int)")
        }
        print("Likes: \(self.numLikes)")
        if(imgHeart.image == UIImage(named: "favoriteheart")) {
            imgHeart.image = UIImage(named: "unfavoriteheart")
            database.child("Productos").child("\(id_producto)").child("numLikes").setValue(self.numLikes-1)
        } else {
            imgHeart.image = UIImage(named: "favoriteheart")
            database.child("Productos").child("\(id_producto)").child("numLikes").setValue(self.numLikes+1)
        }
    }
    
}
