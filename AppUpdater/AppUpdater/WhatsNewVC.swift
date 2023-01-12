//
//  WhatsNewVC.swift
//  AppUpdater
//
//  Created by Apple iQlance on 15/09/2022.
//

import UIKit

//https://apps.apple.com/us/app/mindmapping-resilience/id1626979283

class WhatsNewVC: UIViewController {
    
    //MARK:-  Outlets and Variable Declarations
    @IBOutlet weak var tblWhatsNew: UITableView!
    @IBOutlet weak var lblAboutUpdate: UILabel!
    
    private struct WhatsNew {
        
        let imgIcon: UIImage?
        let title: String?
        let subTitle: String?
    }
    
    private var arrOfWhatsNew = [WhatsNew]()
    
    private var finishedLoadingInitialTableCells = false
    
    //MARK:- 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            
            self.setWhatNewData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK:-  Buttons Clicked Action
    @IBAction func btnUpdateNowClicked(_ sender: UIButton) {
        
        if let currentVersion = CheckUpdate.shared.getBundle(key: "CFBundleShortVersionString") {
            _ = CheckUpdate.shared.getAppInfo { (info, error) in
                if let appStoreAppVersion = info?.version {
                    if let error = error {
                        print("error getting app store version: ", error)
                    } else if appStoreAppVersion <= currentVersion {
                        print("Already on the last app version: ",currentVersion)
                        DispatchQueue.main.async {
                            self.showAlertWithOkButton(message: "Already on the last app version: \(currentVersion)")
                        }
                    } else {
                        print("Needs update: AppStore Version: \(appStoreAppVersion) > Current version: ",currentVersion)
                        DispatchQueue.main.async {
                            self.showAppUpdateAlert(Version: (info?.version)!, Force: false, AppURL: (info?.trackViewUrl)!)
                        }
                    }
                }
            }
        }
        //dismiss(animated: true)
        //        let alertController = UIAlertController (title: "Title", message: "Go to Settings?", preferredStyle: .alert)
        //
        //        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
        //
        //            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
        //                return
        //            }
        //
        //            if UIApplication.shared.canOpenURL(settingsUrl) {
        //                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
        //                    print("Settings opened: \(success)") // Prints true
        //                })
        //            }
        //        }
        //        alertController.addAction(settingsAction)
        //        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        //        alertController.addAction(cancelAction)
        //
        //        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func btnLaterClicked(_ sender: UIButton) {
        
        //self.navigationController?.popViewController(animated: true)
        //CheckUpdate.shared.showUpdate(withConfirmation: true)
        self.dismiss(animated: true)
        
//        if let currentVersion = CheckUpdate.shared.getBundle(key: "CFBundleShortVersionString") {
//            _ = CheckUpdate.shared.getAppInfo { (info, error) in
//                if let appStoreAppVersion = info?.version {
//                    if let error = error {
//                        print("error getting app store version: ", error)
//                    } else if appStoreAppVersion <= currentVersion {
//                        print("Already on the last app version: ",currentVersion)
//                        DispatchQueue.main.async {
//                            self.showAlertWithOkButton(message: "Already on the last app version: \(currentVersion)")
//                        }
//                    } else {
//                        print("Needs update: AppStore Version: \(appStoreAppVersion) > Current version: ",currentVersion)
//                        DispatchQueue.main.async {
//                            self.showAppUpdateAlert(Version: (info?.version)!, Force: false, AppURL: (info?.trackViewUrl)!)
//                        }
//                    }
//                }
//            }
//        }
    }
    
    //MARK:-  Functions
    private func setWhatNewData() {
        
        if let currentVersion = CheckUpdate.shared.getBundle(key: "CFBundleShortVersionString") {
            
            self.lblAboutUpdate.text = "About Update V\(currentVersion)"
        }
        
        self.arrOfWhatsNew.append(WhatsNew(imgIcon: UIImage(systemName: "map.fill"), title: "Updated Map Style", subTitle: "An improved design makes it easier to navigate and explore the map."))
        
        self.arrOfWhatsNew.append(WhatsNew(imgIcon: UIImage(systemName: "mappin.and.ellipse"), title: "All-New Place Cards", subTitle: "Completely redesigned place cards make it easier to learn about and interact with places."))
        
        self.arrOfWhatsNew.append(WhatsNew(imgIcon: UIImage(systemName: "magnifyingglass"), title: "Improved Search", subTitle: "Finding places is now easier with filters and automatic updates when you're browsing results on the map."))
        
        self.tblWhatsNew.reloadData()
        self.tblWhatsNew.layoutIfNeeded()
    }
}

//MARK:-  UITableViewDataSource Methods
extension WhatsNewVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrOfWhatsNew.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "WhatsNewTableViewCell") as! WhatsNewTableViewCell
        
        let whatNew = arrOfWhatsNew[indexPath.row]
        cell.configureCell(img: whatNew.imgIcon ?? UIImage(), title: whatNew.title ?? "", subTitle: whatNew.subTitle ?? "")
        
        return cell
    }
}

//MARK:-  UITableViewDelegate Methods
extension WhatsNewVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        var lastInitialDisplayableCell = false
        
        //change flag as soon as last displayable cell is being loaded (which will mean table has initially loaded)
        if arrOfWhatsNew.count > 0 && !finishedLoadingInitialTableCells {
            if let indexPathsForVisibleRows = tableView.indexPathsForVisibleRows,
               let lastIndexPath = indexPathsForVisibleRows.last, lastIndexPath.row == indexPath.row {
                lastInitialDisplayableCell = true
            }
        }
        
        if !finishedLoadingInitialTableCells {
            
            if lastInitialDisplayableCell {
                finishedLoadingInitialTableCells = true
            }
            
            //animates the cell as it is being displayed for the first time
            cell.transform = CGAffineTransform(translationX: 0, y: 60/2)
            cell.alpha = 0
            
            UIView.animate(withDuration: 0.8, delay: 0.05*Double(indexPath.row), options: [.curveEaseInOut], animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0)
                cell.alpha = 1
            }, completion: nil)
        }
    }
}
