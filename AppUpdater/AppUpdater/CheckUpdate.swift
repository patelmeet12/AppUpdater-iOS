//
//  CheckUpdate.swift
//  AppUpdater
//
//  Created by Apple iQlance on 15/09/2022.
//

import Foundation
import UIKit

enum VersionError: Error {
    case invalidBundleInfo, invalidResponse
}

class LookupResult: Decodable {
    var results: [AppInfo]
}

class AppInfo: Decodable {
    var version: String
    var trackViewUrl: String
}

class CheckUpdate: NSObject {
    
    static let shared = CheckUpdate()
    
    func showUpdate(withConfirmation: Bool) {
        DispatchQueue.global().async {
            self.checkVersion(force : !withConfirmation)
        }
    }
    
    private func checkVersion(force: Bool) {
        if let currentVersion = self.getBundle(key: "CFBundleShortVersionString") {
            _ = getAppInfo { (info, error) in
                if let appStoreAppVersion = info?.version {
                    if let error = error {
                        print("error getting app store version: ", error)
                    } else if appStoreAppVersion <= currentVersion {
                        print("Already on the last app version: ",currentVersion)
                    } else {
                        print("Needs update: AppStore Version: \(appStoreAppVersion) > Current version: ",currentVersion)
                        DispatchQueue.main.async {
                            let topController = APPDEL.window?.rootViewController ?? UIViewController()
                            topController.showAppUpdateAlert(Version: (info?.version)!, Force: force, AppURL: (info?.trackViewUrl)!)
                        }
                    }
                }
            }
        }
    }
    
    func getAppInfo(completion: @escaping (AppInfo?, Error?) -> Void) -> URLSessionDataTask? {
        
        guard let identifier = self.getBundle(key: "CFBundleIdentifier"),
              let url = URL(string: "http://itunes.apple.com/br/lookup?bundleId=\(identifier)") else {
            DispatchQueue.main.async {
                completion(nil, VersionError.invalidBundleInfo)
            }
            return nil
        }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            do {
                if let error = error { throw error }
                guard let data = data else { throw VersionError.invalidResponse }
                
                let result = try JSONDecoder().decode(LookupResult.self, from: data)
                print(result.results)
                guard let info = result.results.first else {
                    throw VersionError.invalidResponse
                }
                
                completion(info, nil)
            } catch {
                completion(nil, error)
            }
        }
        
        task.resume()
        return task
        
    }
    
    func getBundle(key: String) -> String? {
        
        guard let filePath = Bundle.main.path(forResource: "Info", ofType: "plist") else {
            fatalError("Couldn't find file 'Info.plist'.")
        }
        // 2 - Add the file to a dictionary
        let plist = NSDictionary(contentsOfFile: filePath)
        // Check if the variable on plist exists
        guard let value = plist?.object(forKey: key) as? String else {
            fatalError("Couldn't find key '\(key)' in 'Info.plist'.")
        }
        return value
    }
}

extension UIViewController {
    
    @objc func showAppUpdateAlert(Version : String, Force: Bool, AppURL: String) {
        
        guard let appName = CheckUpdate.shared.getBundle(key: "CFBundleName") else { return } //Bundle.appName()
        let alertTitle = "New version"
        let alertMessage = "A new version of \(appName) is available on AppStore. Update now!"
        
        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        
        if !Force {
            let notNowButton = UIAlertAction(title: "Not now", style: .default)
            alertController.addAction(notNowButton)
        }
        
        let updateButton = UIAlertAction(title: "Update", style: .default) { (action:UIAlertAction) in
            guard let url = URL(string: AppURL) else {
                return
            }
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
        
        alertController.addAction(updateButton)
        self.present(alertController, animated: true, completion: nil)
    }
}
