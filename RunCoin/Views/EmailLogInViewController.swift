//
//  ViewController.swift
//  RunCoin
//
//  Created by Roland Christensen on 3/7/18.
//  Copyright © 2018 Roland Christensen. All rights reserved.
//

import UIKit

extension UILabel {
    func addCharacterSpacing() {
        if let labelText = text, labelText.count > 0 {
            let attributedString = NSMutableAttributedString(string: labelText)
            attributedString.addAttribute(NSAttributedStringKey.kern, value: 4.0, range: NSRange(location: 0, length: attributedString.length - 1))
            attributedText = attributedString
        }
    }
}

class EmailLogInViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    //variables
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var birthdayTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var profileLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    @IBAction func doneButtonPressed(_ sender: UIButton) {
    }
    
    
    let myPickerData : [String] = ["Male", "Female", "Other"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //pickerview setup
        let myPickerView = UIPickerView()
        genderTextField.inputView = myPickerView
        myPickerView.delegate = self
        
        //textfield style properties
        emailTextField.layer.shadowColor = UIColor.googleGrey.cgColor
        emailTextField.layer.masksToBounds = false
        emailTextField.layer.shadowRadius = 1.0
        emailTextField.layer.shadowOpacity = 0.5
        emailTextField.layer.shadowOffset = CGSize(width: 0, height: 2)
        emailTextField.borderStyle = UITextBorderStyle.roundedRect
        emailTextField.adjustsFontSizeToFitWidth = true
        
        userNameTextField.layer.shadowColor = UIColor.googleGrey.cgColor
        userNameTextField.layer.masksToBounds = false
        userNameTextField.layer.shadowRadius = 1.0
        userNameTextField.layer.shadowOpacity = 0.5
        userNameTextField.layer.shadowOffset = CGSize(width: 0, height: 2)
        userNameTextField.borderStyle = UITextBorderStyle.roundedRect
        userNameTextField.adjustsFontSizeToFitWidth = true
        
        birthdayTextField.layer.shadowColor = UIColor.googleGrey.cgColor
        birthdayTextField.layer.masksToBounds = false
        birthdayTextField.layer.shadowRadius = 1.0
        birthdayTextField.layer.shadowOpacity = 0.5
        birthdayTextField.layer.shadowOffset = CGSize(width: 0, height: 2)
        birthdayTextField.borderStyle = UITextBorderStyle.roundedRect
        birthdayTextField.adjustsFontSizeToFitWidth = true
        
        genderTextField.layer.shadowColor = UIColor.googleGrey.cgColor
        genderTextField.layer.masksToBounds = false
        genderTextField.layer.shadowRadius = 1.0
        genderTextField.layer.shadowOpacity = 0.5
        genderTextField.layer.shadowOffset = CGSize(width: 0, height: 2)
        genderTextField.borderStyle = UITextBorderStyle.roundedRect
        
        //done button attributes
        doneButton.backgroundColor = UIColor.coral
    }
    
    //MARK: -- PickerView DataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return myPickerData[row]
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return myPickerData.count
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        genderTextField.text = myPickerData[row]
        self.view.endEditing(true)
        
    }
}


