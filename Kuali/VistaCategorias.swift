//
//  VistaCategorias.swift
//  Kuali
//
//  Created by Servio Tulio Reyes Castillo on 16/11/18.
//  Copyright © 2018 Andrea . All rights reserved.
//

import UIKit
import Firebase

class VistaCategorias: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate {
    
    var categorias : [DataSnapshot]! = []
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var barra_busqueda: UISearchBar!
    var busqueda = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        self.categorias = GeneralInformation.categorias
        self.barra_busqueda.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("Cambio")
        self.busqueda = barra_busqueda.text!
        self.performSegue(withIdentifier: "categorias_filtro", sender: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.categorias.count
    } //43 42 78
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "celda", for: indexPath) as! CeldaCategoria
        if self.categorias[indexPath.row].value != nil{
            let categoriaSnapshot: DataSnapshot! = self.categorias[indexPath.row]
            let nomCat = categoriaSnapshot.childSnapshot(forPath: "nombre").value as! String
            let string_url = categoriaSnapshot.childSnapshot(forPath: "url_thumbnail").value as! String
            
            cell.nombre.text = nomCat;
            cell.imagen.image = UIImage.init(named: "cargando")
            
            if let url = URL(string: string_url){
                let tarea = URLSession.shared.dataTask(with: url) { (data, responde, error) in
                    if error == nil {
                        let respuesta = responde as! HTTPURLResponse
                        if respuesta.statusCode == 200 {
                            DispatchQueue.main.async {
                                cell.imagen.image = UIImage(data: data!)
                            }
                        }
                    } else {
                        print("Error en la imagen")
                    }
                }
                tarea.resume()
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
        if segue.identifier == "filtro_categoria"{
            let destinationViewController = segue.destination as! ProductosFiltrados
            let cell = sender as! CeldaCategoria
            destinationViewController.tipo_filtrado = "categoria"
            destinationViewController.nombre_filtrado = cell.nombre.text!
            //print("cambio \(self.id_producto)")
        } else if(segue.identifier == "categorias_filtro"){
            let destinationViewController = segue.destination as! ProductosFiltrados
            destinationViewController.tipo_filtrado = "nombre"
            destinationViewController.nombre_filtrado = self.busqueda
            print(self.busqueda)
        }
    }
    
}
