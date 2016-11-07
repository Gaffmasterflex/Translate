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
    var backgroundImage = UIImageView(frame: UIScreen.main.bounds)

    //several background images (different background image may be displayed on launch depending on random number index)
    let imageExtension = "jpg"
    let backgroundImages = ["Home_Page_1","Home_Page_2","Home_Page_3","Home_Page_4","Home_Page_5","Home_Page_6"]
    
   @IBAction func onPhrasesPressed(_ sender: UIButton) {
        //pushed onto phrases controller
    }
    
    @IBAction func onTranslatorPressed(_ sender: UIButton) {
       //pushed onto view controller
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationItem.title = "Home"
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.barTintColor = phrasesButton.backgroundColor
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Ubuntu-Bold", size: 20)!,NSForegroundColorAttributeName: UIColor.white]

        backgroundImage.image = UIImage(named: Bundle.main.path(forResource: backgroundImages[Int(getRandomPicture())], ofType: imageExtension)!)
        self.view.insertSubview(backgroundImage, at: 0)
    }
    
    func getRandomPicture()->UInt32{
        return arc4random_uniform(UInt32(backgroundImages.count))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
