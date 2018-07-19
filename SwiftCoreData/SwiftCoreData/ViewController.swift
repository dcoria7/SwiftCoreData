//
//  ViewController.swift
//  SwiftCoreData
//
//  Created by Daniel Coria on 18/07/18.
//  Copyright © 2018 Daniel Coria. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var items : [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationController?.navigationBar.barTintColor = UIColor(red: 27/255, green: 165/255, blue: 225/255, alpha: 1)
        navigationController?.navigationBar.tintColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addNewUser))
        navigationItem.title = "Core Data"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    @objc func addNewUser(){
        
        let alertController = UIAlertController(title: "new brand", message: "Fill with one brand you love", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default)
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        alertController.addTextField(configurationHandler: nil)
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    // alert action
    func showAlert(title: String, message: String){
        let alert = UIAlertController(title:title, message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    // tableview delegates
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        return cell
        
    }
    
}

