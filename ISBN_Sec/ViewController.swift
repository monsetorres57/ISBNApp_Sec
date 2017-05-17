//
//  ViewController.swift
//  ISBN_Sec
//
//  Created by Monse on 12/05/17.
//  Copyright © 2017 Monse. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate,UITableViewDataSource{

    @IBOutlet weak var isbnText: UITextField!
    @IBOutlet weak var tituloText: UILabel!
    @IBOutlet weak var autList: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isbnText.delegate = self
        isbnText.text = ""
        autList.text = ""
        //autoresList.dataSource = self
        //autoresList.dataSource = self
        // Do any additional setup after loading the view, typically from a nib.
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        isbnText.resignFirstResponder()
        asyncISBN()
        return true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "CellName", for: indexPath)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func asyncISBN(){
       
        var aut = [String]()
        let urls = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:\(isbnText.text!)"//978-84-376-0494-7
        let urlString = URL(string: urls)
        if let url = urlString {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    DispatchQueue.main.async {
                        print("error")
                        let alert = UIAlertController(title: "Alert", message: "Sin conexion", preferredStyle: UIAlertControllerStyle.alert)
                         alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                         /*alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction!) in print("you have pressed the Cancel button")
                         }))*/
                         self.present(alert, animated: true, completion: nil)
                        //self.result.text = "Error de conexión"
                    }
                    //print(error)
                } else {
                    DispatchQueue.main.async {
                    if let usableData = data,
                    let json = try? JSONSerialization.jsonObject(with: usableData, options: []) as? [String: Any]
                    {
                        if ((json?.keys.count)!>0){
                        //let dic1 = json as NSDictionary
                        //tituloText.text =
                        //print(json) //JSONSerialization
                            if let ISBN = json?["ISBN:\(self.isbnText.text!)"] as? [String: Any] {
                                self.tituloText.text = ISBN["title"] as? String
                                if let authors = ISBN["authors"] as? [[String: Any]] {
                                    for author in authors {
                                        if let name = author["name"] as? String{
                                            self.autList.text! += name + "\n"
                                        }
                                    }
                                }
                                /*
                                for case let result in ISBN["authors"] {
                                    if let au = Restaurant(ISBN: result) {
                                        self.autList.text(au)
                                    }
                                }*/
                            // access individual value in dictionary
                            }
                            
                        }else{
                            let alert = UIAlertController(title: "Alert", message: "No se encontraron elementos", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                      
                    }
                  }
                }
            }
            task.resume()
                //let session = URLSession.shared
        
    }

    }

}

