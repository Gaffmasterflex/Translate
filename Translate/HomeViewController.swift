//
//  HomeViewController.swift
//  Translate
//
//  Created by Dean Gaffney on 04/11/2016.
//  Copyright © 2016 WIT. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var phrasesButton: UIButton!
    @IBOutlet weak var translatorButton: UIButton!
    let imageExtension = "jpg"
    let backgroundImages = ["Home_Page_1","Home_Page_2","Home_Page_3","Home_Page_4","Home_Page_5","Home_Page_6"]
    
   @IBAction func onPhrasesPressed(_ sender: UIButton) {
        //gpushed onto phrases controller
    }
    
    @IBAction func onTranslatorPressed(_ sender: UIButton) {
       //pushed onto view controller
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationItem.title = "Home"
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: Bundle.main.path(forResource: backgroundImages[Int(getRandomPicture())], ofType: imageExtension)!)
        self.view.insertSubview(backgroundImage, at: 0)
    }
    
    func getRandomPicture()->UInt32{
        return arc4random_uniform(UInt32(backgroundImages.count))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        for font in UIFont.familyNames{
            for familyName in UIFont.fontNames(forFamilyName: font){
                print("Font Name is : \(familyName)")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
