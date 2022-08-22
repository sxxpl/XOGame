//
//  MainMenuViewController.swift
//  XO-game
//
//  Created by Артем Тихонов on 22.08.2022.
//  Copyright © 2022 plasmon. All rights reserved.
//

import UIKit

class MainMenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "vsPlayer" {
            var viewController = segue.destination as! GameViewController
            viewController.gameMode = .vsPlayer
        } else {
            var viewController = segue.destination as! GameViewController
            viewController.gameMode = .vsComputer
        }
    }
}
