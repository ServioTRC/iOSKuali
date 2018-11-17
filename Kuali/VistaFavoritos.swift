//
//  VistaFavoritos.swift
//  Kuali
//
//  Created by Servio Tulio Reyes Castillo on 16/11/18.
//  Copyright © 2018 Andrea . All rights reserved.
//

import UIKit
import Firebase

class VistaFavoritos: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var productos : [DataSnapshot]! = []
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        filtrarProductosFav()
        // Do any additional setup after loading the view.
    }
    
    func filtrarProductosFav(){
        var object: String!
        for producto in GeneralInformation.productos{
            object = "\(producto.childSnapshot(forPath: "id").value as! CFNumber)"
            if(GeneralInformation.favoritos.contains(Int(object)!)){
                productos.append(producto)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.productos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "celda", for: indexPath) as! CeldaProducto
        if self.productos[indexPath.row].value != nil{
            let productoSnapshot: DataSnapshot! = self.productos[indexPath.row]
            let nomProd = productoSnapshot.childSnapshot(forPath: "nombre").value as! String
            let likesProd = productoSnapshot.childSnapshot(forPath: "numLikes").value as! CFNumber
            let precioProd = productoSnapshot.childSnapshot(forPath: "precio").value as! CFNumber
            
            let object = "\(productoSnapshot.childSnapshot(forPath: "id").value as! CFNumber)"
            cell.id_producto = Int(object)!
            //print("celda\(cell.id_producto)")
            cell.nombre.text = nomProd
            cell.precio.text = "$\(precioProd)"
            cell.likes.text = "\(likesProd)"
            cell.imagen.image = UIImage.init(named: "cargando")
            
            let string_url = (productoSnapshot.childSnapshot(forPath: "url_imagenes").value as! [String])[0]
            
            if let url = URL(string: string_url){
                //DispatchQueue.main.async {
                let tarea = URLSession.shared.dataTask(with: url) { (data, responde, error) in
                    if error == nil {
                        let respuesta = responde as! HTTPURLResponse
                        if respuesta.statusCode == 200 {
                            DispatchQueue.main.async {
                                cell.imagen.image = UIImage(data: data!)!
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
        
        return cell
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "favorito_detalle"{
            let destinationViewController = segue.destination as! ProductoDetalle
            let cell = sender as! CeldaProducto
            destinationViewController.id_producto = cell.id_producto
            //print("cambio \(self.id_producto)")
        }
    }


}
