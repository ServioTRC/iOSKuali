//
//  ViewController.swift
//  Kuali
//
//  Created by Andrea  on 11/10/18.
//  Copyright © 2018 Andrea . All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    //var database: DatabaseReference!
    var productos : [DataSnapshot]! = []
    private var handle : DatabaseHandle!
    var id_producto = 0
    
    //@IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //database = Database.database().reference()
        collectionView.dataSource = self
        self.productos = GeneralInformation.productos
        //cargarProductos()
        ordenarProductos()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int)-> Int {
        return productos.count
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
    
    /*func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("lectura \(indexPath)")
        let cell = collectionView.cellForItem(at: indexPath) as! CeldaProducto
        print("celda completa: " + cell.nombre.text!)
        self.id_producto = cell.id_producto
    }*/
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "cambio_producto"{
            let destinationViewController = segue.destination as! ProductoDetalle
            let cell = sender as! CeldaProducto
            destinationViewController.id_producto = cell.id_producto
            //print("cambio \(self.id_producto)")
        }
    }
    
}
