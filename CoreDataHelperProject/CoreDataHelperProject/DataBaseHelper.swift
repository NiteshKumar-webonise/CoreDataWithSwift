
import Foundation
import CoreData
import UIKit

var appDel: AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
var context: NSManagedObjectContext = appDel.managedObjectContext!

//MARK: print only in debug mode
func printlnForDebugMode<T>(object: T){
    #if DEBUG
        println(object)
    #endif
}

func insertInEntity(entity : String, #dataPairsTosave: Dictionary<String,AnyObject>!) ->NSManagedObject?{
    
    var newUser : NSManagedObject? = NSEntityDescription.insertNewObjectForEntityForName(entity, inManagedObjectContext: context) as? NSManagedObject
    for (field, data) in dataPairsTosave {
        newUser!.setValue(data, forKey:field)
    }
    contextSave()
    return newUser!
}

func fetchRecordFromEntity(entity : String, withPredicate predicate: NSPredicate) ->[NSManagedObject]{
    var error : NSError?
    var request = NSFetchRequest(entityName: entity)
    request.returnsObjectsAsFaults = false
    request.predicate = predicate
    var results = context.executeFetchRequest(request, error: &error)! as! [NSManagedObject]
    if results.count > 0 {
        return results
    }else{
        printlnForDebugMode("something went wrong \(error)")
        return []
    }
}

func fetchAllRecordsFromEntity(entity : String) ->[NSManagedObject]{
    var error : NSError?
    var request = NSFetchRequest(entityName: entity)
    request.returnsObjectsAsFaults = false
    //request.includesPropertyValues = false
    var results = context.executeFetchRequest(request, error: &error)! as! [NSManagedObject]
    if results.count > 0 {
        return results
    }else{
        printlnForDebugMode("something went wrong \(error)")
        return []
    }
}

func deleteAllRecordsFromEntity(entity : String){
    var error : NSError?
    var request = NSFetchRequest(entityName: entity)
    request.returnsObjectsAsFaults = false
    request.includesPropertyValues = false
    var results : NSArray = context.executeFetchRequest(request, error: &error)!
    for result in results{
        context.deleteObject(result as! NSManagedObject)
    }
    contextSave()
}

func deleteFromEnity(entity : String, #withPredicate: Dictionary<String,AnyObject>!){
    var error : NSError?
    var request = NSFetchRequest(entityName: entity)
    request.returnsObjectsAsFaults = false
    request.includesPropertyValues = false
    var formatString :String?
    var i = 0
    for(key, value) in withPredicate {
        if i>0 {
            formatString = formatString! + (NSString(format: " AND %@ = \"%@\"",key, (value as! String)) as String) //" And" + key + "=" + (value as String)
        }else{
            printlnForDebugMode(key)
            printlnForDebugMode(value)
            formatString = NSString(format: "%@ = \"%@\"",key,(value as! String)) as String  //key + "=" + (value as String)
        }
        i++
    }
    printlnForDebugMode(NSPredicate(format: formatString!, argumentArray: nil))
    request.predicate = NSPredicate(format: formatString!, argumentArray: nil)
    
    var results : NSArray = context.executeFetchRequest(request, error: &error)!
    var deletedResult: [NSManagedObject] = [];
    for result in results {
        for (field, data) in withPredicate {
            var record : NSManagedObject? = result as? NSManagedObject
            context.deleteObject(record!)
            if contextSave() == nil {
                deletedResult.append(record!)
            }
        }
        
    }
}

func updateRecordsInEntity(entity : String, #dataPairsToUpdate: Dictionary<String,AnyObject>!, #withPredicate: Dictionary<String,AnyObject>!)->NSSet!{
    var error : NSError?
    var request = NSFetchRequest(entityName: entity)
    request.returnsObjectsAsFaults = false
    request.includesPropertyValues = false
    var formatString :String?
    var i = 0
    for(key, value) in withPredicate {
        printlnForDebugMode("value\(value) \(dataPairsToUpdate)")
        if i>0 {
            formatString = formatString! + (NSString(format: " AND %@ = \"%@\"",key, (value as! String)) as String) //" And" + \(key) + "=" + \(value as String)
        }else{
            printlnForDebugMode(key)
            printlnForDebugMode(value)
            formatString = NSString(format: "%@ = \"%@\"",key,((value as! String) as String)) as String  //key + "=" + (value as String)
        }
        i++
    }
    printlnForDebugMode(NSPredicate(format: formatString!, argumentArray: nil))
    request.predicate = NSPredicate(format: formatString!, argumentArray: nil)
    
    var results : NSArray = context.executeFetchRequest(request, error: &error)!
    var updatedResult: [NSManagedObject] = [];
    for result in results {
        for (field, data) in dataPairsToUpdate {
            var record : NSManagedObject? = result as? NSManagedObject
            printlnForDebugMode("data: \(data) field: \(field)")
            record?.setValue(data, forKey: field)
            if contextSave() == nil {
                updatedResult.append(record!)
            }
            
        }
        
    }
    return context.updatedObjects
}

func isRecordExistInEntity(entity : String, #dataPairsToCheck: Dictionary<String,AnyObject>!) ->Int{
    var error : NSError?
    var request = NSFetchRequest(entityName: entity)
    request.returnsObjectsAsFaults = false
    request.includesPropertyValues = false
    var formatString :String?
    var i = 0
    for(key, value) in dataPairsToCheck {
        if i>0 {
            formatString = formatString! + (NSString(format: " AND %@ = \"%@\"",key, (value as! String)) as String) //" And" + key + "=" + (value as String)
        }else{
            printlnForDebugMode(key)
            printlnForDebugMode(value)
            formatString = NSString(format: "%@ = \"%@\"",key,(value as! String)) as String  //key + "=" + (value as String)
        }
        i++
    }
    printlnForDebugMode(NSPredicate(format: formatString!, argumentArray: nil))
    request.predicate = NSPredicate(format: formatString!, argumentArray: nil)
    
    var count = context.countForFetchRequest(request, error: &error)
    return count
}

func contextSave()->NSError?{
    var error : NSError?
    if context.save(&error) {
        printlnForDebugMode("transaction is successful")
        
    }else{
        printlnForDebugMode("something went wrong with error \(error)")
        return error
    }
    return error
}

func contextExecuteFetchRequest(){
    var error : NSError?
    
}