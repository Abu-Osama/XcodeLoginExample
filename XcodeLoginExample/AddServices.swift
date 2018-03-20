
//  AddServices.swift
//  XcodeLoginExample

//  Created by Deepak mahadev on 20/03/18.
//  Copyright © 2018 deepak. All rights reserved.
//

import Foundation
import Alamofire
import UIKit

class AddServices :UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,
    UITextFieldDelegate,UIPickerViewDelegate, UIPickerViewDataSource{
    
    
    @IBOutlet weak var addimageview: UIImageView!
    
    @IBOutlet weak var hallcategory: UITextField!
    let list=["MarriageHall","PartyHall","MeetingHall","conferenceHall","ExhibitionHall","EventHall"]
    
    
    let URL_hall_details = "http://www.makemyhall.com/m/operator/op_add_hall.php"
    
    //@IBOutlet weak var hallcategory: UIView!
    
    @IBOutlet weak var dropDown: UIPickerView!
    
    @IBOutlet weak var hallname: UITextField!
    @IBOutlet weak var hallmanagername: UITextField!
    @IBOutlet weak var hallphone: UITextField!
    @IBOutlet weak var emailid: UITextField!
    @IBOutlet weak var hallprice: UITextField!
    @IBOutlet weak var enterhalladd: UITextField!
    @IBOutlet weak var halldiscription: UITextField!
    @IBOutlet weak var halllocation: UITextField!
    @IBOutlet weak var accountname: UITextField!
    @IBOutlet weak var accountnumber: UITextField!
    @IBOutlet weak var ifsccode: UITextField!
    @IBOutlet weak var bankname: UITextField!
    @IBOutlet weak var cod: UITextField!
    @IBOutlet weak var optid: UITextField!
    
    
    
    //    @IBOutlet weak var hallname: UITextField!
//    @IBOutlet weak var hallmanagername: UITextField!
//    @IBOutlet weak var hallphone: UITextField!
//    @IBOutlet weak var emailid: UITextField!
//    @IBOutlet weak var hallprice: UITextField!
//    @IBOutlet weak var enterhalladd: UITextField!
//    @IBOutlet weak var halldiscription: UITextField!
//    @IBOutlet weak var halllocation: UITextField!
//    @IBOutlet weak var accountname: UITextField!
//    @IBOutlet weak var accountnumber: UITextField!
//    @IBOutlet weak var ifsccode: UITextField!
//    @IBOutlet weak var bankname: UITextField!
//    @IBOutlet weak var cod: UITextField!
//
//    @IBOutlet weak var optid: UITextField!
    
    
    
    
    //choose image from gallery
    @IBAction func uploadbtn(_ sender: Any) {
        
        
        self.showToast(message: "Data Save.")
        
        
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType=UIImagePickerControllerSourceType.photoLibrary
        image.allowsEditing=false
        
        self.present(image ,animated: true)
        {
            
            
        }
    
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        
        if let image=info[UIImagePickerControllerOriginalImage] as?UIImage
            
        {
            addimageview.image=image
            
            print(addimageview)
            
            
        }
            
        else{
            //error
            
            
            
        }
        self.dismiss(animated: true, completion: nil)
        
    }
    
    //upload image from server
    @IBAction func uploadButtonTapped(_ sender: Any) {
        
        
         uploadImage()
    
        
    }
    
    
    func uploadImage() {
        let image = self.addimageview.image!
        //let image = UIImage.init(named: "myImage")
        
        //let filename = image.firstObject?.filename ?? ""
        
        //        if let imageURL = info[UIImagePickerControllerReferenceURL] as? NSURL {
        //            let result = PHAsset.fetchAssetsWithALAssetURLs([addimageview], options: nil)
        //            let filename = result.firstObject?.filename ?? ""
        //            print(filename)
        //        }
        
        
        
        
        let imgData = UIImageJPEGRepresentation(image, 0.1)!
        
        print(imgData)
        
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(imgData, withName: "user", fileName: "swift_file.jpeg",mimeType: "image/jpeg")
        }, to:"http://www.aatiri.com/image/imageload.php")
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (Progress) in
                    print("Upload Progress: \(Progress.fractionCompleted)")
                })
                
                upload.responseJSON {
                    response in
                    //self.delegate?.showSuccessAlert()
                    // print(response.request)  // original URL request
                    // print(response.response) // URL response
                    // print(response.data)     // server data
                    //print(response.result)   // result of response serialization
                    //                        self.showSuccesAlert()
                    //self.removeImage("frame", fileExtension: "txt")
                    if let JSON = response.result.value
                    {
                        print("JSON: \(JSON)")
                        //self.view.makeToast(message: "Simple Toast")
                        self.showToast(message: "successful done")
                        
                    }
                }
                
            case .failure(let encodingError):
                //self.delegate?.showFailAlert()
                print(encodingError)
            }
            
        }
        
    }
    
    
    
    
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //hallname.delegate = self
        // hallmanagername.delegate=self
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //dropdown
    
    
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
        
        self.hallcategory.text = self.list[row]
        self.dropDown.isHidden = true
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == self.hallcategory {
            self.dropDown.isHidden = false
            //if you dont want the users to se the keyboard type:
            
            textField.endEditing(true)
        }
        
    }
    
    
    //toast function
    func showToast(message : String) {
        
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
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
