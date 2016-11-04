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
    
   @IBAction func onPhrasesPressed(_ sender: UIButton) {
        //gpushed onto phrases controller
    }
    
    @IBAction func onTranslatorPressed(_ sender: UIButton) {
       //pushed onto view controller
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
