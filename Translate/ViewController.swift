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
    
    @IBOutlet weak var sourceLanguageLabel: UILabel!
    @IBOutlet weak var destinationLanguageLabel: UILabel!
    
    //ui indicator
    let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    //toast label for when user tries to translate empty message
    
    var pickerLanguages: [String] = ["Gaelic","French","Turkish","English"] //data for picker
    var languageDictonary : [String : String] = ["French" : "fr","Turkish" : "tr","Gaelic" : "ga","English" : "en"]
    
    //make an array of the language codes for lookups
    var languageCodes : [String] = ["fr","tr","ga","en"]
    
    var selectedLanguage = String()
    //sets up default language code as current devices language
    var languageCode = String()
    var rowOfLanguageSelection = 0  //used to access the data array at the user specified index
    
    //placeholders for uitext elements
    let textToTranslatePlaceholder = "Text to Translate....."
    let translatedTextPlaceHolder = "Translated Text....."
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpPickerView()
        setUpTextViews()
        setDefaultSourceLanguage()
        setUpLanguagePairLabels()
        print("The language code should be set to default of device \(languageCode)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //sets up default language as the default device language if it's supported , english otherwise
    func setDefaultSourceLanguage(){
        languageCode = (isLanguageSupported(language: NSLocale.current.languageCode!)) ? NSLocale.current.languageCode! + "|" : "en|"
    }
    
    //checks to see if the lanugae used is supported (used for setting up default language)
    func isLanguageSupported(language: String)->Bool{
        return languageCodes.contains(language)
    }
    
    func setUpLanguagePairLabels(){
        updateSourceLanguageLabel()
        updateDestinationLanguageLabel()
    }
    
    func updateSourceLanguageLabel(){
        let strippedSourceLanugageCode = languageCode.replacingOccurrences(of: "|", with: "")

        for(key,value) in languageDictonary{
            if(value == strippedSourceLanugageCode){
                
                //set up source language label
                let sourceStr : NSString = "Source Language: " + key as NSString
                
                let sourceLanguage: NSMutableAttributedString  = NSMutableAttributedString(string: sourceStr as String,attributes: [NSFontAttributeName: UIFont(name: "Ubuntu", size: 17.0)!])
                
                sourceLanguage.addAttribute(NSForegroundColorAttributeName, value: UIColor.cyan, range: NSRange(location: 17, length: key.characters.count))
                
                self.sourceLanguageLabel.attributedText = sourceLanguage
                break
            }
        }
    }
    
    
    func updateDestinationLanguageLabel(){
        //set up dest language label
        let destStr : NSString = "Destination Language: " + pickerLanguages[rowOfLanguageSelection] as NSString
        
        let destinationLanguage: NSMutableAttributedString  = NSMutableAttributedString(string: destStr as String,attributes: [NSFontAttributeName: UIFont(name: "Ubuntu", size: 17.0)!])
        
        destinationLanguage.addAttribute(NSForegroundColorAttributeName, value: UIColor.cyan, range: NSRange(location: 22, length: pickerLanguages[rowOfLanguageSelection].characters.count))
        self.destinationLanguageLabel.attributedText = destinationLanguage
    }
    
    //set up the text views and delegates
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
       // pickerSelectorDoneButton.isEnabled = false
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
    
    //done button pressed when picking language in the picker
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
        print("done pressed")
        setUpLanguagePairLabels()
    }
    
    //picker protocol methods
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
    
    //choose language button pressed
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
        print("done button shoud be enabled")
    }
    
    //reset the language pair to it's original state
    func reset(){
        languageCode = "en|"
        print("The language code has been reset after the translation :" + languageCode)
    }
    
    //calls to the web service api on a thread and sends back a completion when done
    func getTranslation(textToTranslate: String, completion: @escaping (String) ->Void){
        
        //create url string
        let escapedStr = textToTranslate.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        let langStr = (languageCode + languageDictonary[pickerLanguages[rowOfLanguageSelection]]!).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        
        print("In translate method and the new langStr is \(languageCode + languageDictonary[pickerLanguages[rowOfLanguageSelection]]!)")
        
        print(langStr!)
        let urlStr:String = ("https://api.mymemory.translated.net/get?q="+escapedStr!+"&langpair="+langStr!)
        
        let url = URL(string: urlStr)
        
       
        var result: String = "<Translation Error>"
        
        //set up web session with completion handler
        URLSession.shared.dataTask(with: url!, completionHandler: { data, response, error in
            
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
            completion(result)
        }).resume()

    }
    
    //calls getTranslated text to make up full translation functionality
    @IBAction func translate(_ sender: AnyObject) {
        //if text box is nil display a label telling the user
        if(translatedText.text.isEmpty){
            //display label and return from func
            return
        }
        
        //indicator needs to be displayed on main thread
        DispatchQueue.main.async {
            EZLoadingActivity.show("Translating...", disableUI: true)
        }

        //gets the translation and updates the view
        getTranslation(textToTranslate: textToTranslate.text, completion: {text in
           
            //ui needs to be updated on main thread i.e inidcator and text views
            DispatchQueue.main.async {
                //self.loadingIndicator.stopAnimating()
                if(!text.isEmpty || text == "<Translation Error>"){
                    EZLoadingActivity.hide(true, animated: true)
                    self.translatedText.text = text
                    self.translatedText.textColor = UIColor.black
                }else{
                    EZLoadingActivity.hide(false, animated: true)
                }
            }
        })
        
        //reset variables to allow next translation
        reset()
    }
    
}
