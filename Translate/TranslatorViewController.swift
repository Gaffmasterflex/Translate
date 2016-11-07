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
    var backgroundImage = UIImageView(frame: UIScreen.main.bounds)

    let backgroundImages = ["English" : "England_BG", "French" : "France_BG", "Gaelic" : "Ireland_BG", "Turkish" : "Turkey_BG"]
    //ui indicator
    let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    //toast label for when user tries to translate empty message
    
    //source/destination arrays
    var pickerLanguages: [[String]] = [["English","French","Gaelic","Turkish"],["English","French","Gaelic","Turkish"]] //data for picker
    
    var languageDictonary : [String : String] = ["French" : "fr","Turkish" : "tr","Gaelic" : "ga","English" : "en"]
    
    //make an array of the language codes for lookups
    var languageCodes : [String] = ["fr","tr","ga","en"]
    
    var selectedLanguage = String()
    //sets up default language code as current devices language
    var languageCode = String()
    var rowOfSourceLanguageSelection = 0  //used to access the data array at the user specified index
    var rowOfDestLanguageSelection = 0
    //index of selected language
    var indexOfSourceLanguage = 0 //start as english
    var indexOfDestLanguage = 3
    //placeholders for uitext elements
    let textToTranslatePlaceholder = "Text to Translate....."
    let translatedTextPlaceHolder = "Translated Text....."
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "Translator"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpPickerView()
        setUpTextViews()
        setDefaultSourceLanguage()
        setUpLanguagePairLabels()
        print("The language code should be set to default of device \(languageCode)")
        languageCode += languageDictonary[pickerLanguages[rowOfDestLanguageSelection][indexOfDestLanguage]]!
        print("View loaded and language code is : \(languageCode)")
        setBackgroundImage()
    }
    
    func setBackgroundImage(){
        backgroundImage.image = UIImage(named: Bundle.main.path(forResource: backgroundImages[pickerLanguages[rowOfDestLanguageSelection][indexOfDestLanguage]], ofType: "jpg")!)
        self.view.insertSubview(backgroundImage, at: 0)
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
        setUpDefaultSourceLanguageLabel()
        updateDestinationLanguageLabel(language: pickerLanguages[rowOfDestLanguageSelection][indexOfDestLanguage])
    }
    
    //checks default language of device against dictionary and updates view accordingly
    func setUpDefaultSourceLanguageLabel(){
        let strippedSourceLanugageCode = languageCode.replacingOccurrences(of: "|", with: "")
        
        for(key,value) in languageDictonary{
            if(value == strippedSourceLanugageCode){
                
                //set up source language label
                let sourceStr : NSString = "From " + key as NSString
                
            
                let range = sourceStr.replacingOccurrences(of: key, with: "").characters.count
                
                let sourceLanguage: NSMutableAttributedString  = NSMutableAttributedString(string: sourceStr as String,attributes: [NSFontAttributeName: UIFont(name: "Ubuntu-Bold", size: 17.0)!])
                
                sourceLanguage.addAttribute(NSForegroundColorAttributeName, value: pickerSelectorDoneButton.backgroundColor! as UIColor, range: NSRange(location: range, length: key.characters.count))
                
                self.sourceLanguageLabel.attributedText = sourceLanguage
                break
            }
        }

    }
    
    //updates source language when a language is picked
    func updateSourceLanguageLabel(language: String){
        let sourceStr : NSString = "From " + language as NSString
        let range = sourceStr.replacingOccurrences(of: language, with: "").characters.count
        let sourceLanguage: NSMutableAttributedString  = NSMutableAttributedString(string: sourceStr as String,attributes: [NSFontAttributeName: UIFont(name: "Ubuntu-Bold", size: 17.0)!])
        
        sourceLanguage.addAttribute(NSForegroundColorAttributeName, value: pickerSelectorDoneButton.backgroundColor! as UIColor, range: NSRange(location: range, length: pickerLanguages[rowOfSourceLanguageSelection][indexOfSourceLanguage].characters.count))
        self.sourceLanguageLabel.attributedText = sourceLanguage
    }
    
    //updates destination language when a new language is picked
    func updateDestinationLanguageLabel(language: String){
        //set up dest language label
        let destStr : NSString = "To " + language as NSString
        let range = destStr.replacingOccurrences(of: language, with: "").characters.count
        let destinationLanguage: NSMutableAttributedString  = NSMutableAttributedString(string: destStr as String,attributes: [NSFontAttributeName: UIFont(name: "Ubuntu-Bold", size: 17.0)!])
        
        destinationLanguage.addAttribute(NSForegroundColorAttributeName, value: pickerSelectorDoneButton.backgroundColor! as UIColor, range: NSRange(location: range, length: pickerLanguages[rowOfDestLanguageSelection][indexOfDestLanguage].characters.count))
        self.destinationLanguageLabel.attributedText = destinationLanguage
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        let strTitle = pickerLanguages[component][row]
        let attString = NSAttributedString(string: strTitle, attributes: [NSFontAttributeName: UIFont(name: "Ubuntu-Bold", size: 17.0)!,NSForegroundColorAttributeName : UIColor.white])
        
        return attString
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
    
    //sets up the pickerview
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
    
    //done button pressed when picking language in the picker
    @IBAction func onPickerSelectorDonePressed(_ sender: UIButton) {
        //hide selector
        languagePicker.isHidden = true
        //hide button
        sender.isHidden = true
        //disable button
        sender.isEnabled = false
        
        translateButton.isEnabled = true
        translateButton.isHidden = false
        chooseLanguageButton.isHidden = false
        chooseLanguageButton.isEnabled = true
        print("done pressed")
        
        //update labels
        updateSourceLanguageLabel(language: pickerLanguages[rowOfSourceLanguageSelection][indexOfSourceLanguage])
        updateDestinationLanguageLabel(language: pickerLanguages[rowOfDestLanguageSelection][indexOfDestLanguage])
        
        //update backgroundImage
        setBackgroundImage()
    }
    
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        print("number of componets was called ")
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerLanguages[component][row]
    }
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) ->Int{
        return pickerLanguages[component].count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        // use the row to get the selected row from the picker view
        // using the row extract the value from your datasource (array[row])
        print("Item selected is \(pickerLanguages[component][row])")
   
        print("component is: \(component)")
        if(component == 0){
            rowOfSourceLanguageSelection = component
            indexOfSourceLanguage = row
            print("Source lang selected: \(pickerLanguages[rowOfSourceLanguageSelection][indexOfSourceLanguage])")
        }else{
            rowOfDestLanguageSelection = component
            indexOfDestLanguage = row
            print("Destination lang selected: \(pickerLanguages[rowOfDestLanguageSelection][indexOfDestLanguage])")
        }
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
    
    //returns the langPair codes
    func getLanguageCodes() -> String{
        return languageDictonary[pickerLanguages[rowOfSourceLanguageSelection][indexOfSourceLanguage]]! + "|" + languageDictonary[pickerLanguages[rowOfDestLanguageSelection][indexOfDestLanguage]]!
    }
    
    //calls to the web service api on a thread and sends back a completion when done
    func getTranslation(textToTranslate: String, completion: @escaping (String) ->Void){
        
        //create url string
        let escapedStr = textToTranslate.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        let langStr = (getLanguageCodes()).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        
        print("In translate method and the new langStr is \(getLanguageCodes())")
        
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
    }
    
}
