//
//  TableViewController.swift
//  tell_me_what_to_do
//
//  Created by Madeline Tjoa on 5/9/20.
//  Copyright © 2020 Madeline Tjoa. All rights reserved.
//
import MongoSwift
import UIKit

class TableViewController:
    UIViewController, UITableViewDataSource, UITableViewDelegate {
    let tableView = UITableView() // Create our tableview
    
    private var userId: String? {
        return stitch.auth.currentUser?.id
    }
    
    fileprivate var todoItems = [TodoItem]() // our table view data source
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        
        // check to make sure a user is logged in
        // if they are, load the user's todo items and refresh the tableview
        if stitch.auth.isLoggedIn {
//            itemsCollection.find(["owner_id": "all"]).toArray { result in
//                switch result {
//                case .success(let todos):
//                    self.todoItems = todos
//                    DispatchQueue.main.async {
//                        self.tableView.reloadData()
//                    }
//                case .failure(let e):
//                    fatalError(e.localizedDescription)
//                }
//            }
            itemsCollection.find(["owner_id": self.userId!]).toArray { result in
                switch result {
                case .success(let todos):
                    self.todoItems = todos
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                case .failure(let e):
                    fatalError(e.localizedDescription)
                }
            }
        } else {
            // no user is logged in, send them back to the welcome view
            self.navigationController?.setViewControllers([WelcomeViewController()], animated: true)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        title = "Your To-Do List"
        self.tableView.dataSource = self
        self.tableView.delegate = self
        view.addSubview(self.tableView)
        self.tableView.frame = self.view.frame
        
//        let addButton = UIBarButtonItem(barButtonSystemItem: .add,
//                                        target: self,
//                                        action: #selector(self.addTodoItem(_:)))
        
        let logoutButton = UIBarButtonItem(title: "Logout",
                                           style: .plain,
                                           target: self,
                                           action: #selector(self.logout(_:)))
//        navigationItem.leftBarButtonItem = addButton
        navigationItem.rightBarButtonItem = logoutButton
    }
    
    
    @objc func buttonActionList(sender: UIButton!) {}
    
    /* On button click we will generate a random integer that determines what text will be placed */
    var label = UILabel(frame: CGRect(x: 0, y: 0, width: 420, height: 100))
    @objc func buttonAction(sender: UIButton!) {
        print("Button tapped")
        var command = ""
        if Int.random(in: 0 ..< 2) == 0{
            let action = ["Say hi to", "Solve", "Carry", "Pet", "Peel", "Smell", "Pick up", "Find", "Draw"]
            let object = ["rubix cube", "cat", "snake", "apple", "pen", "potato", "boba", "mom"]
            command = action[Int.random(in: 0 ..< (action.count))] + " a " + object[Int.random(in: 0 ..< (object.count))]
        }
        else{
           
           
        }
        
        let action = ["Say hi to", "Solve", "Carry", "Pet", "Peel", "Smell", "Pick up", "Find", "Draw"]
        let object = ["rubix cube", "cat", "snake", "apple", "pen", "potato", "boba", "mom"]
        command = action[Int.random(in: 0 ..< (action.count))] + " a " + object[Int.random(in: 0 ..< (object.count))]
        
        
        var total_items = 0
        itemsCollection.count() { result in
          switch result {
          case .success(let numDocs):
            total_items = numDocs
          case .failure(let error):
            print("Failed to count documents: ", error)
          }
        }
//        let number = Int.random(in: 0 ..< total_items)
        
        /*Add the randomly grabbed item to our todo list*/
        var task = command
        let todoItem = TodoItem(id: ObjectId(),
                                ownerId: "all",
                                task: task,
                                checked: false)
        // optimistically add the item and reload the data
        self.todoItems.append(todoItem)
        self.tableView.reloadData()
        itemsCollection.insertOne(todoItem) { result in
            switch result {
            case .failure(let e):
                print("error inserting item, \(e.localizedDescription)")
                // an error occured, so remove the item we just inserted and reload the data again to refresh the ui
                DispatchQueue.main.async {
                    self.todoItems.removeLast()
                    self.tableView.reloadData()
                }
            case .success:
                // no action necessary
                print("successfully inserted a document")
            }
        }
        
        
        /*update label*/
 
        label.textAlignment = .center
        label.textColor = .black
        label.backgroundColor = .white
        label.text = command
        self.view.addSubview(label)
    }
    
    @objc func logout(_ sender: Any) {
        stitch.auth.logout { result in
            switch result {
            case .failure(let e):
                print("Had an error logging out: \(e)")
            case .success:
                DispatchQueue.main.async {
                    self.navigationController?.setViewControllers([WelcomeViewController()], animated: true)
                }
            }
        }
    }
    
    @objc func addTodoItem(_ sender: Any) {
        let alertController = UIAlertController(title: "Add Item", message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "ToDo item"
        }
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            if let task = alertController.textFields?.first?.text {
                let todoItem = TodoItem(id: ObjectId(),
                                        ownerId: "all",
                                        task: task,
                                        checked: false)
                // optimistically add the item and reload the data
                self.todoItems.append(todoItem)
                self.tableView.reloadData()
                itemsCollection.insertOne(todoItem) { result in
                    switch result {
                    case .failure(let e):
                        print("error inserting item, \(e.localizedDescription)")
                        // an error occured, so remove the item we just inserted and reload the data again to refresh the ui
                        DispatchQueue.main.async {
                            self.todoItems.removeLast()
                            self.tableView.reloadData()
                        }
                    case .success:
                        // no action necessary
                        print("successfully inserted a document")
                    }
                }
            }
        }))
        self.present(alertController, animated: true)
    }
    
    func tableView(_ tableView: UITableView,
                   shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        var item = self.todoItems[indexPath.row]
        let title = item.checked ? NSLocalizedString("Undone", comment: "Undone") : NSLocalizedString("Done", comment: "Done")
        let action = UIContextualAction(style: .normal, title: title, handler: { _, _, completionHander in
            item.checked = !item.checked
            self.todoItems[indexPath.row] = item
            DispatchQueue.main.async {
                self.tableView.reloadData()
                completionHander(true)
            }
        })
        
        action.backgroundColor = item.checked ? .red : .green
        let configuration = UISwipeActionsConfiguration(actions: [action])
        return configuration
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard case .delete = editingStyle else { return }
        let item = todoItems[indexPath.row]
        itemsCollection.deleteOne(["_id": item.id]) { result in
            switch result {
            case .failure(let e):
                print("Error, could not delete: \(e.localizedDescription)")
            case .success:
                self.todoItems.remove(at: indexPath.row)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.todoItems.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell") ?? UITableViewCell(style: .default, reuseIdentifier: "TodoCell")
        cell.selectionStyle = .none
        let item = todoItems[indexPath.row]
        cell.textLabel?.text = item.task
        cell.accessoryType = item.checked ? UITableViewCell.AccessoryType.checkmark : UITableViewCell.AccessoryType.none
        return cell
    }
}
