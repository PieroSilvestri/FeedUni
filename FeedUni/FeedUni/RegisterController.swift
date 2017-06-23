//
//  RegisterController.swift
//  FeedUni
//
//  Created by giacomo osso on 21/06/17.
//  Copyright © 2017 Piero Silvestri. All rights reserved.
//

import UIKit

class RegisterController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var ConfirmPasswordTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    
    
    override func viewDidLoad() {
               super.viewDidLoad()
        
    }
    
    
   
    @IBAction func SignInPressed(_ sender: UIButton) {
        if(!(validateEmail(enteredEmail: emailTextField.text!))){
            
            // create the alert
            let alert = UIAlertController(title: "Registrazione", message: "La mail non è valida", preferredStyle: UIAlertControllerStyle.alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "Riprova", style: UIAlertActionStyle.default, handler: { action in
                self.emailTextField.text=""
                return;
            }))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
            
            return;
        }else if(passwordTextField.text == ConfirmPasswordTextField.text){
            //creo json
            let email = self.emailTextField.text
            let password = self.passwordTextField.text
            
            let json = "{ \"email\": \"\(email ?? "")\" ,\"password\": \"\(password ?? "")\" }"
            print(json);
            
            let urlString = "http://apiunipn.parol.in/V1/user/signup"
            
            let url = URL(string: urlString)
            var request = URLRequest(url: url!)
            request.httpMethod = "POST"
            
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            var body = Data()
            
            body.append("--\(json)\r\n".data(using: String.Encoding.utf8)!)
            print()
            request.httpBody = json.data(using: .utf8)
            //request.setValue("Bearer 3252261a-215c-4078-a74d-2e1c5c63f0a1", forHTTPHeaderField: "Authorization")
           
           //alert con spinner
            
            customActivityIndicatory(self.view, startAnimate: true)
          
            
            URLSession.shared.dataTask(with:request) { (data, response, error) in
                
                if error != nil {
                    print(error.debugDescription)
                } else {
                    do {
                        
                        DispatchQueue.main.sync {
                            self.customActivityIndicatory(self.view, startAnimate: false)
                        }
                        
                        let response = try JSONSerialization.jsonObject(with: data!, options: []) as! NSDictionary
                        let error = response["error"]
                        
                        let accessToken = response["access_token"]
                        let id = response["id"]

                        print(error)
                        print(response)
                        
                        if((error) != nil){
                        DispatchQueue.main.sync {
                            self.customActivityIndicatory(self.view, startAnimate: false)
                            
                            // create the alert
                            let alert = UIAlertController(title: "Registrazione", message: "\(error ?? "")", preferredStyle: UIAlertControllerStyle.alert)
                            
                            // add an action (button)
                            alert.addAction(UIAlertAction(title: "Vai a login", style: UIAlertActionStyle.default, handler: { action in
                                self.GoToLoginPressed(nil)
                                return;
                            }))
                            
                            // show the alert
                            self.present(alert, animated: true, completion: nil)
                            
                            }
                        }else{
                            DispatchQueue.main.sync {
                                self.customActivityIndicatory(self.view, startAnimate: false)
                            }
                            
                            
                            //salvo nelle shared preferences info sull'utente
                            let defaults = UserDefaults.standard
                            defaults.setValue(self.emailTextField.text, forKey: "email")
                            defaults.setValue(accessToken, forKey: "token")
                            defaults.setValue(id, forKey: "id")
                            
                            DispatchQueue.main.sync {
                                let mapViewController = NewsController()
                                mapViewController.modalTransitionStyle = .flipHorizontal
                                self.present(mapViewController, animated: true, completion: nil)
                            }
                        }

                        
                    } catch let error as NSError {
                        print(error)
                        
                        }
                    
                    
                }
                
                }.resume()

            
            
        }else{
            // create the alert
            let alert = UIAlertController(title: "Registrazione", message: "Le password sono differenti", preferredStyle: UIAlertControllerStyle.alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "Riprova", style: UIAlertActionStyle.default, handler: { action in
                self.passwordTextField.text=""
                self.ConfirmPasswordTextField.text=""
                return;
            }))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)

        }
    }

    func getJsonFromUrl(page: Int){
        
        //self.flagDownload = false;
        
        
    }
    
    @IBAction func GoToLoginPressed(_ sender: UIButton?) {
        self.dismiss(animated: true, completion: {});
    }
    
    
    func validateEmail(enteredEmail:String) -> Bool {
        
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: enteredEmail)
        
    }
    
    func customActivityIndicatory(_ viewContainer: UIView, startAnimate:Bool? = true) -> UIActivityIndicatorView {
        let mainContainer: UIView = UIView(frame: viewContainer.frame)
        mainContainer.center = viewContainer.center
        mainContainer.backgroundColor = UIColor.black
       // mainContainer.backgroundColor = UIColor.init(coder: 0xFFFFFF)
        mainContainer.alpha = 0.5
        mainContainer.tag = 789456123
        mainContainer.isUserInteractionEnabled = false
        
        let viewBackgroundLoading: UIView = UIView(frame: CGRect(x:0,y: 0,width: 80,height: 80))
        viewBackgroundLoading.center = viewContainer.center
        viewBackgroundLoading.backgroundColor = UIColor.lightGray
        //viewBackgroundLoading.backgroundColor = UIColor.init(netHex: 0x444444)
        viewBackgroundLoading.alpha = 0.5
        viewBackgroundLoading.clipsToBounds = true
        viewBackgroundLoading.layer.cornerRadius = 15
        
        let activityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.frame = CGRect(x:0.0,y: 0.0,width: 40.0, height: 40.0)
        activityIndicatorView.activityIndicatorViewStyle =
            UIActivityIndicatorViewStyle.whiteLarge
        activityIndicatorView.center = CGPoint(x: viewBackgroundLoading.frame.size.width / 2, y: viewBackgroundLoading.frame.size.height / 2)
        if startAnimate!{
            viewBackgroundLoading.addSubview(activityIndicatorView)
            mainContainer.addSubview(viewBackgroundLoading)
            viewContainer.addSubview(mainContainer)
            activityIndicatorView.startAnimating()
        }else{
            for subview in viewContainer.subviews{
                if subview.tag == 789456123{
                    subview.removeFromSuperview()
                }
            }
        }
        return activityIndicatorView
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
