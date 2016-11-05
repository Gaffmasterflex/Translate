//
//  PhraseViewController.swift
//  Translate
//
//  Created by Dean Gaffney on 05/11/2016.
//  Copyright © 2016 WIT. All rights reserved.
//

import UIKit

class PhraseViewController: UIViewController {
    var backgroundImage = UIImageView(frame: UIScreen.main.bounds)

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationItem.title = "Basic Phrases"
        backgroundImage.image = UIImage(named: Bundle.main.path(forResource: "PhraseButtonsDarker_BG", ofType: "jpg")!)
        self.view.insertSubview(backgroundImage, at: 0)
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
