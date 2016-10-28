//
//  ViewController.swift
//  Translate
//
//  Created by Robert O'Connor on 16/10/2015.
//  Copyright © 2015 WIT. All rights reserved.
//

import UIKit

class ViewController: UIViewController , UIPickerViewDelegate, UIPickerViewDataSource{
    
    @IBOutlet weak var textToTranslate: UITextView!
    @IBOutlet weak var translatedText: UITextView!
    @IBOutlet weak var languagePicker: UIPickerView!
    
    var pickerLanugages: [String] = [String]()
    var languageDictonary : [String : String] = ["French" : "fr","Turkish" : "tr","Gaelic" : "ga"]
    var selectedLanguage = String()
    var languageCode = "en|"
    var rowOfLanguageSelection = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpPickerView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpPickerView(){
        self.languagePicker.delegate = self
        self.languagePicker.dataSource = self
        languagePicker.isHidden = true
        pickerLanugages = ["Gaelic","Turkish","French"]
    }
    
    @nonobjc func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerLanugages.count
    }

    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerLanugages[row]
    }
    
    // The number of rows of data
     func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerLanugages.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        // use the row to get the selected row from the picker view
        // using the row extract the value from your datasource (array[row])
        print("Item selected is \(pickerLanugages[row])")
        selectedLanguage = pickerLanugages[row]
        rowOfLanguageSelection = row
    }
   
    
    @IBAction func onChooseLanguagePressed(_ sender: UIButton) {
        languagePicker.isHidden = false
    }
    
    @IBAction func translate(_ sender: AnyObject) {
        let str = textToTranslate.text
        let escapedStr = str?.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        
        let langStr = (languageCode+=languageDictonary[pickerLanugages[rowOfLanguageSelection]]).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        
        print("langStr")
        let urlStr:String = ("https://api.mymemory.translated.net/get?q="+escapedStr!+"&langpair="+langStr!)
        
        let url = URL(string: urlStr)
        
        let request = URLRequest(url: url!)// Creating Http Request
        
        //var data = NSMutableData()var data = NSMutableData()
        
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        indicator.center = view.center
        view.addSubview(indicator)
        indicator.startAnimating()
        
        var result = "<Translation Error>"
        
        NSURLConnection.sendAsynchronousRequest(request, queue: OperationQueue.main) { response, data, error in
            
            indicator.stopAnimating()
            
            if let httpResponse = response as? HTTPURLResponse {
                if(httpResponse.statusCode == 200){
                    
                    let jsonDict: NSDictionary!=(try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                    
                    if(jsonDict.value(forKey: "responseStatus") as! NSNumber == 200){
                        let responseData: NSDictionary = jsonDict.object(forKey: "responseData") as! NSDictionary
                        
                        result = responseData.object(forKey: "translatedText") as! String
                    }
                }
                
                self.translatedText.text = result
            }
        }
        
    }
}

