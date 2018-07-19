//
//  ViewController.swift
//  SwiftCoreData
//
//  Created by Daniel Coria on 18/07/18.
//  Copyright © 2018 Daniel Coria. All rights reserved.
//

import UIKit
import CoreData

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
        getUser()
        
    }
    
    @objc func addNewUser(){
        
        let alertController = UIAlertController(title: "new brand", message: "Fill with one brand you love", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default){ action in
            
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let managedObjectContext = appDelegate.persistentContainer.viewContext
            
            let entity = NSEntityDescription.entity(forEntityName: "User", in: managedObjectContext)
            let newUser = NSManagedObject(entity: entity!, insertInto: managedObjectContext)
            
            newUser.setValue("apple", forKey: "username")
            newUser.setValue("12345", forKey: "password")
            newUser.setValue("20", forKey: "age")
            
            appDelegate.persistentContainer.performBackgroundTask { (context) in
                appDelegate.saveContext()
            }
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        alertController.addTextField(configurationHandler: nil)
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func getUser(){
        DispatchQueue.main.async {[weak self] in
            
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let managedObjectContext = appDelegate.persistentContainer.viewContext
            
            do {
                
                let userCreated = try managedObjectContext.fetch(request) as! [NSManagedObject]
                
                for data in userCreated{
                    let value = data.value(forKey: "username") as! String
                    print(value)
                    print("_____")
                }
                
            } catch  {
                print("failed fetch")
            }
        }
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

