
import UIKit

class ViewController: UIViewController,UITextFieldDelegate {
    //MARK: properties
    @IBOutlet var txtUsername : UITextField!
    @IBOutlet var txtPassword : UITextField!
    @IBOutlet weak var txtViewResult: UITextView!
    
    //MARK: viewCycle delegate
    override func viewDidLoad() {
        super.viewDidLoad()
        txtViewResult.contentInset = UIEdgeInsetsMake(10, 0, 0, 0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: IOS Touch Functions
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        super.touchesBegan(touches, withEvent: event)
        self.view.endEditing(true)
    }
    
    //MARK: TextField Delegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: Button Action Transaction methods
    @IBAction func save(sender : UIButton) {
        var recordToSave = ["username" : ""+txtUsername.text]

        if isRecordExistInEntity("Users", dataPairsToCheck: recordToSave) == 0 {
            recordToSave.updateValue(txtPassword.text, forKey: "password")
            var record = insertInEntity("Users", dataPairsTosave: recordToSave)
            println("Object saved \(record)")
            txtViewResult.text = NSString(format: "%@",record!) as String ;
        }else{
            var alertView: UIAlertView = UIAlertView(title: "Repeat record", message: "Try Uniqe entry", delegate: nil, cancelButtonTitle: "Ok")
            alertView.show()
        }
    }
    
    @IBAction func load(sender : UIButton) {
        var results = fetchRecordFromEntity("Users", withPredicate: NSPredicate(format: "username = %@", "" + txtUsername.text)) //
        if results.count > 0 {
            var result = results[0]
            txtUsername.text = result.valueForKey("username") as! String
            txtPassword.text = result.valueForKey("password") as! String
        }else{
            
        }
        txtViewResult.text = NSString(format: "%@",results) as String ;
    }
    
    @IBAction func fetchAllProperty(sender: UIButton) {
        var results : NSArray = fetchAllRecordsFromEntity("Users")
        println("\(results)")
        txtViewResult.text = NSString(format: "%@",results) as String ;
    }
    
    @IBAction func deleteAllAction(sender: UIButton) {
        deleteAllRecordsFromEntity("Users")
        txtViewResult.text = "" ;
        txtUsername.text = ""
        txtPassword.text = ""
    }
    
    @IBAction func updateInfo(sender: UIButton) {
        let records :NSSet =  updateRecordsInEntity("Users", dataPairsToUpdate: ["username" : ""+txtUsername.text,  "password" : ""+txtPassword.text], withPredicate:  ["username" : ""+txtUsername.text])
        
        print("updated :")
        println(NSString(format: "%@",records))
    }
    
    @IBAction func deleteAction(sender: UIButton) {
        var recordToDelete = ["username" : ""+txtUsername.text,  "password" : ""+txtPassword.text]
        if isRecordExistInEntity("Users", dataPairsToCheck: recordToDelete) != 0 {
            deleteFromEnity("Users", withPredicate:recordToDelete)
            print("Deleted :")
            txtUsername.text = ""
            txtPassword.text = ""
            txtViewResult.text = "" ;
        }else{
            var alertView: UIAlertView = UIAlertView(title: "Record does not exist", message: "Try again", delegate: nil, cancelButtonTitle: "Ok")
            alertView.show()
        }
    }
}

