//
//  ViewController.swift
//  Translate
//
//  Created by Robert O'Connor on 16/10/2015.
//  Copyright © 2015 WIT. All rights reserved.
//
import UIKit

class ViewController: UIViewController , UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate	{
    
    @IBOutlet weak var textToTranslate: UITextView!
    @IBOutlet weak var translatedText: UITextView!
    @IBOutlet weak var languagePicker: UIPickerView!
    @IBOutlet weak var translateButton: UIButton!
    
    @IBOutlet weak var chooseLanguageButton: UIButton!
    @IBOutlet weak var pickerSelectorDoneButton: UIButton!
    
    var pickerLanguages: [String] = ["Gaelic","French","Turkish"] //data for picker
    var languageDictonary : [String : String] = ["French" : "fr","Turkish" : "tr","Gaelic" : "ga"]
    var selectedLanguage = String()
    var languageCode:String = "en|"
    var rowOfLanguageSelection = 0  //used to access the data array at the user specified index
    
    //placeholders for uitext elements
    let textToTranslatePlaceholder = "Text to Translate....."
    let translatedTextPlaceHolder = "Translated Text....."
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpPickerView()
        setUpTextViews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpTextViews(){
        self.textToTranslate.delegate = self
        textToTranslate.text = textToTranslatePlaceholder
        textToTranslate.textColor = UIColor.lightGray
        
        
        self.translatedText.delegate = self
        translatedText.text = translatedTextPlaceHolder
        translatedText.textColor = UIColor.lightGray
    }
    
    //when user starts editing the text view
    func textViewDidBeginEditing(_ textView: UITextView) {
        if(textView.textColor == UIColor.lightGray){
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    //when the view is done editing
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = textToTranslatePlaceholder
            textView.textColor = UIColor.lightGray
        }
    }
    
    func setUpPickerView(){
        self.languagePicker.delegate = self
        self.languagePicker.dataSource = self
        languagePicker.isHidden = true
        pickerSelectorDoneButton.isEnabled = false
        pickerSelectorDoneButton.isHidden = true
    }
    
    //dissmisses keyboard on return key pressed
    func textView(_ textView : UITextView, shouldChangeTextIn range: NSRange, replacementText text: String)->Bool{
        if(text == "\n"){
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    @IBAction func onPickerSelectorDonePressed(_ sender: UIButton) {
        //hide selector
        languagePicker.isHidden = true
        //hide button
        sender.isHidden = true
        //disable button
        sender.isEnabled = false
        //get row and make it the string
        selectedLanguage = pickerLanguages[rowOfLanguageSelection]
        
        translateButton.isEnabled = true
        translateButton.isHidden = false
        chooseLanguageButton.isHidden = false
        chooseLanguageButton.isEnabled = true
    }
    
    @nonobjc func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerLanguages.count
    }
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerLanguages[row]
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerLanguages.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        // use the row to get the selected row from the picker view
        // using the row extract the value from your datasource (array[row])
        print("Item selected is \(pickerLanguages[row])")
        rowOfLanguageSelection = row
    }
    
    
    @IBAction func onChooseLanguagePressed(_ sender: UIButton) {
        //show the picker
        languagePicker.isHidden = false
        
        //hide the other buttons and set enabled to false
        sender.isHidden = true
        sender.isEnabled = false
        self.translateButton.isHidden = true
        self.translateButton.isEnabled = false
        
        //show and enable done button for language selection
        self.pickerSelectorDoneButton.isHidden = false
        self.pickerSelectorDoneButton.isEnabled = true
    }
    
    func reset(){
        //reset query string
        languageCode = "en|"
        print("The language code has been reset after the translation :" + languageCode)
    }
    
    @IBAction func translate(_ sender: AnyObject) {
        
        //if text box is nil display a label telling the user
        
        let str = textToTranslate.text
        let escapedStr = str?.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        let langStr = (languageCode + languageDictonary[pickerLanguages[rowOfLanguageSelection]]!).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        
        print("In translate method and the new langStr is \(languageCode + languageDictonary[pickerLanguages[rowOfLanguageSelection]]!)")
        
        print(langStr!)
        let urlStr:String = ("https://api.mymemory.translated.net/get?q="+escapedStr!+"&langpair="+langStr!)
        
        let url = URL(string: urlStr)
        
        //let request = URLRequest(url: url!)// Creating Http Request
        
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
        indicator.center = view.center
        view.addSubview(indicator)
        
        var result: String = "<Translation Error>"
        result = URLSession.shared.dataTask(with: url!){ (data, response, error) in
            indicator.startAnimating()

            if let httpResponse = response as? HTTPURLResponse{
                if (httpResponse.statusCode == 200){
                    
                    print("Successful connection")
                    let jsonDict: NSDictionary!=(try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                            
                    if(jsonDict.value(forKey: "responseStatus") as! NSNumber == 200){
                        print("json had a successful connection")
                        let responseData: NSDictionary = jsonDict.object(forKey: "responseData") as! NSDictionary
                        result = responseData.object(forKey: "translatedText") as! String
                        print("result from json call is \(result)")
                        
                    }
                }
            }
        }.resume()
        print("past json section")
        indicator.stopAnimating()
       
        self.translatedText.textColor = UIColor.black
        self.reset()
    }
    
    func updateTranslatedTextView
}
