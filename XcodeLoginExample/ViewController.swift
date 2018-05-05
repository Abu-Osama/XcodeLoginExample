//
//  ViewController.swift
//  XcodeLoginExample
//  Created by deepak on 20/02/18.
//  Copyright © 2017 deepak. All rights reserved.

import UIKit
import Alamofire

class ViewController: UIViewController,UITextFieldDelegate {

    //The login script url make sure to write the ip instead of localhost
    //you can get the ip using ifconfig command in terminal
    
     let URL_USER_LOGIN="https://www.makemyhall.com/m/operator/loginnew.php";
    
    //the defaultvalues to store user data
    let defaultValues = UserDefaults.standard
    
    @IBOutlet weak var labelUserName: UILabel!
    
    @IBOutlet weak var textFieldUserName: UITextField!
    
    //the connected views
    @IBOutlet weak var textFieldPassword: UITextField!
    
    //don't copy instead connect the views using assistant editor
  //  @IBOutlet weak var labelMessage: UILabel!
   // @IBOutlet weak var textFieldUserName: UITextField!
   // @IBOutlet weak var textFieldPassword: UITextField!
    
    
    @IBAction func buttonLogin(_ sender: UIButton) {
    
        if CheckInternet.isConnectedToNetwork() == true {
            print("Connected to the internet")
            //  Do something
            
            if(!textFieldUserName.text!.isEmpty  && !textFieldPassword.text!.isEmpty)
            {
                print(" items")
            
        let parameters: Parameters=["email_id":textFieldUserName.text!,
                            "password":textFieldPassword.text!]
        //making a post request
        Alamofire.request(URL_USER_LOGIN, method: .post, parameters: parameters).responseJSON
            {
                response in
                //printing response
                print(response)
                
                //getting the json value from the server
                if let result = response.result.value {
                    let jsonData = result as! NSDictionary
                    
                    //if there is no error
                    if(!(jsonData.value(forKey: "error") as! Bool)){
                        print(jsonData)
                       // let aObject = jsonData[index] as! [String : AnyObject]
                        
                        let errorCode = jsonData["email"] as? String;
                        let cod = jsonData["cod"] as? String;
                        
                        self.defaultValues.set(errorCode, forKey:"email")
                         self.defaultValues.set(cod, forKey:"cod")
                        
                 
                        
                        //switching the screen
                        let profileViewController = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewcontroller") as! ProfileViewController
                        self.navigationController?.pushViewController(profileViewController, animated: true)
                        
                        self.dismiss(animated: false, completion: nil)
                    }
                    else{
                    
                        self.labelUserName.text = "Invalid username or password"
                         print("error")
                    }
                }
        }
            }
            else{
                print("fill the data")
                 self.showToast(message: "please fill the data")
                
            }
        }
        
        else {
            print("No internet connection")
            self.showToast(message: "please check internet")
            //  Do something
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textFieldUserName.delegate = self
        textFieldPassword.delegate=self
        
        //
         NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange), name: .UIKeyboardWillChangeFrame, object: nil)
        
        
        //hiding the navigation button
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton

        // Do any additional setup after loading the view, typically from a nib.
        
        //if user is already logged in s[0]    (key: String, value: Any)    witching to profile screen
        if defaultValues.string(forKey: "email") != nil{
            let profileViewController = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewcontroller") as! ProfileViewController
            self.navigationController?.pushViewController(profileViewController, animated: true)
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //for return key function
    
    func textFieldShouldReturn(_ textField : UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        textFieldUserName.resignFirstResponder()
    }
    
    @objc func keyboardWillChange(notification: NSNotification) {
        
        let duration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! Double
        let curve = notification.userInfo![UIKeyboardAnimationCurveUserInfoKey] as! UInt
        let curFrame = (notification.userInfo![UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let targetFrame = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let deltaY = targetFrame.origin.y - curFrame.origin.y
        
        UIView.animateKeyframes(withDuration: duration, delay: 1.0, options: UIViewKeyframeAnimationOptions(rawValue: curve), animations: {
            self.textFieldUserName.frame.origin.y+=deltaY
            
        },completion: nil)
    }
    
    
   //function for toast
    func showToast(message : String) {
        
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-550, width: 150, height: 40))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }


}

