//
//  Constant.swift
//  AppUpdater
//
//  Created by Apple iQlance on 15/09/2022.
//

import Foundation
import UIKit

let APPDEL = UIApplication.shared.delegate as! AppDelegate

struct Constant {
    
    public static let kAppName  = "AppUpdater"
}

extension UIViewController {
    
    //Take UIImagePickerControllerDelegate & UINavigationControllerDelegate in particular viewcontroller and don't miss to dissmiss picker from this delegate methods
    func openImgePicker() {
        
        func openImagePicker(isCamera: Bool) {
            
            let picker = UIImagePickerController()
            picker.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
            picker.allowsEditing = false
            
            if isCamera {
                
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    picker.sourceType = .camera
                } else {
                    showAlertWithOkButton(message: "Camera is not supported in your device.")
                    return
                }
            } else {
                picker.sourceType = .photoLibrary
            }
            self.present(vc: picker)
        }
        
        let alertController = UIAlertController(title: "Please select option for pick image!", message: "", preferredStyle: .actionSheet)
        
        let actionCamera = UIAlertAction(title: "Camera", style: .default) { (actCam) in
            openImagePicker(isCamera: true)
        }
        alertController.addAction(actionCamera)
        
        let actionGallery = UIAlertAction(title: "Gallery", style: .default) { (actGal) in
            openImagePicker(isCamera: false)
        }
        alertController.addAction(actionGallery)
        
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel) { (actCam) in
            
        }
        alertController.addAction(actionCancel)
        
        self.present(vc: alertController)
    }
    func showAlertWithOkButton(message: String, _ completion: (() -> Void)? = nil) {
        
        let alert = UIAlertController(title: Constant.kAppName, message: message, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (alert) in
            completion?()
        }
        alert.addAction(OKAction)
        
        self.present(vc: alert)
    }
    func showAlertWithTwoButtons(message: String, btn1Name: String, btn2Name: String, completion: @escaping ((_ btnClickedIndex: Int) -> Void)) {
        
        let alert = UIAlertController(title: Constant.kAppName, message: message, preferredStyle: .alert)
        
        let action1 = UIAlertAction(title: btn1Name, style: .default) { (action1) in
            completion(1)
        }
        alert.addAction(action1)
        
        let action2 = UIAlertAction(title: btn2Name, style: .default) { (action2) in
            completion(2)
        }
        alert.addAction(action2)
        self.present(vc: alert)
    }
    func showAlertWithActionSheetButtons(message: String, btn1Name: String, btn2Name: String, btn3Name: String, completion: @escaping ((_ btnClickedIndex: Int) -> Void)) {
        
        let alert = UIAlertController(title: Constant.kAppName, message: message, preferredStyle: .actionSheet)
        
        let action1 = UIAlertAction(title: btn1Name, style: .default) { (action1) in
            completion(1)
        }
        alert.addAction(action1)
        
        let action2 = UIAlertAction(title: btn2Name, style: .default) { (action2) in
            completion(2)
        }
        alert.addAction(action2)
        
        let action3 = UIAlertAction(title: btn3Name, style: .cancel) { (action3) in
            completion(3)
        }
        alert.addAction(action3)
        self.present(vc: alert)
    }
    func showAlertWithThreeButtons(message: String, btn1Name: String, btn2Name: String, btn3Name: String, completion: @escaping ((_ btnClickedIndex: Int) -> Void)) {
        
        let alert = UIAlertController(title: Constant.kAppName, message: message, preferredStyle: .alert)
        
        let action1 = UIAlertAction(title: btn1Name, style: .default) { (action1) in
            completion(1)
        }
        alert.addAction(action1)
        
        let action2 = UIAlertAction(title: btn2Name, style: .default) { (action2) in
            completion(2)
        }
        alert.addAction(action2)
        
        let action3 = UIAlertAction(title: btn3Name, style: .cancel) { (action3) in
            completion(3)
        }
        alert.addAction(action3)
        self.present(vc: alert)
    }
    private func present(vc: UIViewController) {
        
        if let nav = self.navigationController {
            if let presentedVC = nav.presentedViewController {
                presentedVC.present(vc, animated: true, completion: nil)
            } else {
                self.navigationController?.present(vc, animated: true, completion: nil)
            }
        } else {
            self.present(vc, animated: true, completion: nil)
        }
    }
}
