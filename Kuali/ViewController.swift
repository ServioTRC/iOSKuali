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
    
    var database: DatabaseReference!
    var productos : [DataSnapshot]! = []
    private var handle : DatabaseHandle!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        database = Database.database().reference()
        collectionView.dataSource = self
        cargarProductos()
        ordenarProductos()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func cargarProductos() {
        self.productos.removeAll()
        
        self.database.child("Productos").observeSingleEvent(of: .value) { (snapshot) in
            /*self.productos = (snapshot.value as! [DataSnapshot])
            print("Productos \(self.productos.count)")
            print("Ejemplo \(self.productos[1].key)")
            self.collectionView.reloadData()*/
            for child in snapshot.children{
                self.productos.append(child as! DataSnapshot)
            }
            self.ordenarProductos()
            self.collectionView.reloadData()
            //print("\(self.productos[1].childSnapshot(forPath: "nombre"))")
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
            
            cell.nombre.text = nomProd
            cell.precio.text = "$\(precioProd)"
            cell.likes.text = "\(likesProd)"
            cell.imagen.image = UIImage.init(named: "cargando")
            
            let string_url = (productoSnapshot.childSnapshot(forPath: "url_imagenes").value as! [String])[0]
            
            if let url = URL(string: string_url){
                DispatchQueue.main.async {
                    let tarea = URLSession.shared.dataTask(with: url) { (data, responde, error) in
                        if error == nil {
                            let respuesta = responde as! HTTPURLResponse
                            if respuesta.statusCode == 200 {
                                cell.imagen.image = UIImage(data: data!)!
                            }
                        } else {
                            print("Error en la imagen")
                        }
                    }
                    tarea.resume()
                }
            }
        }
        
        return cell
        
    }
    
}
