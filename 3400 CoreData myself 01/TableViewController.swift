//
//  TableViewController.swift
//  3400 CoreData myself 01
//
//  Created by Trương Quang on 7/15/19.
//  Copyright © 2019 truongquang. All rights reserved.
//

import UIKit
import CoreData
class TableViewController: UITableViewController {
    
    @IBOutlet var outletTableView: UITableView!
    var people = [NSManagedObject]()
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    var managedObjectContext: NSManagedObjectContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "List"
        self.clearsSelectionOnViewWillAppear = true
        managedObjectContext = appDelegate?.persistentContainer.viewContext

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Person")
        do {
            people = try managedObjectContext?.fetch(fetchRequest) ?? []
        } catch {
            print(error)
        }
    }
    
    @IBAction func addName(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "New name", message: "Add a new name", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default) { (_) in
            guard let textField = alertController.textFields?.first,
                let nameToSave = textField.text
            else {return}
            
            self.save(name: nameToSave)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Nhap ten vao day"
        }
        alertController.addAction(okAction)
        alertController.addAction(cancel)
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    func save(name: String) {
        let entity = NSEntityDescription.entity(forEntityName: "Person", in: managedObjectContext!)!
        let person = NSManagedObject(entity: entity, insertInto: managedObjectContext)
        person.setValue(name, forKey: "name")
        do {
            try managedObjectContext?.save()
            people.append(person)
            outletTableView.reloadData()
        } catch {
            print(error)
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = people[indexPath.row].value(forKey: "name") as? String
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            managedObjectContext?.delete(people[indexPath.row])
            people.remove(at: indexPath.row)
            outletTableView.deleteRows(at: [indexPath], with: .automatic)
            appDelegate?.saveContext()
        }    
    }
 


}
