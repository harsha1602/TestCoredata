//
//  ViewController.swift
//  TestCoredata
//
//  Created by Girish on 02/03/18.
//  Copyright © 2018 Girish. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    static let projectName = "IrisRefClient"
    static let dataModelName = "TestCoredata"
    
    // Applications default directory address
    // The directory the application uses to store the Core Data store file.
    // This code uses a directory named “com.example.myProjectName” in the application’s documents Application Support directory.
    lazy var applicationDocumentsDirectory: NSURL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1] as NSURL
    }()
    
    @IBAction func Submit(_ sender: Any) {
                mainMOC.perform {
                    let nsentit = NSEntityDescription.entity(forEntityName: "Users", in: self.mainMOC)
                    let record = NSManagedObject(entity: nsentit!, insertInto: self.mainMOC)
        
                    record.setValue("test123", forKey: "name")
                    record.setValue("pass123", forKey: "password")
                }        
        
                do {
                    try mainMOC.save()
        
                } catch {
                    fatalError("Failure to save private context: \(error)")
                }
        
        
          retrieveval()
    }
    
    // The managed object model for the application. This property is not optional.
    // It is a fatal error for the application not to be able to find and load its model.
    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: ViewController.dataModelName, withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    // The persistent store coordinator for the application. This implementation creates and return a coordinator,
    // having added the store for the application to it.
    // This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("\(ViewController.projectName).sqlite")
        do {
            // If your looking for any kind of migration then here is the time to pass it to the options
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch let  error as NSError {
           // Log.e("Ops there was an error \(error.localizedDescription)")
            abort()
        }
        return coordinator
    }()
    
    lazy var mainMOC: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
        // This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.persistentStoreCoordinator = coordinator
        return context
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
    }
    
    func retrieveval()
    {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
       
        request.returnsObjectsAsFaults = false
        
        do {
            let result = try mainMOC.fetch(request)
            for data in result as! [NSManagedObject] {
                print(data.value(forKey: "name") as! String)
            }
            
        } catch {
            
            print("Failed")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

