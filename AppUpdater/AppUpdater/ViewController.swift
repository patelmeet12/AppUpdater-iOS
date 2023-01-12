//
//  ViewController.swift
//  AppUpdater
//
//  Created by Apple iQlance on 15/09/2022.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK:-  Outlets and Variable Declarations
    
    //MARK:- 
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK:-  Buttons Clicked Action
    @IBAction func btnUpdateNowClicked(_ sender: UIButton) {
        
        let whatsNewVC = storyboard?.instantiateViewController(withIdentifier: "WhatsNewVC") as! WhatsNewVC
        //self.navigationController?.pushViewController(whatsNewVC, animated: true)
        whatsNewVC.isModalInPresentation = true
        if #available(iOS 15.0, *) {
            if let sheet = whatsNewVC.sheetPresentationController {
                
                sheet.animateChanges {
                    
                    sheet.detents = [.large()]
                    sheet.prefersGrabberVisible = true
                    sheet.preferredCornerRadius = 16
                }
            }
        } else {
            // Fallback on earlier versions
        }
        self.present(whatsNewVC, animated: true)
    }
    
    //MARK:-  Functions
}
