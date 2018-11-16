//
//  PantallaInicio.swift
//  Kuali
//
//  Created by Servio Tulio Reyes Castillo on 16/11/18.
//  Copyright © 2018 Andrea . All rights reserved.
//

import UIKit
import Firebase

class PantallaInicio: UIViewController {
    
    var database: DatabaseReference!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        database = Database.database().reference()
        let transform = CGAffineTransform(scaleX: 3, y: 3)
        indicator.transform = transform
        indicator.startAnimating()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        cargarElementos()
    }
    
    func cargarElementos() {
        //self.productos.removeAll()
        
        self.database.child("Productos").observeSingleEvent(of: .value) { (snapshot) in
            /*self.productos = (snapshot.value as! [DataSnapshot])
             print("Productos \(self.productos.count)")
             print("Ejemplo \(self.productos[1].key)")
             self.collectionView.reloadData()*/
            for child in snapshot.children{
                GeneralInformation.productos.append(child as! DataSnapshot)
            }
        }
            
        self.database.child("Categorias").observeSingleEvent(of: .value) { (snapshot) in
            for child in snapshot.children{
                GeneralInformation.categorias.append(child as! DataSnapshot)
            }
            //self.ordenarProductos()
            //self.collectionView.reloadData()
            //print("\(self.productos[1].childSnapshot(forPath: "nombre"))")
            self.realizarCambio()
        }
        
    }
    
    func cargarCategorias() {
        //self.productos.removeAll()
        
        self.database.child("Categorias").observeSingleEvent(of: .value) { (snapshot) in
            /*self.productos = (snapshot.value as! [DataSnapshot])
             print("Productos \(self.productos.count)")
             print("Ejemplo \(self.productos[1].key)")
             self.collectionView.reloadData()*/
            for child in snapshot.children{
                GeneralInformation.categorias.append(child as! DataSnapshot)
            }
            //self.ordenarProductos()
            //self.collectionView.reloadData()
            //print("\(self.productos[1].childSnapshot(forPath: "nombre"))")
        }
        
    }
    
    func realizarCambio(){
        self.performSegue(withIdentifier: "CambioAProductos", sender: self)
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
