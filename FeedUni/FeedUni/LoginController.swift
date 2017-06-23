//
//  LoginController.swift
//  FeedUni
//
//  Created by giacomo osso on 21/06/17.
//  Copyright © 2017 Piero Silvestri. All rights reserved.
//

import UIKit
import SystemConfiguration

class LoginController: UIViewController {

    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var EmailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    
    @IBAction func LoginPressed(_ sender: UIButton) {
        if(isConnectedToNetwork()){
           
            
            
        }else{
            
            // create the alert
            let alert = UIAlertController(title: "Registrazione", message: "Non sei connesso ad internet", preferredStyle: UIAlertControllerStyle.alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "Riprova", style: UIAlertActionStyle.default, handler: { action in
                return;
            }))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)

        }
        
    }

    @IBAction func FacebookPressed(_ sender: UIButton) {
    }
    
    func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        
        return (isReachable && !needsConnection)
        
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
