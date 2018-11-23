//
//  ProductosFiltrados.swift
//  Kuali
//
//  Created by Servio Tulio Reyes Castillo on 16/11/18.
//  Copyright © 2018 Andrea . All rights reserved.
//

import UIKit
import Firebase

class ProductosFiltrados: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var label: UILabel!
    var tipo_filtrado = "" //nombre, categoria
    var nombre_filtrado = ""
    var cat_tag = ""
    var productos : [DataSnapshot]! = []
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var no_hay_productos: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        obtenerTags()
        if(tipo_filtrado == "categoria"){
            filtrarProductosCat()
        } else {
            filtrarProductosNombre()
        }
        // Do any additional setup after loading the view.
    }
    
    func obtenerTags(){
        if(tipo_filtrado == "categoria"){
            if(nombre_filtrado == "Salud y Belleza"){
                cat_tag = "Salud_Belleza"
            } else if(nombre_filtrado == "Mascotas"){
                cat_tag = "Mascotas"
            } else if(nombre_filtrado == "Alimentos"){
                cat_tag = "Alimentos"
            } else if(nombre_filtrado == "Hogar"){
                cat_tag = "Hogar"
            } else if(nombre_filtrado == "Cosméticos"){
                cat_tag = "Cosmeticos"
            } else if(nombre_filtrado == "Ropa y accesorios"){
                cat_tag = "Ropa_Accesorios"
            } else if(nombre_filtrado == "Juguetes"){
                cat_tag = "Juguetes"
            } else if(nombre_filtrado == "Artesanías"){
                cat_tag = "Artesanias"
            } else if(nombre_filtrado == "Tecnología"){
                cat_tag = "Tecnologia"
            }
            self.label.text? = "Categoría: "+cat_tag
        } else {
            cat_tag = nombre_filtrado
            self.label.text? = "Búsqueda: "+cat_tag
        }
    }
    
    func filtrarProductosCat(){
        var prod_cat: [String]!
        for producto in GeneralInformation.productos{
            prod_cat = (producto.childSnapshot(forPath: "categorias").value as! [String])
            if(prod_cat.contains(cat_tag)){
                productos.append(producto)
            }
        }
        print("Num prod: \(productos.count)")
        if(productos.count <= 0){
            collectionView.isHidden = true
            no_hay_productos.isHidden = false
        } else {
            no_hay_productos.isHidden = true
            collectionView.isHidden = false
            ordenarProductos()
        }
    }
    
    func filtrarProductosNombre(){
        var prod_name: String!
        var prod_descr: String!
        var prod_marca: String!
        for producto in GeneralInformation.productos{
            prod_name = (producto.childSnapshot(forPath: "nombre").value as! String)
            prod_descr = (producto.childSnapshot(forPath: "descripcion").value as! String)
            prod_marca = (producto.childSnapshot(forPath: "marca").value as! String)
            if(prod_name.lowercased().contains(self.nombre_filtrado.lowercased()) || prod_descr.lowercased().contains(self.nombre_filtrado.lowercased()) || prod_marca.lowercased().contains(self.nombre_filtrado.lowercased())){
                productos.append(producto)
            }
        }
        print("Num prod: \(productos.count)")
        if(productos.count <= 0){
            collectionView.isHidden = false
        } else {
            no_hay_productos.isHidden = true
            ordenarProductos()
        }
    }
    
    func ordenarProductos(){
        var temp : DataSnapshot!
        var first: CFNumber
        var second: CFNumber
        for _ in 0..<self.productos.count{
            for j in 0..<self.productos.count-1{
                first = self.productos[j].childSnapshot(forPath: "numLikes").value as! CFNumber
                second = self.productos[j+1].childSnapshot(forPath: "numLikes").value as! CFNumber
                if(CFNumberCompare(first, second, nil).rawValue < 0){
                    temp = self.productos[j]
                    self.productos[j] = self.productos[j+1]
                    self.productos[j+1] = temp
                }
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
            cell.likes.text = "\(likesProd) Likes"
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
     } filtrado_detalle
     */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "filtrado_detalle"{
            let destinationViewController = segue.destination as! ProductoDetalle
            let cell = sender as! CeldaProducto
            destinationViewController.id_producto = cell.id_producto
            //print("cambio \(self.id_producto)")
        }
    }
    
}

