//
//  PantallaFormulario.swift
//  Kuali
//
//  Created by Servio Tulio Reyes Castillo on 22/11/18.
//  Copyright © 2018 Andrea . All rights reserved.
//

import UIKit
import MessageUI

class PantallaFormulario: UIViewController, MFMailComposeViewControllerDelegate {
    
    
 
    @IBOutlet weak var nombre_prod: UITextField!
    @IBOutlet weak var url_imagenes: UITextField!
    @IBOutlet weak var marca: UITextField!
    @IBOutlet weak var tiendas: UITextField!
    @IBOutlet weak var sociales: UITextField!
    @IBOutlet weak var precio: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func enviar_correo(_ sender: Any) {
        if(validar_datos()){
            sendEmail()
        }
    }
    
    func validar_datos() -> Bool{
        if(nombre_prod.text == ""){
            let alert = UIAlertController(title: "ERROR", message: "Nombre del Producto Vacío", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: nil))
            self.present(alert, animated: true)
            return false
        } else if(url_imagenes.text == ""){
            let alert = UIAlertController(title: "ERROR", message: "Campo de Imágenes Vacío", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: nil))
            self.present(alert, animated: true)
            return false
        } else if(marca.text == ""){
            let alert = UIAlertController(title: "ERROR", message: "Nombre de la Marca Vacío", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: nil))
            self.present(alert, animated: true)
            return false
        } else if(precio.text == "" || Float(precio.text!)! <= 0){
            let alert = UIAlertController(title: "ERROR", message: "Campo de Precio Inválido", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: nil))
            self.present(alert, animated: true)
            return false
        }
        return true
    }
    
    /*
     
     let alert = UIAlertController(title: "FELICIDADES", message: "Ganaste usando \(controlador.cuenta) turnos", preferredStyle: .alert)
     alert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: nil))
     self.present(alert, animated: true)
     
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    func sendEmail() {
        var mail_text = "<p>Enviando información de productos: </p>"
        mail_text += "<p>\(nombre_prod.text ?? "none")</p>"
        mail_text += "<p>\(url_imagenes.text ?? "none")</p>"
        mail_text += "<p>\(marca.text ?? "none")</p>"
        mail_text += "<p>\(tiendas.text ?? "none")</p>"
        mail_text += "<p>\(sociales.text ?? "none")</p>"
        mail_text += "<p>\(precio.text ?? "none")</p>"
        print("Mail: "+mail_text)
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["app.kuali.mx@gmail.com"])
            mail.setMessageBody(mail_text, isHTML: true)
            
            present(mail, animated: true)
        } else {
            // show failure alert
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
}
