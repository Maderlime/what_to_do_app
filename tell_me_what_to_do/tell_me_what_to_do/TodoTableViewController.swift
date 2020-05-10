//
//  TodoTableViewController.swift
//  
//
//  Created by Madeline Tjoa on 5/8/20.
//
import MongoSwift
import UIKit

class TodoTableViewController:
    UIViewController, UITableViewDataSource, UITableViewDelegate {
    let tableView = UITableView() // Create our tableview
    
    private var userId: String? {
        return stitch.auth.currentUser?.id
    }
    
    fileprivate var todoItems = [TodoItem]() // our table view data source
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        [self.navigationController?.setNavigationBarHidden(true, animated: false)];
        self.navigationController?.isNavigationBarHidden = true
        self.view.backgroundColor = UIColor(red: 214/255.0, green: 239/255.0, blue: 246/255.0, alpha:1)
        // check to make sure a user is logged in
        // if they are, load the user's todo items and refresh the tableview
        if stitch.auth.isLoggedIn {
            itemsCollection.find(["owner_id": "all"]).toArray { result in
                switch result {
                case .success(let todos):
                    self.todoItems = todos
                    DispatchQueue.main.async {
//                        self.tableView.reloadData()
                    }
                case .failure(let e):
                    fatalError(e.localizedDescription)
                }
            }
//            itemsCollection.find(["owner_id": self.userId!]).toArray { result in
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
//        self.tableView.dataSource = self
//        self.tableView.delegate = self
//        view.addSubview(self.tableView)
//        self.tableView.frame = self.view.frame
        
//        let addButton = UIBarButtonItem(barButtonSystemItem: .add,
//                                        target: self,
//                                        action: #selector(self.addTodoItem(_:)))

        
//        let logoutButton = UIBarButtonItem(title: "Logout",
//                                           style: .plain,
//                                           target: self,
//                                           action: #selector(self.logout(_:)))
        
        
   let imageName = "idle1.png"
    var image = UIImage(named: imageName)
    var imageView = UIImageView(image: image!)
    imageView.frame = CGRect(x: 100, y: 250, width: 300, height: 300)
    self.view.addSubview(imageView)
        
    let array: NSArray = [UIImage(named: "idle1.png"),UIImage(named: "middle.png"),UIImage(named: "idle2.png"),UIImage(named: "middle.png")];
        _ = UIImageView()
        imageView.animationImages = array as? [UIImage];
        imageView.animationDuration = 0.7;
       imageView.startAnimating()
       imageView.frame = CGRect(x: 40, y: 170, width: 300, height: 300)
        self.view.addSubview(imageView)
        


        
        
        
        let button = UIButton(type:.roundedRect)
        button.frame = CGRect(x: 10, y: 480, width: 360, height: 70)
        button.backgroundColor = .yellow
//        button.setImage(UIImage(named: "wat.png"), for:.normal)
        button.setTitle("Command Me", for: [])
        button.titleLabel?.font =  UIFont(name: "Chalkboard SE", size: 30)
        button.layer.cornerRadius = 6
        button.titleEdgeInsets = UIEdgeInsets(top: -10,left: -15,bottom: -10,right: -15)
        button.contentEdgeInsets = UIEdgeInsets(top: 5,left: 5,bottom: 5,right: 5)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        self.view.addSubview(button)
        
        let addButton = UIButton(type:.roundedRect)
            addButton.frame = CGRect(x: 10, y: 560, width: 360, height: 40)
            addButton.backgroundColor = .yellow
            addButton.setTitle("Add to your responsibilities", for: [])
//        addButton.setImage(UIImage(named: "want.png"), for:.normal)
        addButton.layer.cornerRadius = 6
        addButton.titleLabel?.font =  UIFont(name: "Chalkboard SE", size: 20)
        addButton.addTarget(self, action: #selector(self.addTodoItem(_:)), for: .touchUpInside)
        self.view.addSubview(addButton)
        
        let viewlistbtn = UIButton(type:.roundedRect)
        viewlistbtn.frame = CGRect(x: 10, y: 610, width: 360, height: 40)
        viewlistbtn.backgroundColor = .yellow
        viewlistbtn.setTitle("View My List", for: [])
//        viewlistbtn.setImage(UIImage(named: "willdo.png"), for:.normal)
        viewlistbtn.titleLabel?.font =  UIFont(name: "Chalkboard SE", size: 20)
        viewlistbtn.layer.cornerRadius = 6
        viewlistbtn.titleEdgeInsets = UIEdgeInsets(top: -10,left: -15,bottom: -10,right: -15)
        viewlistbtn.contentEdgeInsets = UIEdgeInsets(top: 5,left: 5,bottom: 5,right: 5)
        viewlistbtn.addTarget(self, action: #selector(buttonActionList), for: .touchUpInside)
        self.view.addSubview(viewlistbtn)
        
        var label = UILabel(frame: CGRect(x: 0, y: 100, width: 440, height: 100))
        label.center = CGPoint(x: 160, y: 120)
        label.textAlignment = .center
        label.backgroundColor = .white
        label.text = "I am ur leader!"
        label.font = UIFont(name: "Chalkboard SE", size: 40.0)
        self.view.addSubview(label)
        
//        navigationItem.leftBarButtonItem = addButton
//        navigationItem.rightBarButtonItem = logoutButton
    }
    
    @objc func buttonActionList(sender: UIButton!) {
        self.navigationController?.pushViewController(TableViewController(), animated: true)
    }
    
    /* On button click we will generate a random integer that determines what text will be placed */
    var label = UILabel(frame: CGRect(x: 0, y: 0, width: 420, height: 100))
    @objc func buttonAction(sender: UIButton!) {
        print("Button tapped")
        var command = ""
        let action = ["make", "carry", "pet", "peel", "smell", "pick up", "find", "draw", "swipe"]
        let object = ["rubix cube", "cat", "snake", "tree", "pen", "potato", "boba", "mom"]
        let moreactions = ["'Solve a Rubik’s Cube",
        "'Solve a Crossword puzzle",
        "'Solve a Riddle",
        "'Start a journal",
        "'Meditate",
        "'Do a 5 minute stretch",
        "'Call mother",
        "'Call father",
        "'Call ur dog",
        "'Call your dentist",
        "'Call a pizza place",
        "'Call a friend",
        "'Call a restaurant",
        "'Buy a banana",
        "'Write a haiku",
        "'Win 2 pokemon showdown games",
        "'Win a plushie in a claw machine",
        "'Travel to Walmart",
        "'Read line 178 of Romeo and Juliet",
        "'Slap your stomach with some lotion",
        "'Attempt a hair braid",
        "'Post a picture of your toe on instagram",
        "'Crack your knuckles",
        "'Find a Zebra", "Walk forward!!!", "Walk Backwards", "Walk to the Right!!!", "Walk to the Left",
        "Walk forward!!!", "Walk Backwards", "Walk to the Right!!!", "Walk to the Left",
        "Walk forward!!!", "Walk Backwards", "Walk to the Right!!!", "Walk to the Left",
        "Walk forward!!!", "Walk Backwards", "Walk to the Right!!!", "Walk to the Left",
        "Walk forward!!!", "Walk Backwards", "Walk to the Right!!!", "Walk to the Left",
        "Walk forward!!!", "Walk Backwards", "Walk to the Right!!!", "Walk to the Left",
        "Walk forward!!!", "Walk Backwards", "Walk to the Right!!!", "Walk to the Left",
        "Walk forward!!!", "Walk Backwards", "Walk to the Right!!!", "Walk to the Left",
        "Walk forward!!!", "Walk Backwards", "Walk to the Right!!!", "Walk to the Left",
        "Walk forward!!!", "Walk Backwards", "Walk to the Right!!!", "Walk to the Left",
        "'Become a dog",
        "'Become a Frog",
        "'Post a picture of your dog",
        "'Post a picture of a cat",
        "'Post a picture of a ship",
        "'Post a picture of your eyeball",
        "'Attempt a pushup",
        "'Attempt to stack 5 potatoes",
        "'Don't blink for 10 seconds",
        "'Don't move for 20 seconds",
        "'Watch a random anime episode",
        "'Watch season 2 episode 5 of the office",
        "'Watch season 5 episode 6 of the office",
        "'Watch season 1 episode 7 of the office",
        "'Watch season 1 episode 1 of the office",
        "'Watch season 1 episode 2 of the office",
        "'Watch season 1 episode 3 of the office",
        "'Watch season 1 episode 4 of the office",
        "'Watch season 2 episode 1 of the office",
        "'Watch season 2 episode 2 of the office",
        "'Watch season 2 episode 3 of the office",
        "'Watch season 2 episode 4 of the office",
        "'Watch season 2 episode 6 of the office",
        "'Watch season 2 episode 1 of My Hero Academia",
        "'Watch season 2 episode 2 of My Hero Academia",
        "'Watch season 2 episode 3 of My Hero Academia",
        "'Watch season 2 episode 4 of My Hero Academia",
        "'Watch season 2 episode 5 of My Hero Academia",
        "'Watch season 2 episode 6 of My Hero Academia",
        "'Watch season 2 episode 7 of My Hero Academia",
        "'Watch season 2 episode 8 of My Hero Academia",
        "'Watch season 2 episode 9 of My Hero Academia",
        "'Watch season 2 episode 10 of My Hero Academia",
        "'Travel to China",
        "'Travel to Florida",
        "'Travel to Canada",
        "'Go to the mountains",
        "'Steal something from yourself",
        "'Wash your feet",
        "'Sew a hat",
        "'Sew a scarf",
        "'Sew a plushie",
        "'Paint with Bob Ross",
        "'Draw a pineapple",
        "'Draw someone you know",
        "'Draw an alien",
        "'Draw me",
        "'Make pineapple cake",
        "'Hack an app",
        "'Attempt the force",
        "'Write some goals",
        "'Write a letter to Santa",
        "'Write a letter to a guardian",
        "'Write a letter to someone younger than you",
        "'Write a letter to someone older than you",
        "'Write a letter to your dog",
        "'Write a letter to your cat",
        "'Write a letter to your foot",
        "'Write a letter to the last person you saw",
        "'Write a poem about the last person you saw",
        "'Write a poem about the last movie you've watched",
        "'Write a poem about the last person you talked to",
        "'Write a poem about the last food you've eaten",
        "'Write a poem about the next movie you plan to watch",
        "'Write a poem about the last drink you've had",
        "'Write a poem about the last time you sipped",
        "'Write a poem about the last song you listened to",
        "'Write a poem about the last person you talked to",
        "'Write a poem about the last person you saw",
        "'Write a poem about the last movie you've watched",
        "'Write a poem about the last person you talked to"]
        if Int.random(in: 0 ..< 3) == 0{
             command = action[Int.random(in: 0 ..< (action.count))] + " a " + object[Int.random(in: 0 ..< (object.count))] + "!!!"
            label.font = UIFont(name: "Chalkboard SE", size: 30.0)
        }
        else{
            
            label.font = UIFont(name: "Chalkboard SE", size: 10.0)
            command =  moreactions[Int.random(in: 0 ..< moreactions.count)] + "!!!"
            
        }
       
        
 
            let array: NSArray = [UIImage(named: "angry1.png"),UIImage(named: "angry.png")];
            var imageView = UIImageView()
            imageView.animationImages = array as! [UIImage];
        imageView.animationDuration = 0.25;
            imageView.startAnimating()
                    imageView.frame = CGRect(x: 40, y: 170, width: 300, height: 300)
                    
            self.view.addSubview(imageView)
            imageView.isHidden = false;
            imageView.alpha = 1.0;
            // Then fades it away after 2 seconds (the cross-fade animation will take 0.5s)
        imageView.isHidden = false
        UIView.animate(withDuration: 2, delay: 0.1,animations: {
            imageView.alpha = 0.99
        }, completion: { finished in
            imageView.isHidden = true
        })

        
        
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
                                ownerId: self.userId!,
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
        label.frame.origin.y = 75
        label.frame.origin.x = self.view.frame.width - label.frame.width + 10
        label.textAlignment = .center
        label.textColor = .blue
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
                                        ownerId: self.userId!,
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


import UIKit
import ImageIO
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

extension UIImage {
    
    public class func gifImageWithData(_ data: Data) -> UIImage? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            print("image doesn't exist")
            return nil
        }
        
        return UIImage.animatedImageWithSource(source)
    }
    
    public class func gifImageWithURL(_ gifUrl:String) -> UIImage? {
        guard let bundleURL:URL? = URL(string: gifUrl)
            else {
                print("image named \"\(gifUrl)\" doesn't exist")
                return nil
        }
        guard let imageData = try? Data(contentsOf: bundleURL!) else {
            print("image named \"\(gifUrl)\" into NSData")
            return nil
        }
        
        return gifImageWithData(imageData)
    }
    
    public class func gifImageWithName(_ name: String) -> UIImage? {
        guard let bundleURL = Bundle.main
            .url(forResource: name, withExtension: "gif") else {
                print("SwiftGif: This image named \"\(name)\" does not exist")
                return nil
        }
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            print("SwiftGif: Cannot turn image named \"\(name)\" into NSData")
            return nil
        }
        
        return gifImageWithData(imageData)
    }
    
    class func delayForImageAtIndex(_ index: Int, source: CGImageSource!) -> Double {
        var delay = 0.1
        
        let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
        let gifProperties: CFDictionary = unsafeBitCast(
            CFDictionaryGetValue(cfProperties,
                Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque()),
            to: CFDictionary.self)
        
        var delayObject: AnyObject = unsafeBitCast(
            CFDictionaryGetValue(gifProperties,
                Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()),
            to: AnyObject.self)
        if delayObject.doubleValue == 0 {
            delayObject = unsafeBitCast(CFDictionaryGetValue(gifProperties,
                Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()), to: AnyObject.self)
        }
        
        delay = delayObject as! Double
        
        if delay < 0.1 {
            delay = 0.1
        }
        
        return delay
    }
    
    class func gcdForPair(_ a: Int?, _ b: Int?) -> Int {
        var a = a
        var b = b
        if b == nil || a == nil {
            if b != nil {
                return b!
            } else if a != nil {
                return a!
            } else {
                return 0
            }
        }
        
        if a < b {
            let c = a
            a = b
            b = c
        }
        
        var rest: Int
        while true {
            rest = a! % b!
            
            if rest == 0 {
                return b!
            } else {
                a = b
                b = rest
            }
        }
    }
    
    class func gcdForArray(_ array: Array<Int>) -> Int {
        if array.isEmpty {
            return 1
        }
        
        var gcd = array[0]
        
        for val in array {
            gcd = UIImage.gcdForPair(val, gcd)
        }
        
        return gcd
    }
    
    class func animatedImageWithSource(_ source: CGImageSource) -> UIImage? {
        let count = CGImageSourceGetCount(source)
        var images = [CGImage]()
        var delays = [Int]()
        
        for i in 0..<count {
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(image)
            }
            
            let delaySeconds = UIImage.delayForImageAtIndex(Int(i),
                source: source)
            delays.append(Int(delaySeconds * 1000.0)) // Seconds to ms
        }
        
        let duration: Int = {
            var sum = 0
            
            for val: Int in delays {
                sum += val
            }
            
            return sum
        }()
        
        let gcd = gcdForArray(delays)
        var frames = [UIImage]()
        
        var frame: UIImage
        var frameCount: Int
        for i in 0..<count {
            frame = UIImage(cgImage: images[Int(i)])
            frameCount = Int(delays[Int(i)] / gcd)
            
            for _ in 0..<frameCount {
                frames.append(frame)
            }
        }
        
        let animation = UIImage.animatedImage(with: frames,
            duration: Double(duration) / 1000.0)
        
        return animation
    }
}
