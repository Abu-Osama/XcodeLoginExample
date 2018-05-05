
//  ProfileViewController.swift
//  XcodeLoginExample
//  Created by deepak on 01/06/17.
//  Copyright © 2017 deepak. All rights reserved.


import UIKit

class ProfileViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate 
 {
    
    @IBOutlet weak var textBox: UITextField!
    @IBOutlet weak var dropDown: UIPickerView!

    var list = ["Marriage Hall", "PartyHall", "meetinghall","ExhibitionHall","BanquetHall"]
    
    @IBAction func addhall(_ sender: Any) {
        
        
        
    }
    
    
    @IBAction func addservices(_ sender: Any) {
        
        let defaultValues = UserDefaults.standard
        let cod = defaultValues.string(forKey: "cod")
        
        let emailname = defaultValues.string(forKey: "email")
        
        //print("cod " + cod! as Any)
        //print("hello" + name! as Any)
        
        
        let addservices =  UIStoryboard(name: "Main", bundle: nil)
        
        let addser = addservices.instantiateViewController(withIdentifier: "AddServices") as! AddServices
        
        addser.getcod = cod!
        addser.getemail = emailname!
        
        
        
        self.navigationController?.pushViewController(addser, animated: true)
        
    }
    //label again don't copy instead connect
    @IBOutlet weak var labelUserName: UILabel!
    
    @IBAction func buttonLogout(_ sender: UIButton) {
        
        
        //removing values from default
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        UserDefaults.standard.synchronize()
        
        //switching to login screen
        let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        self.navigationController?.pushViewController(loginViewController, animated: true)
        self.dismiss(animated: false, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //hiding back button
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
        
        //getting user data from defaults
        let defaultValues = UserDefaults.standard
        //let cod = defaultValues.string(forKey: "cod")
        
        
        //print(cod)
        if let name = defaultValues.string(forKey: "email"){
            //setting the name to label 
            //labelUserName.text = name
           print(name)
        }else{
            //send back to login view controller
        }
        
        // let errorCode = name["email"] as? String;
        //self.defaultValues.set(errorCode, forKey:"email")
        //self.defaultValues.set(cod, forKey:"cod")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
        
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        
        return list.count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        self.view.endEditing(true)
        return list[row]
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        self.textBox.text = self.list[row]
        self.dropDown.isHidden = true
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == self.textBox {
            self.dropDown.isHidden = false
            //if you dont want the users to se the keyboard type:
            
            textField.endEditing(true)
        }
        
    }


}
