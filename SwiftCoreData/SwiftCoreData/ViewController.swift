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
    
    struct UserData {
        var username: String?
        var age: String?
        var password: String?
    }
    
    var items : [NSManagedObject] = []
    var usersData : [UserData] = []
    
    
    var password    = "123"
    var age         = "10"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        navigationController?.navigationBar.barTintColor = UIColor(red: 27/255, green: 165/255, blue: 225/255, alpha: 1)
        navigationController?.navigationBar.tintColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addNewUser))
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getUser()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func addNewUser(){
        
        let alertController = UIAlertController(title: "new brand", message: "Fill with one brand you love", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self] action in
            guard let textfield = alertController.textFields?.first, let itemToAdd = textfield.text else { return }
            
            self?.saveUser(input: itemToAdd)
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        alertController.addTextField(configurationHandler: nil)
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
        
    }
    
    func refreshCurrentData(){
        
        self.tableView.reloadData()
    }
    
    func saveUser(input:String){
        if (self.isValidUsername(username: input)){
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let managedObjectContext = appDelegate.persistentContainer.viewContext
            
            //let entity = NSEntityDescription.entity(forEntityName: "User", in: managedObjectContext!)
            let user = User(context: managedObjectContext)
            //let newUser = NSManagedObject(entity: entity!, insertInto: managedObjectContext)
            
            user.username = input
            user.password = self.password
            user.age = self.age
            //newUser.setValue("lolo", forKey: "username")
            //newUser.setValue("12345", forKey: "password")
            //newUser.setValue("20", forKey: "age")
            
            
            let userModel = UserData.init(username: input, age: self.age, password: self.password)
            appDelegate.persistentContainer.performBackgroundTask { (context) in
                appDelegate.saveContext()
            }
            self.usersData.append(userModel)
            self.refreshCurrentData()
        }
    }
    
    func getUser(){
        DispatchQueue.main.async {[weak self] in
            
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let managedObjectContext = appDelegate.persistentContainer.viewContext
            
            do {
                
                self?.items = try managedObjectContext.fetch(request) as! [NSManagedObject]
                let userCreated = self?.items
                
                for data in userCreated!{
                    let user = UserData.init(username: data.value(forKey: "username") as? String, age: data.value(forKey: "age") as? String, password: data.value(forKey: "password") as? String)
                    self?.usersData.append(user)
                    print("_____")
                }
                self?.tableView.reloadData()
            } catch  {
                print("failed fetch")
            }
        }
    }
    
    
    func isValidUsername(username: String) -> Bool{
        var isUsername = Bool()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return false }
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        
        do {
            let result = try managedObjectContext.fetch(request)
            let userCreated = result
            
            if userCreated.count != 0{
                for data in userCreated as! [NSManagedObject] {
                    
                    if (data.value(forKey: "username") as! String) == username{
                        isUsername = false
                        self.showAlert(title: "Invalid name", message: "This brand already exist")
                    }else{
                        isUsername = true
                    }
                }
            }else{
                isUsername = true
            }
        } catch  {
            print("failed fetch")
        }
        return isUsername
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
        return usersData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let item = self.usersData[indexPath.row]
        cell.textLabel?.text = item.username
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        if editingStyle == .delete {
            
            do {
                self.items = try managedObjectContext.fetch(User.fetchRequest())
                
                let task = self.items[indexPath.row]
                managedObjectContext.delete(task)
                appDelegate.persistentContainer.performBackgroundTask { (context) in
                    appDelegate.saveContext()
                }
                
                
                self.usersData.remove(at: indexPath.row)
                self.refreshCurrentData()
            } catch {
                print("Fetching Failed")
            }
        }
        tableView.reloadData()
    }
    
}


