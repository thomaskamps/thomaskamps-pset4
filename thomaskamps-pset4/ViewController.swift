//
//  ViewController.swift
//  thomaskamps-pset4
//
//  Created by Thomas Kamps on 24-11-16.
//  Copyright © 2016 Thomas Kamps. All rights reserved.
//

import UIKit


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let db = DatabaseHelper()
    var todos: Array<Dictionary<String, Any>> = []
    
    @IBOutlet weak var addBar: UITextField!
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if db == nil {
            print("Error")
        }
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.read()
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func read() {
        
        do {
            let results = try db?.read()
            self.todos = results as! Array<Dictionary<String, Any>>
        } catch {
            print(error)
        }
    }

    @IBAction func addItem(_ sender: Any) {
        
        self.addTodo()
        
    }
    
    @IBAction func addButton(_ sender: Any) {
        
        self.addTodo()
        
    }
    
    func addTodo() {
        
        if self.addBar.text! != "" {
            
            do {
                try db?.create(todo: self.addBar.text!)
            } catch {
                print(error)
            }
            
            self.addBar.text = ""
            self.read()
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.todos.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        
        let todo = self.todos[indexPath.row]
        cell.labelOutlet.text = todo["todo"] as! String?
        cell.id = todo["id"] as! Int64?
        let temp = todo["done"]! as! Bool
        
        cell.doneImg.isHidden = !temp
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let currentDone = self.todos[indexPath.row]["done"] as! Bool
        let newDone = !currentDone
        let currentId = self.todos[indexPath.row]["id"] as! Int64
        
        do {
            try db?.editDone(id: currentId, done: newDone)
        } catch {
            print(error)
        }
        
        self.tableView.deselectRow(at: indexPath, animated: true)
        self.read()
        self.tableView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.delete {
            
            let currentId = self.todos[indexPath.row]["id"] as! Int64
            
            do {
                try db?.remove(id: currentId)
            } catch {
                print(error)
            }
            self.read()
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            self.tableView.reloadData()
        }
    }
}

